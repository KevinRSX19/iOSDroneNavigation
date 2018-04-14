//
//  TimelineMissionController.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/20/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DemoUtility.h"

@interface TimelineMissionController : NSObject

-(void)initMission;
-(void)finishMission;
-(void)stopMission;
-(void)startMission;

-(void)initExploreMission;
-(void)initCleaningToCornerMission;
//-(void)initializeVCleaningMission:(CLLocationCoordinate2D) targetLocation altitude:(double)altitude height:(int)ht length:(int)lt;
//-(void)initializeHCleaningMission:(CLLocationCoordinate2D) targetLocation altitude:(double)altitude height:(int)ht length:(int)lt ;

@end
