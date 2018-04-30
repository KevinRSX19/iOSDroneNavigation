//
//  VirtualStickController.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 27/04/2018.
//  Copyright © 2018 Kaixuan Wang. All rights reserved.
//

#import "VirtualStickController.h"
#import "DemoUtility.h"

@implementation VirtualStickController

-(BOOL)isVirtualStickAvaliable {
    DJIFlightController * fc = [DemoUtility fetchFlightController];
    if (fc) {
        if (fc.isVirtualStickControlModeAvailable) {
            ShowResult(@"Virtual Stick Component Avaliable");
            DDLogInfo(@"Virtual Stick Component Avaliable");
            return YES;
        }else{
            ShowResult(@"Virtual Stick Component Not Exist");
            DDLogError(@"Virtual Stick Component Not Exist");
            return NO;
        }
    }else{
        ShowResult(@"Flight Controller Component Not Exist");
        DDLogError(@"Flight Controller Component Not Exist");
        return NO;
    }
}

-(BOOL)getVirtualStickEnabled {
    DJIFlightController * fc = [DemoUtility fetchFlightController];
    if (fc) {
        if (fc.isVirtualStickControlModeAvailable) {
//            ShowResult(@"Virtual Stick Component Avaliable");
            DDLogInfo(@"Virtual Stick Component Avaliable");
            return YES;
        }else{
            ShowResult(@"Virtual Stick Component Not Exist");
            DDLogError(@"Virtual Stick Component Not Exist");
            return NO;
        }
    }else{
        ShowResult(@"Flight Controller Component Not Exist");
        DDLogError(@"Flight Controller Component Not Exist");
        return NO;
    }
}

-(void) startVirtualStickAction {
    DJIFlightController* fc = [DemoUtility fetchFlightController];
    if (fc) {
        fc.yawControlMode = DJIVirtualStickYawControlModeAngularVelocity;
        fc.rollPitchControlMode = DJIVirtualStickRollPitchControlModeVelocity;
        
        [fc setVirtualStickModeEnabled:YES withCompletion:^(NSError * _Nullable error) {
            if (error) {
                ShowResult(@"Enter Virtual Stick Mode Error: %@",error.description);
                DDLogError(@"Enter Virtual Stick Mode Error: %@",error.description);
            }
            else
            {
                DDLogInfo(@"Enter Virtual Stick Mode:Succeeded");
            }
        }];
    }
    else
    {
        ShowResult(@"Component Not Exist (Virtual Stick/Flight Controller)");
        DDLogError(@"Component Not Exist (Virtual Stick/Flight Controller)");
    }
}

-(void) setThrottle:(float)y
{
    self.mThrottle = y * -0.5;  //control descend range, maxRange=0.5m
    self.mYaw = 0;  //heading stay still
    [self updateVirtualStick];
}

-(void) setXVelocity:(float)x {
    self.mXVelocity = x * 1.0;  //moving left or right, maxSpeed=1.0m/s
    self.mYVelocity = 0;  //no moving forward or backward
    [self updateVirtualStick];
}

- (void) setXVelocity:(float)x setThrottle:(float)y {
    self.mXVelocity = x * 1.0;  //moving left or right
    self.mYVelocity = 0;  //no moving forward or backward
    self.mThrottle = y * 1.0;  //control descend range
    self.mYaw = 0;  //heading stay still
    [self updateVirtualStick];
}

-(void) updateVirtualStick
{
    // In rollPitchVelocity mode, the pitch property in DJIVirtualStickFlightControlData represents the Y direction velocity.
    // The roll property represents the X direction velocity.
    DJIVirtualStickFlightControlData ctrlData = {0};
    ctrlData.pitch = self.mYVelocity;
    ctrlData.roll = self.mXVelocity;
    ctrlData.yaw = self.mYaw;
    ctrlData.verticalThrottle = self.mThrottle;
    DJIFlightController* fc = [DemoUtility fetchFlightController];
    if (fc && fc.isVirtualStickControlModeAvailable) {
        [fc sendVirtualStickFlightControlData:ctrlData withCompletion:nil];
    }
}
@end
