//
//  RightButtonListViewController.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 11/29/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import "RightButtonListViewController.h"

@interface RightButtonListViewController ()

@end

@implementation RightButtonListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setMode:RightBtnViewMode_ViewMode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setMode:(RightBtnViewMode)mode {
    _mode = mode;
    [_gimbleBtn setHidden:(mode == RightBtnViewMode_MissionMode)];
    [_exploreBtn setHidden:(mode == RightBtnViewMode_MissionMode)];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)exploreBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(exploreBtnActionInRBtnVC:)]) {
        [_delegate exploreBtnActionInRBtnVC:self];
    }
}

- (IBAction)gimbleBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(gimbleBtnActionInRBtnVC:)]) {
        [_delegate gimbleBtnActionInRBtnVC:self];
    }
}

- (IBAction)tolocationBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(tolocationBtnActionInRBtnVC:)]) {
        [_delegate tolocationBtnActionInRBtnVC:self];
    }
}

- (IBAction)stopBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(stopBtnActionInRBtnVC:)]) {
        [_delegate stopBtnActionInRBtnVC:self];
    }
}

- (IBAction)cleaningBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(cleaningBtnActionInRBtnVC:)]) {
        [_delegate cleaningBtnActionInRBtnVC:self];
    }
}
@end
