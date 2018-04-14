//
//  ExploreConfigViewController.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/6/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import "ExploreConfigViewController.h"
#import "TimelineMissionController.h"

@interface ExploreConfigViewController ()

@property (nonatomic) TimelineMissionController * timeline;

@end

@implementation ExploreConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _timeline = [[TimelineMissionController alloc] init];
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

- (IBAction)startBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(startBtnActionInExploreVC:)]) {
        [_delegate startBtnActionInExploreVC:self];
        [_timeline initMission];
        [_timeline initExploreMission];
        [_timeline startMission];
    }
}

- (IBAction)cancelBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(cancelBtnActionInExploreVC:)]) {
        [_delegate cancelBtnActionInExploreVC:self];
        [_timeline stopMission];
    }
}

- (void)stopMission {
    [_timeline stopMission];
}

@end
