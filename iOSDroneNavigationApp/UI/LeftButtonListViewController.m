//
//  LeftButtonListViewController.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 11/29/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import "LeftButtonListViewController.h"

@interface LeftButtonListViewController ()

@end

@implementation LeftButtonListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setMode:DJIGSViewMode_ViewMode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setMode:(DJIGSViewMode)mode
{
    _mode = mode;
    [_takeoffBtn setHidden:(mode == DJIGSViewMode_MissionMode)];
    [_landingBtn setHidden:(mode == DJIGSViewMode_MissionMode)];
    [_followmeBtn setHidden:(mode == DJIGSViewMode_MissionMode)];
}

- (IBAction)takeoffBtnAction:(id)sender {
    NSLog(@"1");
    if ([_delegate respondsToSelector:@selector(takeoffBtnActionInLBtnVC:)]) {
        NSLog(@"3");
        [_delegate takeoffBtnActionInLBtnVC:self];
        NSLog(@"2");
    }
}

- (IBAction)landingBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(landingBtnActionInLBtnVC:)]) {
        [_delegate landingBtnActionInLBtnVC:self];
    }
}

- (IBAction)followmeBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(followMeBtnActionInLBtnVC:)]) {
        [_delegate followMeBtnActionInLBtnVC:self];
    }
}
@end
