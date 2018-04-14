//
//  DJIController.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/17/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import "DJIController.h"
#import "DemoUtility.h"

@implementation DJIController

- (void) onTakeoffButtonClicked {
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

- (void)onGoHomeButtonClicked {
    DJIFlightController* fc = [DemoUtility fetchFlightController];
    if (fc) {
        [fc startGoHomeWithCompletion:^(NSError * _Nullable error) {
            if (error) {
                ShowResult(@"GoHome Error:%@", error.localizedDescription);
                NSLog(@"GoHome Error:%@", error.localizedDescription);
            }
            else
            {
                ShowResult(@"GoHome Succeeded.");
                NSLog(@"GoHome Succeeded");
            }
        }];
    }
    else
    {
        ShowResult(@"Component Not Exist");
        NSLog(@"Component Not Exist");
    }
}

- (void)onLandButtonClicked {
    NSLog(@"executing landing");
    DJIFlightController* fc = [DemoUtility fetchFlightController];
    if (fc) {
        [fc startLandingWithCompletion:^(NSError * _Nullable error) {
            if (error) {
                ShowResult(@"Land Error:%@", error.localizedDescription);
                NSLog(@"Land Error:%@", error.localizedDescription);
            }
            else
            {
                ShowResult(@"Land Succeeded.");
                NSLog(@"Land Succeeded.");
            }
        }];
    }
    else
    {
        ShowResult(@"Component Not Exist");
        NSLog(@"Component Not Exist");
    }
}

- (void)cancelLanding {
    NSLog(@"cancel landing");
    DJIFlightController* fc = [DemoUtility fetchFlightController];
    if (fc) {
        [fc cancelLandingWithCompletion:^(NSError * _Nullable error) {
            if (error) {
                ShowResult(@"Land Error:%@", error.localizedDescription);
                NSLog(@"Land Error:%@", error.localizedDescription);
            }
            else
            {
                ShowResult(@"Cancel Land Succeeded.");
                NSLog(@"Cancel Land Succeeded.");
            }
        }];
    }
}

- (void)cancelGoHome {
    NSLog(@"cancel go home");
    DJIFlightController* fc = [DemoUtility fetchFlightController];
    if (fc) {
        [fc cancelGoHomeWithCompletion:^(NSError * _Nullable error) {
            if (error) {
                ShowResult(@"Go Home Error:%@", error.localizedDescription);
                NSLog(@"Go Home Error:%@", error.localizedDescription);
            }
            else
            {
                ShowResult(@"Cancel Go Home Succeeded.");
                NSLog(@"Cancel Go Home Succeeded.");
            }
        }];
    }
}

- (void)followMeConfig {
    
}

@end
