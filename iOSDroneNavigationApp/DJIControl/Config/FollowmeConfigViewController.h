//
//  FollowmeConfigViewController.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/6/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DJISDK/DJISDK.h>
#import "FollowmeMissionController.h"
#import "FollowmeConfigModel.h"

@class FollowmeConfigViewController;

@protocol FollowmeConfigViewControllerDelegate<NSObject>

- (void)startBtnActionInFollowmeConfigVC:(FollowmeConfigViewController *)FollowmeVC;
- (void)cancelBtnActionInFollowmeConfigVC:(FollowmeConfigViewController *)FollowmeVC;

@end

@interface FollowmeConfigViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *distanceLimit;
@property (weak, nonatomic) IBOutlet UITextField *altitude;
@property (weak, nonatomic) IBOutlet UITextField *flySpeed;
@property (weak, nonatomic) IBOutlet UILabel *GPSSignal;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (nonatomic) FollowmeMissionController* followmeMission;
@property (nonatomic) FollowmeConfigModel *followmeModel;

@property (weak, nonatomic) id <FollowmeConfigViewControllerDelegate> delegate;

- (IBAction)startBtnAction:(id)sender;
- (IBAction)cancelBtnAction:(id)sender;

- (void)loadDefaultSettings:(FollowmeConfigModel *)setting;
- (void)startFollowmeMission:(FollowmeConfigModel *)setting;
- (void)stopMission;


- (void)updateDroneLocationDemo:(CLLocationCoordinate2D)drone;
- (NSString *)setGPSSignalLevel:(DJIGPSSignalLevel)level;

@end
