//
//  TakeoffViewController.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/6/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import "TakeoffViewController.h"
#import "TakeoffControl.h"

@interface TakeoffViewController ()

@property (nonatomic, strong) TakeoffControl * takeoffC;

@end

@implementation TakeoffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _takeoffHint = @"Ensure that conditions are safe for takeoff. The aircraft will climb to an altitude of 4 ft. and hover in place.";
    [_takeoffMessage setText:_takeoffHint];
    _takeoffC = [[TakeoffControl alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getTakeoffHint {
    return _takeoffHint;
}

- (IBAction)takeoffBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(TakeoffBtnActionInTakeoffVC:)]) {
        [_delegate TakeoffBtnActionInTakeoffVC:self];
    }
}

- (IBAction)cancelBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(TakeoffBtnActionInTakeoffVC:)]) {
        [_delegate CancelBtnActionInTakeoffVC:self];
    }
}

- (void)executeTakeoff {
    NSLog(@"executing take off...");
    [_takeoffC executeTakeoff];
}

- (void)stopMission {
    [_takeoffC stopTakeoff];
}

@end
