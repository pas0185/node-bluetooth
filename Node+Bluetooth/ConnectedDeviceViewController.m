//
//  ConnectedDeviceViewController.m
//  Node+Bluetooth
//
//  Created by Patrick Sheehan on 3/21/15.
//  Copyright (c) 2015 Patrick Sheehan. All rights reserved.
//

#import "ConnectedDeviceViewController.h"

@interface ConnectedDeviceViewController ()

@end

@implementation ConnectedDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated {
    
    self.connectedDevice.delegate = self;
    [self.connectedDevice setAccelerometerScale:VTNodeAccelerometerScale16g];
    [self.connectedDevice setStreamModeAcc:YES Gyro:NO Mag:NO
                                withPeriod:1
                              withLifetime:0
                   withTimestampingEnabled:YES];
}

#pragma mark - NodeDeviceDelegate

- (void) nodeDeviceDidUpdateAccReading:(VTNodeDevice *)device withReading:(VTSensorReading *)reading atTime:(NSDate *)
date {
    
    if(self.labelAccelerometer
       == Nil) {
        self.labelAccelerometer = [[UILabel alloc] initWithFrame:CGRectInset(self.view.bounds, 20, 50)];
        [self.view addSubview:self.labelAccelerometer];
    }
    self.labelAccelerometer.text = [NSString stringWithFormat:@"%.3f, %.3f, %.3f", reading.x, reading.y, reading.z];
}

@end
