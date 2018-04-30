//
//  VirtualStickCleaningViewController.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 2018/4/29.
//  Copyright © 2018 Kaixuan Wang. All rights reserved.
//

#import "VirtualStickCleaningViewController.h"

@interface VirtualStickCleaningViewController ()

@property (nonatomic, strong) NSTimer* updateTimer;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property double sum;
@property double processCount;
@property double width;
@property double height;
@property int CleaningDirection;

@end

@implementation VirtualStickCleaningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _sum = 0;
    _processCount = 0;
    _CleaningDirection = 1;
    _vsController = [[VirtualStickController alloc] init];
    _rollSpeedValue.text = [NSString stringWithFormat:@"%f",_rollSpeedControl.value];
    _descendRangeValue.text = [NSString stringWithFormat:@"%f",_descendRangeControl.value];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startVSCleaning:(double)width height:(double)height cleaningMode:(CleaningMode)mode {
    [self setMode:mode];
    [self setProcess:CleaningProcess_Lineward];
    _width = width;
    _height = height;
}

- (void)setMode:(CleaningMode)mode {
    _mode = mode;
}

- (void)setProcess:(CleaningProcess)process {
    _process = process;
}

- (IBAction)rollSpeedAction:(id)sender {
    _rollSpeedValue.text = [NSString stringWithFormat:@"%f",_rollSpeedControl.value];
    if (_mode == CleaningMode_VerMode) {
        [_vsController setXVelocity:self.rollSpeedControl.value];
    } else if (_mode == CleaningMode_HoriMode) {
        [_vsController setThrottle:self.rollSpeedControl.value];
    }
}

- (IBAction)descendRangeAction:(id)sender {
    _descendRangeValue.text = [NSString stringWithFormat:@"%f",_descendRangeControl.value];
    if (_mode == CleaningMode_VerMode) {
        [_vsController setThrottle:self.rollSpeedControl.value];
    } else if (_mode == CleaningMode_HoriMode) {
        [_vsController setXVelocity:self.rollSpeedControl.value];
    }
}

-(void) startUpdateTimer {
    if (self.updateTimer == nil) {
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onUpdateTimerTicked:) userInfo:nil repeats:YES];
    }
    
    [self.updateTimer fire];
}

-(void) stopUpdateTimer {
    if (self.updateTimer) {
        [self.updateTimer invalidate];
        self.updateTimer = nil;
    }
}

-(void) onUpdateTimerTicked:(id)sender
{
    //calculate max_distance = maxSpeed * updateTimeInterval
    if (_mode == CleaningMode_VerMode) {
        _CleaningDirection = 1;
        if (_process == CleaningProcess_Lineward) {
            double temp = 0.5 * _rollSpeedControl.value + _sum;  //timeInterval * speed
            if (temp<_width) { //drone keep flying with width
                [_vsController setXVelocity:self.rollSpeedControl.value*_CleaningDirection setThrottle:0];
                _sum += temp;
            } else if (temp>=_width){ //drone flying to the end of width
                double tempSpeed = (_width-_sum)/0.5;
                if (tempSpeed > self.rollSpeedControl.value) {
                    DDLogError(@"VSCleaning, Speed Calculation Error! TempSpeed = %f > Speed = %f",tempSpeed, self.rollSpeedControl.value);
                    tempSpeed = self.rollSpeedControl.value;
                }
                [_vsController setXVelocity:tempSpeed*_CleaningDirection setThrottle:0];
                _sum = 0;
                [self setProcess:CleaningProcess_LineChange];
            }
        } else if(_process == CleaningProcess_LineChange) {
            double temp = 0.5 * _descendRangeControl.value + _processCount;
            if (temp >= _height) {
                [_vsController setXVelocity:0 setThrottle:0];
                [self stopUpdateTimer];
                DDLogInfo(@"Virtual Stick Cleaning Mission Finished");
                [self.stopBtn setTitle:@"Finished" forState:UIControlStateNormal];
            } else {
                [_vsController setXVelocity:0 setThrottle:self.descendRangeControl.value];
                _processCount += temp;
                _CleaningDirection *= -1;
                [self setProcess:CleaningProcess_Lineward];
            }
        }
    } else if(_mode == CleaningMode_HoriMode) {
        _CleaningDirection = -1;
        if (_process == CleaningProcess_Lineward) {
            double temp = 0.5 * _rollSpeedControl.value + _sum;  //timeInterval * speed
            if (temp<_width) { //drone keep flying with width
                [_vsController setXVelocity:0 setThrottle:self.rollSpeedControl.value*_CleaningDirection];
                _sum += temp;
            } else if (temp>=_width){ //drone flying to the end of width
                double tempSpeed = (_width-_sum)/0.5;
                if (tempSpeed > self.rollSpeedControl.value) {
                    DDLogError(@"VSCleaning, Speed Calculation Error! TempSpeed = %f > Speed = %f",tempSpeed, self.rollSpeedControl.value);
                    tempSpeed = self.rollSpeedControl.value;
                }
                [_vsController setXVelocity:0 setThrottle:tempSpeed*_CleaningDirection];
                _sum = 0;
                [self setProcess:CleaningProcess_LineChange];
            }
        } else if(_process == CleaningProcess_LineChange) {
            double temp = 0.5 * _descendRangeControl.value + _processCount;
            if (temp >= _height) {
                [_vsController setXVelocity:0 setThrottle:0];
                [self stopUpdateTimer];
                DDLogInfo(@"Virtual Stick Cleaning Mission Finished");
                [self.stopBtn setTitle:@"Finished" forState:UIControlStateNormal];
            } else {
                [_vsController setXVelocity:self.descendRangeControl.value setThrottle:0];
                _processCount += temp;
                _CleaningDirection *= -1;
                [self setProcess:CleaningProcess_Lineward];
            }
        }
    }
}

- (void)stopMission {
    [_vsController setXVelocity:0 setThrottle:0];
    [self stopUpdateTimer];
}

- (IBAction)stopCleaningAction:(id)sender {
    if ([self.stopBtn.titleLabel  isEqual: @"STOP"]) {
        [_vsController setXVelocity:0 setThrottle:0];
        [self stopUpdateTimer];
    }
    if ([_delegate respondsToSelector:@selector(stopCleaningActionInVSCleaningVC:)]) {
        [_delegate stopCleaningActionInVSCleaningVC:self];
    }
}

@end
