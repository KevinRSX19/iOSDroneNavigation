//
//  FollowmeConfigViewController.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/6/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import "FollowmeConfigViewController.h"

@interface FollowmeConfigViewController ()

@end

@implementation FollowmeConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _followmeMission = [[FollowmeMissionController alloc] init];
//    [_followmeMission getDefaultSettings];
    _altitude.text = @"";
    _flySpeed.text = @"";
    _distanceLimit.text = @"15";
    self.startBtn.enabled = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stopedit:(id)sender {
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    if ([_GPSSignal.text isEqualToString:@"Strong"]) {
        [_startBtn setEnabled:YES];
//    } else {
//        [_startBtn setEnabled:NO];
//    }
    NSLog(@"follow me view appear!");
}

- (void)loadDefaultSettings:(FollowmeConfigModel *)setting {
    self.followmeModel = setting;
    [self.altitude setText:setting.maxFlyHeight];
    [self.flySpeed setText:setting.maxFlySpeed];
}

- (void)stopMission {
    [_followmeMission stopFollowmeMission];
}

- (NSString *)setGPSSignalLevel:(DJIGPSSignalLevel)level {
    NSString *gps =[[self class] descriptionForGPSLevel:level];
    _GPSSignal.text = gps;
    return gps;
}

- (IBAction)startBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(startBtnActionInFollowmeConfigVC:)]) {
        [_delegate startBtnActionInFollowmeConfigVC:self];
        
        if (![self.altitude.text isEqualToString:@""]) {
            self.followmeModel.maxFlyHeight = self.altitude.text;
        }
        if (![self.flySpeed.text isEqualToString:@""]) {
            self.followmeModel.maxFlySpeed = self.flySpeed.text;
        }
        
        if (![self.distanceLimit.text isEqualToString:@""]) {
            [self.followmeMission loadDistanceLimit:[self.distanceLimit.text doubleValue]];
        }
        
        [self startFollowmeMission:self.followmeModel];
        
        _altitude.text = @"";
        _flySpeed.text = @"";
    }
}

- (void)startFollowmeMission:(FollowmeConfigModel *)setting {
    NSLog(@"init follow me");
    [_followmeMission setFollowmeSettings:setting];
    
    NSLog(@"start followme");
    [_followmeMission startFollowmeMission];
}

- (IBAction)cancelBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(cancelBtnActionInFollowmeConfigVC:)]) {
        [_delegate cancelBtnActionInFollowmeConfigVC:self];
    }
}

- (void)updateDroneLocationDemo:(CLLocationCoordinate2D)drone {
//    CLLocationCoordinate2D t = [self.followmeMission updateDroneLocationDemo:drone];
    [self.followmeMission updateDroneLocationDemo:drone];
//    self.flySpeed.text = [NSString stringWithFormat:@"%f",t.latitude];
    if (![self.startBtn isEnabled]) {
        [self.startBtn setEnabled:YES];
    }
}

+(NSString *)descriptionForGPSLevel:(DJIGPSSignalLevel)level {
    switch (level) {
        case DJIGPSSignalLevel0:
            return @"Very bed";
        case DJIGPSSignalLevel1:
            return @"Very Poor";
        case DJIGPSSignalLevel2:
            return @"Poor";
        case DJIGPSSignalLevel3:
            return @"Good";
        case DJIGPSSignalLevel4:
            return @"Very good";
        case DJIGPSSignalLevel5:
            return @"Strong";
        case DJIGPSSignalLevelNone:
            return @"Unknown";
    }
}

@end
