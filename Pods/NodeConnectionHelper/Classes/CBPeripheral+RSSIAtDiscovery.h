#import <CoreBluetooth/CoreBluetooth.h>
#import <objc/runtime.h>

/**
 This category adds a property `rssiAtDiscovery` to the `CBPeripheral` class. This property is meant to hold the RSSI value of a `CBPeripheral` object at discovery time.
 */
@interface CBPeripheral (RSSIAtDiscovery)

/**-----------------------------------------------------------------------------
 * @name Properties
 * -----------------------------------------------------------------------------
 */
/**
 The RSSI value of this `CBPeripheral` object at discovery time.
 */
@property (nonatomic, strong) NSNumber *rssiAtDiscovery;

@end
