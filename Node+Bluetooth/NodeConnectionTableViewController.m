//
//  NodeConnectionTableViewController.m
//  Node+Bluetooth
//
//  Created by Patrick Sheehan on 3/21/15.
//  Copyright (c) 2015 Patrick Sheehan. All rights reserved.
//

#import "NodeConnectionTableViewController.h"

@interface NodeConnectionTableViewController ()

@end

@implementation NodeConnectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nodeConnectionHelper = [VTNodeConnectionHelper connectionHelperwithDelegate:self];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refreshDeviceList:)
                  forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.nodeConnectionHelper.allNodeDevices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"NodeDeviceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    
    CBPeripheral *peripheral = [self.nodeConnectionHelper.allNodeDevices objectAtIndex:indexPath.row];
    
    cell.textLabel.text = peripheral.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    CBPeripheral *peripheral = [self.nodeConnectionHelper.allNodeDevices objectAtIndex:indexPath.row];
    [self.nodeConnectionHelper connectDevice:peripheral forUseInBackground:NO];
}

#pragma mark - NodeConnectionHelperDelegate

- (void)nodeConnectionHelperDidUpdateNodeDeviceList {

    [self.tableView reloadData];
}

- (void)nodeConnectionHelperDidFinishScanning {

    [self.refreshControl endRefreshing];
}

- (void)nodeConnectionHelperDidConnectToPeripheral:(CBPeripheral *)peripheral {

    self.connectedDevice = [[VTNodeDevice alloc] initWithDelegate:self withDevice:peripheral];
}

#pragma mark - NodeDeviceDelegate

- (void)nodeDeviceIsReadyForCommunication:(VTNodeDevice *)device {
    
    NSLog(@"Node device is ready");
    [self performSegueWithIdentifier:@"postConnectionSegue" sender:device];
}

#pragma mark - Refreshing

-(void)refreshDeviceList:(UIRefreshControl *)refresh {

    [self.nodeConnectionHelper startScanAndRetrievalOfPeripherals];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if( [segue.destinationViewController respondsToSelector:@selector(setConnectedDevice:)] ) {
        [segue.destinationViewController setConnectedDevice:sender];
    }
}

@end
