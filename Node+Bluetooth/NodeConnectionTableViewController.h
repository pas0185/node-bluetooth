//
//  NodeConnectionTableViewController.h
//  Node+Bluetooth
//
//  Created by Patrick Sheehan on 3/21/15.
//  Copyright (c) 2015 Patrick Sheehan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VTNodeConnectionHelper.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <Node_iOS/Node.h>

@interface NodeConnectionTableViewController : UITableViewController<VTNodeConnectionHelperDelegate, NodeDeviceDelegate>

@property (strong, nonatomic) VTNodeConnectionHelper *nodeConnectionHelper;
@property (strong, nonatomic) VTNodeDevice *connectedDevice;

@end
