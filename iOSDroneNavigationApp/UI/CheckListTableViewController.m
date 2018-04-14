//
//  CheckListTableViewController.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 11/30/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import "CheckListTableViewController.h"
#import "CheckListTableViewCell.h"

# define cellIdentifier @"CheckListTableViewCell"
# define Flight_Mode @"Flight Mode"
# define Compass @"Compass"
# define IMU_Status @"IMU"
# define ESC_Status @"ESC Status"
# define RC_Battery @"Remote Controller Battery"
# define AC_Battery @"Aircraft Battery"
# define AC_Battery_Temp @"Aircraft Battery Temperature"
# define Gimbal_Status @"Gimbal Status"
# define SD_Card_Capa @"Remaining SD Card Capacith"

@interface CheckListTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation CheckListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _checkListTable.estimatedRowHeight = 50;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [_checkListTable registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self generateData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [ _overallStatus removeAllObjects];
}

- (void)generateData{
    _dataArray = [NSMutableArray array];
    //    NSInteger count = arc4random() % 100 + 10;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:Flight_Mode forKey:@"checkName"];
    [dic setObject:@"" forKey:@"status"];
    [_dataArray addObject:dic];
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    [dic2 setObject:Compass forKey:@"checkName"];
    [dic2 setObject:@"Normal" forKey:@"status"];
    [_dataArray addObject:dic2];
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    [dic3 setObject:IMU_Status forKey:@"checkName"];
    [dic3 setObject:@"Normal" forKey:@"status"];
    [_dataArray addObject:dic3];
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
    [dic4 setObject:ESC_Status forKey:@"checkName"];
    [dic4 setObject:@"Normal" forKey:@"status"];
    [_dataArray addObject:dic4];
    NSMutableDictionary *dic5 = [NSMutableDictionary dictionary];
    [dic5 setObject:RC_Battery forKey:@"checkName"];
    [dic5 setObject:@"" forKey:@"status"];
    [_dataArray addObject:dic5];
    NSMutableDictionary *dic6 = [NSMutableDictionary dictionary];
    [dic6 setObject:AC_Battery forKey:@"checkName"];
    [dic6 setObject:@"N/A" forKey:@"status"];
    [_dataArray addObject:dic6];
    NSMutableDictionary *dic7 = [NSMutableDictionary dictionary];
    [dic7 setObject:AC_Battery_Temp forKey:@"checkName"];
    [dic7 setObject:@"N/A" forKey:@"status"];
    [_dataArray addObject:dic7];
    NSMutableDictionary *dic8 = [NSMutableDictionary dictionary];
    [dic8 setObject:Gimbal_Status forKey:@"checkName"];
    [dic8 setObject:@"Normal" forKey:@"status"];
    [_dataArray addObject:dic8];
    NSMutableDictionary *dic9 = [NSMutableDictionary dictionary];
    [dic9 setObject:SD_Card_Capa forKey:@"checkName"];
    [dic9 setObject:@"" forKey:@"status"];
    [_dataArray addObject:dic9];
    [_checkListTable reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.dic = [_dataArray objectAtIndex:indexPath.row];
    cell.contentView.backgroundColor = [UIColor darkGrayColor];
    return cell;
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString* cellIdentity =   @"checkListCell";//cell的标识
//    CheckListTableViewCell* cell = [CheckListTableViewCell initTableViewCell:tableView andCellIdentify:cellIdentity];//调用初始化方法
//    if (!cell) {
//        NSLog(@"cell null");
//    }
//    cell.checkNameLabel.text = @"123";
//    cell.dic = [_dataArray objectAtIndex:indexPath.row];
//    return cell;//返回该cell
//}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

- (void)loadFCStatus:(DroneStatusModel *)droneStatus {
    if (droneStatus.flightMode != nil) {
        NSMutableDictionary *flightMode = [NSMutableDictionary dictionary];
        [flightMode setObject:Flight_Mode  forKey:@"checkName"];
        [flightMode setObject:droneStatus.flightMode forKey:@"status"];
        [_dataArray replaceObjectAtIndex:0 withObject:flightMode];
    }
    if (droneStatus.compass != nil) {
        NSMutableDictionary *compass = [NSMutableDictionary dictionary];
        [compass setObject:Compass forKey:@"checkName"];
        [compass setObject:droneStatus.compass forKey:@"status"];
        [_dataArray replaceObjectAtIndex:1 withObject:compass];
    }
//    _overallStatus = [NSMutableDictionary dictionary];
//    [_overallStatus setObject:overallStatus forKey:@"checkName"];
//    [_overallStatus setObject:value forKey:@"status"];
//    [_dataArray addObject:_overallStatus];
    [_checkListTable reloadData];
}

- (void)loadIMUState:(DroneStatusModel *)droneStatus {
    if (droneStatus.IMU != nil) {
        NSMutableDictionary *imu = [NSMutableDictionary dictionary];
        [imu setObject:IMU_Status forKey:@"checkName"];
        [imu setObject:droneStatus.IMU forKey:@"status"];
        [_dataArray replaceObjectAtIndex:2 withObject:imu];
    }
}

- (void)loadRCState:(DroneStatusModel *)droneStatus {
    if (droneStatus.RCBattery != nil) {
        NSMutableDictionary *RC = [NSMutableDictionary dictionary];
        [RC setObject:RC_Battery forKey:@"checkName"];
        [RC setObject:droneStatus.RCBattery forKey:@"status"];
        [_dataArray replaceObjectAtIndex:5 withObject:RC];
    }
}

- (void)loadAircraftBatteryState:(DroneStatusModel *)droneStatus {
    if (droneStatus.aircraftBattery != nil) {
        NSMutableDictionary *AB = [NSMutableDictionary dictionary];
        [AB setObject:AC_Battery forKey:@"checkName"];
        [AB setObject:droneStatus.aircraftBattery forKey:@"status"];
        [_dataArray replaceObjectAtIndex:6 withObject:AB];
    }
    if (droneStatus.aircraftBatteryTemp != nil) {
        NSMutableDictionary *ABT = [NSMutableDictionary dictionary];
        [ABT setObject:AC_Battery_Temp forKey:@"checkName"];
        [ABT setObject:droneStatus.aircraftBatteryTemp forKey:@"status"];
        [_dataArray replaceObjectAtIndex:6 withObject:ABT];
    }
}

- (IBAction)closeBtnClicked:(id)sender {
    if ([_delegate respondsToSelector:@selector(closeBtnClickedInCheckListTVC:)]) {
        [_delegate closeBtnClickedInCheckListTVC:self];
    }
}
@end
