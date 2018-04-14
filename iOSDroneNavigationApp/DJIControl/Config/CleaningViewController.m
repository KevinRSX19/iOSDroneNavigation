//
//  CleaningViewController.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/20/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import "CleaningViewController.h"
#import "DemoUtility.h"

#import "WayPointModel.h"

#define ONE_METER_OFFSET (0.00000901315)

@interface CleaningViewController ()

@property (nonatomic) DJIWaypointMissionOperator *wpOperator;
@property (nonatomic) DJIWaypointMission *downloadMission;

@end

@implementation CleaningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _timeline = [[TimelineMissionController alloc] init];
    _g_height.text = @"10";
    _g_length.text = @"10";
    _flightInterval.text = @"7";
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.wpOperator removeListenerOfExecutionEvents:self];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.wpOperator = [[DJISDKManager missionControl] waypointMissionOperator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)uploadBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(uploadBtnActionInCleaningVC:)]) {
        [_delegate uploadBtnActionInCleaningVC:self];
    }
}

- (IBAction)startBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(startBtnActionInCleaningVC:)]) {
        [_delegate startBtnActionInCleaningVC:self];
//        if (_mode == 0)
    }
}

- (IBAction)cancelBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(cancelBtnActionInCleaningVC:)]) {
        [_delegate cancelBtnActionInCleaningVC:self];
    }
}

- (IBAction)stopEdit:(id)sender {
    [self.view endEditing:YES];
    self.flightSpeed.text = [NSString stringWithFormat:@"sin:%f,%f",sin([self.g_length.text doubleValue]*0.01745329),cos([self.g_length.text doubleValue]*0.01745329)];
    if ([self.flightInterval.text intValue]>10)
        self.flightInterval.text = @"10";
}

- (void)stopMission {
    [_timeline stopMission];
}

@end
