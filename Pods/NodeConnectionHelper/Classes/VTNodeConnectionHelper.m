#import "VTNodeConnectionHelper.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "CBPeripheral+RSSIAtDiscovery.h"

@interface VTNodeConnectionHelper () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager *cb_central_manager;
@property (strong, nonatomic) NSMutableArray *peripherals;
@property (nonatomic) BOOL isScanning;
@property (strong, nonatomic) NSMutableArray *peripherals_needing_rssi_update;
@end

@implementation VTNodeConnectionHelper

#pragma mark - Initialization
- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(id)initWithDelegate:(NSObject<VTNodeConnectionHelperDelegate> *)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        [self commonInit];
    }
    return self;
}

+ (VTNodeConnectionHelper *) connectionHelperwithDelegate:(NSObject<VTNodeConnectionHelperDelegate> *)delegate {
    VTNodeConnectionHelper *helper = [[VTNodeConnectionHelper alloc] initWithDelegate:delegate];
    return helper;
}

-(void) commonInit
{
    self.isScanning = NO;
    NSDictionary *central_options = @{CBCentralManagerOptionShowPowerAlertKey : @YES};
    self.cb_central_manager = [[CBCentralManager alloc] initWithDelegate:self queue:Nil options:central_options];
    self.peripherals = [NSMutableArray array];
    self.peripherals_needing_rssi_update = [NSMutableArray array];
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if(central.state == CBCentralManagerStatePoweredOn) {
        [self startScanAndRetrievalOfPeripherals];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    peripheral.rssiAtDiscovery = RSSI;
    if([self.peripherals containsObject:peripheral] == NO) {
        [self.peripherals addObject:peripheral];
        [self sortPeripheralsList];
        [self.delegate nodeConnectionHelperDidUpdateNodeDeviceList];
    }
}

#pragma mark - Peripheral Discovery
- (void) startScanAndRetrievalOfPeripherals {
    if(self.isScanning == NO) {
        self.peripherals = [NSMutableArray array];
        self.isScanning = YES;
        CBUUID *node_service_uuid = [CBUUID UUIDWithString:@"da2b84f1-6279-48de-bdc0-afbea0226079"];
        NSDictionary *options = @{CBCentralManagerScanOptionAllowDuplicatesKey : @NO,
                                  CBCentralManagerScanOptionSolicitedServiceUUIDsKey : @[node_service_uuid]};
        [self.cb_central_manager scanForPeripheralsWithServices:@[node_service_uuid] options:options];
        
        /* Stop the scan after some time */
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.cb_central_manager stopScan];
            if([self.delegate respondsToSelector:@selector(nodeConnectionHelperDidFinishScanning)]) {
                [self.delegate nodeConnectionHelperDidFinishScanning];
            }
            self.isScanning = NO;
        });
        
        /* Also retrieve already connected peripherals */
        [self fetchConnectedPeripherals];
    }
}

-(void)fetchConnectedPeripherals {
    CBUUID *node_service_uuid = [CBUUID UUIDWithString:@"da2b84f1-6279-48de-bdc0-afbea0226079"];
    
    NSArray *connected_peripherals = [self.cb_central_manager retrieveConnectedPeripheralsWithServices:@[node_service_uuid]];
    
    for(CBPeripheral *peripheral in connected_peripherals) {
        if(![self.peripherals_needing_rssi_update containsObject:peripheral] && peripheral.state == CBPeripheralStateDisconnected) {
            [self.peripherals_needing_rssi_update addObject:peripheral];
            peripheral.delegate = self;
            [self connectDevice:peripheral forUseInBackground:NO];
        }
    }
}

#pragma mark - Device List Access
- (void) sortPeripheralsList {
    [self.peripherals sortUsingComparator:^NSComparisonResult(CBPeripheral *p1, CBPeripheral *p2) {
        return ([p1.rssiAtDiscovery intValue] > [p2.rssiAtDiscovery intValue]) ? NSOrderedAscending : NSOrderedDescending;
    }];
}

- (NSArray *)allNodeDevices {
    return [NSArray arrayWithArray:self.peripherals];
}

#pragma mark - Connection
- (void)connectDevice: (CBPeripheral *)device forUseInBackground: (BOOL) backgroundEnabled {
    NSNumber *bg_enabled = [NSNumber numberWithBool:backgroundEnabled];
    NSDictionary *options = @{
                              CBConnectPeripheralOptionNotifyOnConnectionKey : bg_enabled,
                              CBConnectPeripheralOptionNotifyOnDisconnectionKey : bg_enabled,
                              CBConnectPeripheralOptionNotifyOnNotificationKey : bg_enabled
                              };
    
    if([self.peripherals_needing_rssi_update containsObject:device] == NO) {
        [self.cb_central_manager stopScan];
    }
    [self.cb_central_manager connectPeripheral:device options:options];
}

- (void)disconnectDevice: (CBPeripheral *)device {
    [self.cb_central_manager cancelPeripheralConnection:device];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if([self.peripherals_needing_rssi_update containsObject:peripheral]) {
        [peripheral readRSSI];
    }
    else {
        if([self.delegate respondsToSelector:@selector(nodeConnectionHelperDidConnectToPeripheral:)]) {
            [self.delegate nodeConnectionHelperDidConnectToPeripheral:peripheral];
        }
    }
}

- ( void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if([self.peripherals_needing_rssi_update containsObject:peripheral]) {
        [self.peripherals_needing_rssi_update removeObject:peripheral];
        [self.peripherals addObject:peripheral];
        [self sortPeripheralsList];
        [self.delegate nodeConnectionHelperDidUpdateNodeDeviceList];

    } else {
        if([self.delegate respondsToSelector:@selector(nodeConnectionHelperDidDisconnectFromPeripheral:error:)]) {
            [self.delegate nodeConnectionHelperDidDisconnectFromPeripheral:peripheral error:error];
        }
    }
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if([self.delegate respondsToSelector:@selector(nodeConnectionHelperDidFailToConnectPeripheral:error:)])
        [self.delegate nodeConnectionHelperDidFailToConnectPeripheral:peripheral error:error];
}

#pragma mark - CBPeripheralDelegate
- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    if([self.peripherals_needing_rssi_update containsObject:peripheral]) {
        [self disconnectDevice:peripheral];
        peripheral.rssiAtDiscovery = peripheral.RSSI;
    }
}

@end


























