//
//  GimbleViewController.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/6/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import "GimbleViewController.h"
#import "DemoUtility.h"
#import <DJISDK/DJISDK.h>
#import "DJIGimbal+CapabilityCheck.h"

@interface GimbleViewController ()

@property (assign, nonatomic) NSNumber *pitchRotation;
@property (assign, nonatomic) NSNumber *yawRotation;
@property (assign, nonatomic) NSNumber *rollRotation;
@property (weak, nonatomic) IBOutlet UILabel *minLabal;
@property (weak, nonatomic) IBOutlet UILabel *maxLabal;

@end

@implementation GimbleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupRotationStructs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupRotationStructs {
     DJIGimbal* gimbal = [DemoUtility fetchGimbal];
     self.pitchRotation = [gimbal isFeatureSupported:DJIGimbalParamAdjustPitch] ? @(0) : nil;
     self.yawRotation = [gimbal isFeatureSupported:DJIGimbalParamAdjustYaw] ? @(0) : nil;
     self.rollRotation = [gimbal isFeatureSupported:DJIGimbalParamAdjustRoll] ? @(0) : nil;
    [self.maxLabal setText:[NSString stringWithFormat:@"%@",self.yawRotation]];
 }

- (IBAction)subBtnAction:(id)sender {
    DJIGimbal* gimbal = [DemoUtility fetchGimbal];
    if (gimbal == nil) {
        return;
    }
    
    NSString *key = [self getCorrespondingKeyWithButton:_attitude];
    if ([key isEqualToString:DJIGimbalParamAdjustPitch]) {
        self.pitchRotation = @(-10);
    }
    else if ([key isEqualToString:DJIGimbalParamAdjustYaw]) {
        self.yawRotation = @(-10);
    }
    else if ([key isEqualToString:DJIGimbalParamAdjustRoll]) {
        self.rollRotation = @(-10);
    }
    
    [self sendRelateRotateGimbalCommand];
}

- (IBAction)addBtnAction:(id)sender {
    DJIGimbal* gimbal = [DemoUtility fetchGimbal];
    if (gimbal == nil) {
        return;
    }
    
    NSString *key = [self getCorrespondingKeyWithButton:_attitude];
//    NSInteger max = [[gimbal getParamMax:key] integerValue];
    if ([key isEqualToString:DJIGimbalParamAdjustPitch]) {
        self.pitchRotation = @(10);
    }
    else if ([key isEqualToString:DJIGimbalParamAdjustYaw]) {
        self.yawRotation = @(10);
    }
    else if ([key isEqualToString:DJIGimbalParamAdjustRoll]) {
        self.rollRotation = @(10);
    }
    
    [self sendRelateRotateGimbalCommand];
}

- (IBAction)minBtnAction:(id)sender {
    DJIGimbal* gimbal = [DemoUtility fetchGimbal];
    if (gimbal == nil) {
        return;
    }
    
    NSString *key = [self getCorrespondingKeyWithButton:_attitude];
    NSInteger min = [[gimbal getParamMin:key] integerValue];
    
    if ([key isEqualToString:DJIGimbalParamAdjustPitch]) {
        self.pitchRotation = @(min);
    }
    else if ([key isEqualToString:DJIGimbalParamAdjustYaw]) {
        self.yawRotation = @(min);
    }
    else if ([key isEqualToString:DJIGimbalParamAdjustRoll]) {
        self.rollRotation = @(min);
    }
    
    [self sendRotateGimbalCommand];
    
    //    [_maxBtn setEnabled:YES];
    //    [_addBtn setEnabled:YES];
    //    [_minBtn setEnabled:NO];
    //    [_subBtn setEnabled:NO];
}

- (IBAction)maxBtnAction:(id)sender {
    DJIGimbal* gimbal = [DemoUtility fetchGimbal];
    if (gimbal == nil) {
        return;
    }
    
    NSString *key = [self getCorrespondingKeyWithButton:_attitude];
    self.minLabal.text = key;
    NSInteger max = [[gimbal getParamMax:key] integerValue];
//    NSInteger max = [[gimbal getParamMax:DJIGimbalParamAdjustYaw] integerValue];
    [self.maxLabal setText:[NSString stringWithFormat:@"%ld",(long)max]];
    
    if ([key isEqualToString:DJIGimbalParamAdjustPitch]) {
        self.pitchRotation = @(max);
    }
    else if ([key isEqualToString:DJIGimbalParamAdjustYaw]) {
        self.yawRotation = @(max);
    }
    else if ([key isEqualToString:DJIGimbalParamAdjustRoll]) {
        self.rollRotation = @(max);
    }
    
    [self sendRotateGimbalCommand];
    
//    [_maxBtn setEnabled:NO];
//    [_addBtn setEnabled:NO];
//    [_minBtn setEnabled:YES];
//    [_subBtn setEnabled:YES];
}

