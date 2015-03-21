# Description
This library eliminates a lot of boiler plate code required to connect to NODE+ devices.
For more information on NODE+, visit http://www.variableinc.com

# Getting started

## Instantiate a new helper:
```
self.connection_helper = [VTNodeConnectionHelper connectionHelperwithDelegate:self];
```
The new helper will start finding NODE+ devices immediately.

## Implement delegate methods to know when the connection helper updates its device list:
```
 - (void)nodeConnectionHelperDidUpdateNodeDeviceList
 {
     [self.tableView reloadData];
     //The devices are in self.connection_helper.allNodeDevices
 } 

 - (void) nodeConnectionHelperDidFinishScanning
 {
     //Here you could stop a refresh control or UIActivity indicator
 }
```

## Call startScanAndRetrievalOfPeripherals to perform another scan
``` 
[self.connection_helper startScanAndRetrievalOfPeripherals];
```

## Connect to a device by calling
```
CBPeripheral *device = self.connection_helper.allNodeDevices.firstObject;
[self.connection_helper connectDevice:device forUseInBackground:NO];
```

## Do something once a connection is established
```
- (void)nodeConnectionHelperDidConnectToPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Connected to %@", peripheral.name);
}
```

## Disconnect from a device by calling
```
[self.connection_helper disconnectDevice:device];
```