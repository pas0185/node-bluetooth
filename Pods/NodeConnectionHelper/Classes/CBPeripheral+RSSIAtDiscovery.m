#import "CBPeripheral+RSSIAtDiscovery.h"

static char const * const kRssiAtDiscoveryKey = "kRssiAtDiscoveryKey";

@implementation CBPeripheral (RSSIAtDiscovery)

-(NSNumber*) rssiAtDiscovery {
    // default if nil before returning
    NSNumber *rssi = objc_getAssociatedObject(self, kRssiAtDiscoveryKey);
    if(rssi == nil) rssi = [NSNumber numberWithInt:-120];
    return rssi;
}

-(void) setRssiAtDiscovery:(NSNumber*)rssiAtDiscovery {
    objc_setAssociatedObject(self, kRssiAtDiscoveryKey, rssiAtDiscovery, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
