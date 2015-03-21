/*
 *	@file VTNodeConnectionHelper.h
 *
 *  @discussion Provides a helper class for discovering Node devices
 *
 *	@author Wade Gasior - Variable, Inc.
 */
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#pragma mark VTNodeConnectionHelperDelegate
/*!
 *  @protocol VTNodeConnectionHelperDelegate
 *
 *  @discussion The delegate of a {@link VTNodeConnectionHelper} object must adopt the <code>VTNodeConnectionHelperDelegate</code> protocol. The
 *              single required method is invoked when the connection helper updates its list of peripherals.
 *
 */
@protocol VTNodeConnectionHelperDelegate <NSObject>

/*!
 *  @method nodeConnectionHelperDidUpdateNodeDeviceList
 *
 *  @discussion     Invoked whenever the connection helper updates its list of Node devices. This will occur when an already connected device
 *                  is added to the list, or when an unconnected peripheral is disovered through a scan.
 *
 */
- (void) nodeConnectionHelperDidUpdateNodeDeviceList;

@optional
/*!
 *  @method nodeConnectionHelperDidFinishScanning
 *
 *  @discussion     Invoked when the connection helper has finished actively scanning for unconnected peripherals.
 *
 */
- (void) nodeConnectionHelperDidFinishScanning;

/*!
 *  @method nodeConnectionHelperDidConnectToPeripheral:
 *
 *  @discussion     Invoked when the connection helper has established a connection with a peripheral.
 * 
 *  @param peripheral The CBPeriphal that the connection helper connected to
 *
 */
- (void) nodeConnectionHelperDidConnectToPeripheral: (CBPeripheral *)peripheral;

/*!
 *  @method nodeConnectionHelperDidFailToConnectPeripheral:
 *
 *  @discussion     Invoked when the connection helper failed to connect with a peripheral.
 *
 *  @param peripheral The CBPeriphal that the connection helper disconnected from
 *
 *  @param error Error code (if valid) from CBCentral
 *
 */
- (void) nodeConnectionHelperDidFailToConnectPeripheral: (CBPeripheral *)peripheral error:(NSError *)error;

/*!
 *  @method nodeConnectionHelperDidDisconnectFromPeripheral:
 *
 *  @discussion     Invoked when the connection helper has cancelled a connection with a peripheral.
 *
 *  @param peripheral The CBPeriphal that the connection helper disconnected from
 *
 *  @param error Error code (if valid) from CBCentral
 *
 */
- (void) nodeConnectionHelperDidDisconnectFromPeripheral: (CBPeripheral *)peripheral error:(NSError *)error;

@end
#pragma mark -

@interface VTNodeConnectionHelper : NSObject
#pragma mark Properties
/**-----------------------------------------------------------------------------
 * @name Properties
 * -----------------------------------------------------------------------------
 */
/*!
 *  @property delegate
 *
 *  @discussion The delegate object that will receive connection helper events.
 *
 */
@property (weak, nonatomic) NSObject<VTNodeConnectionHelperDelegate> *delegate;

#pragma mark - Instance Methods
#pragma mark - Initialization
/**-----------------------------------------------------------------------------
 * @name Initialization
 * -----------------------------------------------------------------------------
 */
/*!
 *  @method connectionHelperwithDelegate:
 *
 *  @param delegate The delegate that will receive connection helper events.
 *
 *  @discussion     Inits and returns a VTNodeConnectionHelper. Upon init, the connection helper will immediately
 *                  begin updating its peripherals list by initiating a peripheral scan with a four second
 *                  timeout and retrieving the list of already connected peripherals.
 *
 */
+ (VTNodeConnectionHelper *) connectionHelperwithDelegate:(NSObject<VTNodeConnectionHelperDelegate> *) delegate;

/*!
 *  @method initWithDelegate:
 *
 *  @param delegate The delegate that will receive connection helper events.
 *
 *  @discussion     The initialization call. Upon init, the connection helper will immediately
 *                  begin updating its peripherals list by initiating a peripheral scan with a four second
 *                  timeout and retrieving the list of already connected peripherals.
 *
 */
- (id) initWithDelegate: (NSObject<VTNodeConnectionHelperDelegate> *) delegate;

#pragma mark - Initiating Device Discovery/Retrieval
/**-----------------------------------------------------------------------------
 * @name Initiating Device Discovery/Retrieval
 * -----------------------------------------------------------------------------
 */
/*!
 *  @method startScanAndRetrievalOfPeripherals
 *
 *  @discussion     Retrieves connected peripherals and starts a scan for unconnected peripherals with a four second timeout.
 *                  Will not have any effect if already scanning.
 *
 */
- (void) startScanAndRetrievalOfPeripherals;

#pragma mark - Accessing Device List
/**-----------------------------------------------------------------------------
  * @name Accessing Device List
  * -----------------------------------------------------------------------------
  */
/*!
 *  @method allNodeDevices
 *
 *	@return			A list of <code>CBPeripheral</code> objects sorted by RSSI at discovery time.
 *
 *  @discussion     Call this after receiving the <code>nodeConnectionHelperDidUpdatePeripheralsList</code> event to fetch
 *                  the connection helper's list of peripherals.
 *
 */
- (NSArray *)allNodeDevices;

#pragma mark - Device connection and disconnection
/**-----------------------------------------------------------------------------
 * @name Device connection and disconnection
 * -----------------------------------------------------------------------------
 */
/*!
 *  @method connectDevice:
 *
 *  @param device                   A CBPeripheral device to connect to
 *  @param backgroundEnabled        If your app uses backgrounding, set this to YES. Setting this to YES will enable background notifications
 *                                  for connection and data events.
 *
 *  @discussion     Call this to establish a Bluetooth low energy connection with a peripheral
 *
 */
- (void)connectDevice: (CBPeripheral *)device forUseInBackground: (BOOL) backgroundEnabled;

/*!
 *  @method disconnectDevice
 *
 *  @param device                   A CBPeripheral device to disconnect from
 *
 *  @discussion     Call this to cancel (disconnect) a Bluetooth low energy connection with a peripheral
 *
 */
- (void)disconnectDevice: (CBPeripheral *)device;

@end
