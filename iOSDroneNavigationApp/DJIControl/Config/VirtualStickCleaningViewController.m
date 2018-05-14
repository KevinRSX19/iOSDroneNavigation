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
@property float sum;
@property float processCount;
@property float width;  //graffiti cleaning field width
@property float height; //grafftii cleaning field height
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

- (void)startVSCleaning:(float)width height:(float)height cleaningMode:(CleaningMode)mode {
    [self setMode:mode];
    [self setProcess:CleaningProcess_Lineward];
    _width = width;
    _height = height;
    [self startUpdateTimer];
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
    NSLog(@"Cleaning timer ticked!!!!");
    //calculate max_distance = maxSpeed * updateTimeInterval
    if (_mode == CleaningMode_VerMode) {
        _CleaningDirection = 1;
        if (_process == CleaningProcess_Lineward) {
            float temp = 0.5 * _rollSpeedControl.value + _sum;  //timeInterval * speed, temp = cleaning progress including current action
            if (temp<_width) { //drone keep flying with width
                NSLog(@"Drone flying along width, sum = %f", _sum*_CleaningDirection);
                [_vsController setXVelocity:self.rollSpeedControl.value*_CleaningDirection setThrottle:0];
                _sum = temp;
            } else if (temp>=_width){ //drone flying to the end of width
                float tempSpeed = (_width-_sum)/0.5;
                NSLog(@"Drone flying to the end of width, sum = %f, width = %f", _sum*_CleaningDirection,_width);
                if (tempSpeed > self.rollSpeedControl.value) {
                    DDLogError(@"VSCleaning, Speed Calculation Error! TempSpeed = %f > Speed = %f",tempSpeed, self.rollSpeedControl.value);
                    tempSpeed = self.rollSpeedControl.value;
                }
                [_vsController setXVelocity:tempSpeed*_CleaningDirection setThrottle:0];
                _sum = 0;
                [self setProcess:CleaningProcess_LineChange];
            }
        } else if(_process == CleaningProcess_LineChange) {
            float temp = 0.5 * _descendRangeControl.value + _processCount;
            if (temp > _height) {
                NSLog(@"Drone finished cleaning, this is the %f time, height is %f.",_processCount,_height);
                [_vsController setXVelocity:0 setThrottle:0];
                [self stopUpdateTimer];
                DDLogInfo(@"Virtual Stick Cleaning Mission Finished");
                [self.stopBtn setTitle:@"Finished" forState:UIControlStateNormal];
            } else {
                NSLog(@"Drone changing line, this is the %f time, cleaning deriction is %d",_processCount,_CleaningDirection);
                [_vsController setXVelocity:0 setThrottle:self.descendRangeControl.value];
                _processCount += temp;
                _CleaningDirection = 0-_CleaningDirection;
                [self setProcess:CleaningProcess_Lineward];
            }
        }
    } else if(_mode == CleaningMode_HoriMode) {
        _CleaningDirection = -1;
        if (_process == CleaningProcess_Lineward) {
            float temp = 0.5 * _rollSpeedControl.value + _sum;  //timeInterval * speed
            if (temp<_height) { //drone keep flying with width
                [_vsController setXVelocity:0 setThrottle:self.rollSpeedControl.value*_CleaningDirection];
                _sum = temp;
            } else if (temp>=_height){ //drone flying to the end of width
                float tempSpeed = (_height-_sum)/0.5;
                if (tempSpeed > self.rollSpeedControl.value) {
                    DDLogError(@"VSCleaning, Speed Calculation Error! TempSpeed = %f > Speed = %f",tempSpeed, self.rollSpeedControl.value);
                    tempSpeed = self.rollSpeedControl.value;
                }
                [_vsController setXVelocity:0 setThrottle:tempSpeed*_CleaningDirection];
                _sum = 0;
                [self setProcess:CleaningProcess_LineChange];
            }
        } else if(_process == CleaningProcess_LineChange) {
            float temp = 0.5 * _descendRangeControl.value + _processCount;
            if (temp > _width) {
                [_vsController setXVelocity:0 setThrottle:0];
                [self stopUpdateTimer];
                DDLogInfo(@"Virtual Stick Cleaning Mission Finished");
                [self.stopBtn setTitle:@"Finished" forState:UIControlStateNormal];
            } else {
                [_vsController setXVelocity:self.descendRangeControl.value setThrottle:0];
                _processCount += temp;
                _CleaningDirection = 0-_CleaningDirection;
                [self setProcess:CleaningProcess_Lineward];
            }
        }
    }
}

- (void)stopMission {
    [self stopUpdateTimer];
    [_vsController setXVelocity:0 setThrottle:0];
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
