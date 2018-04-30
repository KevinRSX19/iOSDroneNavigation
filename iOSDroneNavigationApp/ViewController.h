//
//  ViewController.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 11/17/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MissionMode) {
    MissionMode_Nothing,
    MissionMode_TakeOff,
    MissionMode_Landing,
    MissionMode_GoHome,
    MissionMode_Followme,
    MissionMode_ToLocation,
    MissionMode_Explore,
    MissionMode_Cleaning,
};

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *horizonSpeed;
@property (weak, nonatomic) IBOutlet UILabel *vertialSpeed;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabal;
@property (weak, nonatomic) IBOutlet UILabel *RCSignalLabel;
@property (weak, nonatomic) IBOutlet UILabel *VideoQualityLabel;
@property (weak, nonatomic) IBOutlet UILabel *BatteryLabel;
@property (weak, nonatomic) IBOutlet UIView *topBarView;

@end

