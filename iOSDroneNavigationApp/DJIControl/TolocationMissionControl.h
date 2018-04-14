//
//  TolocationMissionControl.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/17/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DJISDK/DJISDK.h>

@interface TolocationMissionControl : NSObject <DJIFlightControllerDelegate>

-(DJIMission*) initializeMission;
@property(nonatomic, assign) CLLocationCoordinate2D homeLocation;
@property(nonatomic, assign) CLLocationCoordinate2D aircraftLocation; 

-(void) createWayPointMissionByWaypointMission:(DJIWaypointMission *)mission;
-(void)onStartButtonClicked;
-(void)onStopButtonClicked;
-(void)onDownloadButtonClicked;
-(void)onPauseButtonClicked;
-(void)onResumeButtonClicked;
-(void) missionDidStart:(NSError*)error;
-(void) missionDidStop:(NSError*)error;
-(void) mission:(DJIMission*)mission didDownload:(NSError*)error;
@end
