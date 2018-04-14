//
//  CheckListTableViewController.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 11/30/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DroneStatusModel.h"

@class CheckListTableViewController;

@protocol CheckListTableViewControllerDelegate<NSObject>

- (void) closeBtnClickedInCheckListTVC:(CheckListTableViewController *)CheckListTVC;

@end

@interface CheckListTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UITableView *checkListTable;

@property (strong, nonatomic) NSMutableDictionary* overallStatus;

@property (weak, nonatomic) id <CheckListTableViewControllerDelegate> delegate;

- (IBAction)closeBtnClicked:(id)sender;

- (void)loadFCStatus:(DroneStatusModel *)droneStatus;
- (void)loadIMUState:(DroneStatusModel *)droneStatus;
- (void)loadRCState:(DroneStatusModel *)droneStatus;
- (void)loadAircraftBatteryState:(DroneStatusModel *)droneStatus;

@end
