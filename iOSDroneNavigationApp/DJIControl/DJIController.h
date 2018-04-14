//
//  DJIController.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/17/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DJISDK/DJISDK.h>
#import "FollowmeMissionController.h"

@interface DJIController : NSObject

@property (nonatomic) FollowmeMissionController* followmeMission;

- (void) onTakeoffButtonClicked;
- (void) onGoHomeButtonClicked;
- (void) onLandButtonClicked;
- (void) cancelLanding;
- (void) cancelGoHome;

- (void) followMeConfig;
//- (void) followMeExecute;
//
//- (void) toLocationConfig;
//- (void) toLocationExecute;
//- (void) toTargetExecute;
//
//- (void) exploreConfig;
//- (void) exploreExecute;
//
//- (void) cleaningConfig;
//- (void) cleaningExecute;

@end
