//
//  LandingViewController.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/6/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import "LandingViewController.h"
#import "DJIController.h"

@interface LandingViewController ()

@property (nonatomic) DJIController * controller;

@end

@implementation LandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _controller = [[DJIController alloc] init];
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

- (IBAction)landingBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(landingBtnActionInLandingVC:)]) {
        [_delegate landingBtnActionInLandingVC:self];
    }
}

- (IBAction)cancelBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(cancelBtnActionInLandingVC:)]) {
        [_delegate cancelBtnActionInLandingVC:self];
    }
}

- (void)executeLanding {
    [self.controller onLandButtonClicked];
}

- (void)stopGoHome {
    [self.controller cancelGoHome];
}

- (void)executeGoHome {
    [self.controller onGoHomeButtonClicked];
}

- (void)stopMission {
    [self.controller cancelLanding];
}

@end