- (IBAction)startBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(startBtnActionInGimbleVC:)]) {
        [_delegate startBtnActionInGimbleVC:self];
        //reset
        self.pitchRotation = @(0);
        self.yawRotation = @(0);
        self.rollRotation = @(0);
        [self.startBtn setTitle:@"reset" forState:UIControlStateNormal];
        
        [self sendRotateGimbalCommand];
    }
}

- (IBAction)cancelBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(cancelBtnActionInGimbleVC:)]) {
        [_delegate cancelBtnActionInGimbleVC:self];
    }
}

- (IBAction)attitudeChanged:(id)sender {
    DJIGimbal* gimbal = [DemoUtility fetchGimbal];
    if (gimbal == nil) {
        return;
    }
    
    NSString *key = [self getCorrespondingKeyWithButton:_attitude];
    self.minLabal.text = key;
    NSInteger max = [[gimbal getParamMax:key] integerValue];
    [self.maxLabal setText:[NSString stringWithFormat:@"%ld",(long)max]];
    
    if ([key isEqualToString:DJIGimbalParamAdjustPitch]) {
        [self.maxLabal setText:[self.pitchRotation ? @(max) : nil stringValue]];
        [self.startBtn setTitle:@"pitch" forState:UIControlStateNormal];
    }
    else if ([key isEqualToString:DJIGimbalParamAdjustYaw]) {
        [self.maxLabal setText:[self.yawRotation ? @(max) : nil stringValue]];
        [self.startBtn setTitle:@"yaw" forState:UIControlStateNormal];
//        self.yawRotation = self.yawRotation ? @(max) : nil;
    }
    else if ([key isEqualToString:DJIGimbalParamAdjustRoll]) {
        [self.maxLabal setText:[self.rollRotation ? @(max) : nil stringValue]];
        [self.startBtn setTitle:@"roll" forState:UIControlStateNormal];
//        self.rollRotation = self.rollRotation ? @(max) : nil;
    }
}

-(void) sendRotateGimbalCommand {
    DJIGimbal* gimbal = [DemoUtility fetchGimbal];
    if (gimbal == nil) {
        return;
    }
    
    DJIGimbalRotation *rotation = [DJIGimbalRotation gimbalRotationWithPitchValue:self.pitchRotation
                                                                        rollValue:self.rollRotation
                                                                         yawValue:self.yawRotation time:2
                                                                             mode:DJIGimbalRotationModeAbsoluteAngle];
    [gimbal rotateWithRotation:rotation completion:^(NSError * _Nullable error) {
        if (error) {
            ShowResult(@"rotateWithRotation failed: %@", error.description);
        }
    }];
}

-(void) sendRelateRotateGimbalCommand {
    DJIGimbal* gimbal = [DemoUtility fetchGimbal];
    if (gimbal == nil) {
        return;
    }
    
    DJIGimbalRotation *rotation = [DJIGimbalRotation gimbalRotationWithPitchValue:self.pitchRotation
                                                                        rollValue:self.rollRotation
                                                                         yawValue:self.yawRotation time:2
                                                                             mode:DJIGimbalRotationModeRelativeAngle];
    [gimbal rotateWithRotation:rotation completion:^(NSError * _Nullable error) {
        if (error) {
            ShowResult(@"rotateWithRotation failed: %@", error.description);
        }
    }];
}

-(NSString *) getCorrespondingKeyWithButton:(UISegmentedControl *)button {
    if (button.selectedSegmentIndex == 0) {
        return DJIGimbalParamAdjustPitch;
    }
    else if (button.selectedSegmentIndex == 2) {
        return DJIGimbalParamAdjustYaw;
    }
    else if (button.selectedSegmentIndex == 1) {
        return DJIGimbalParamAdjustRoll;
    }
    return nil;
}

@end
