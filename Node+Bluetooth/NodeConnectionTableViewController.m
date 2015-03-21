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

#pragma mark - NodeConnectionHelperDelegate

- (void)nodeConnectionHelperDidUpdateNodeDeviceList {

    [self.tableView reloadData];
}

- (void)nodeConnectionHelperDidFinishScanning {

    [self.refreshControl endRefreshing];
}
#pragma mark - Refreshing

-(void)refreshDeviceList:(UIRefreshControl *)refresh {

    [self.nodeConnectionHelper startScanAndRetrievalOfPeripherals];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
