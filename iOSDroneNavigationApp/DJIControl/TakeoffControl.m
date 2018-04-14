//
//  TakeoffControl.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/6/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import "TakeoffControl.h"
#import "DemoUtility.h"

@implementation TakeoffControl


- (NSString *)getTakeoffHint {
    _takeoffHint = @"Ensure that conditions are safe for takeoff. The aircraft will climb to an altitude of 4 ft. and hover in place.";
    NSLog(@"%@", _takeoffHint);
    return _takeoffHint;
}

- (void)executeTakeoff {
    NSLog(@"takeoff mission executing");
    DJIFlightController* fc = [DemoUtility fetchFlightController];
    if (fc) {
        [fc startTakeoffWithCompletion:^(NSError * _Nullable error) {
            if (error) {
                ShowResult(@"Takeoff Error:%@", error.localizedDescription);
                NSLog(@"Takeoff Error:%@", error.localizedDescription);
            }
            else
            {
                ShowResult(@"Takeoff Succeeded.");
                NSLog(@"Takeoff Succeed.");
            }
        }];
    }
    else
    {
        ShowResult(@"Component Not Exist");
        NSLog(@"Component Not Exist");
    }
}

- (void)stopTakeoff {
    NSLog(@"takeoff mission executing");
    DJIFlightController* fc = [DemoUtility fetchFlightController];
    if (fc) {
        [fc cancelTakeoffWithCompletion:^(NSError * _Nullable error) {
            if (error) {
                ShowResult(@"Takeoff cancel Error:%@", error.localizedDescription);
                NSLog(@"Takeoff cancel Error:%@", error.localizedDescription);
            }
            else
            {
                ShowResult(@"Takeoff cancel Succeeded.");
                NSLog(@"Takeoff cancel Succeed.");
            }
        }];
    }
}

@end
