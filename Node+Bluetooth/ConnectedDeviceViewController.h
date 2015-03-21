//
//  ConnectedDeviceViewController.h
//  Node+Bluetooth
//
//  Created by Patrick Sheehan on 3/21/15.
//  Copyright (c) 2015 Patrick Sheehan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Node_iOS/Node.h>

@interface ConnectedDeviceViewController : UIViewController<NodeDeviceDelegate>

@property (strong, nonatomic) VTNodeDevice *connectedDevice;

@end
