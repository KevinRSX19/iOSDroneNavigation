//
//  TimelineMissionController.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/20/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import "TimelineMissionController.h"
#import "DemoUtility.h"
#import <DJISDK/DJISDK.h>

#define ONE_METER_OFFSET (0.00000901315)
#define V_HEIGHT (0.00000901315)
#define H_DISTANCE (0.00000901315)

@interface TimelineMissionController ()<DJIFlightControllerDelegate>

@property(nonatomic, strong) NSMutableArray* actions;
@property double heading;
@property double altitude;
@property(nonatomic) DJIAttitude attitude;

@property(nonatomic, assign) CLLocationCoordinate2D aircraftLocation;
@property(nonatomic, assign) CLLocationCoordinate2D homeLocation;

@property(nonatomic, assign) DJIFlightOrientationMode orientationMode;

@end

@implementation TimelineMissionController

-(void)initMission {
    if (self.actions == nil) {
        self.actions = [[NSMutableArray alloc] init];
    }
    
    if ([DemoUtility fetchAircraft] != nil) { // the product is an aircraft
        if ([DemoUtility fetchFlightController]) {
            [[DemoUtility fetchFlightController] setDelegate:self];
        }
    }
    
    self.orientationMode = DJIFlightOrientationModeAircraftHeading;
    if (self.orientationMode != DJIFlightOrientationModeCourseLock) {
        DJIFlightController* fc = [DemoUtility fetchFlightController];
        if (fc) {
            [fc setFlightOrientationMode:DJIFlightOrientationModeCourseLock withCompletion:^(NSError * _Nullable error) {
                if (error) {
                    ShowResult(@"Course Lock:%@", error.localizedDescription);
                }
            }];
        }
        else
        {
            ShowResult(@"Component Not Exist.");
        }
    }
}

#pragma mark - DJIFlightControllerDelegate
/**
 *  Some missions need the aircraft's current location and the home point location.
 */
-(void)flightController:(DJIFlightController *)fc didUpdateState:(DJIFlightControllerState *)state {
    self.aircraftLocation = state.aircraftLocation.coordinate;
    self.homeLocation = state.homeLocation.coordinate;
    self.heading = fc.compass.heading;
    self.altitude = state.altitude;
    self.attitude = state.attitude;
}

-(void)initExploreMission {
    if (self.actions == nil) {
        self.actions = [[NSMutableArray alloc] init];
    }
    //TODO: test pitch, roll, yaw, reset yaw
    double yaw = 0.00;
    DJIGimbalAttitude atti = {_attitude.pitch, _attitude.roll, yaw};
    DJIGimbalAttitudeAction* gimbalAttiAction = [[DJIGimbalAttitudeAction alloc] initWithAttitude:atti];
    [self.actions addObject:gimbalAttiAction];
    
    for (int i = 0; i < 5; i++) {
        //shoot photo
    DJIShootPhotoAction* shootPhotoAction = [[DJIShootPhotoAction alloc] initWithPhotoCount:2 timeInterval:3.0];
    [self.actions addObject:shootPhotoAction];
        
        //move gimbal
    DJIGimbalAttitude atti = {_attitude.pitch, _attitude.roll, yaw};
    DJIGimbalAttitudeAction* gimbalAttiAction = [[DJIGimbalAttitudeAction alloc] initWithAttitude:atti];
    [self.actions addObject:gimbalAttiAction];
    yaw += 10;
    }
    //shoot photo
    DJIShootPhotoAction* shootPhotoAction = [[DJIShootPhotoAction alloc] initWithPhotoCount:2 timeInterval:3.0];
    [self.actions addObject:shootPhotoAction];
    
}

-(void)initCleaningToCornerMission {
    //TODO: fly to the left top corner or the triangle of graffiti
}

//-(void) initializeVCleaningMission:(CLLocationCoordinate2D) targetLocation altitude:(double)altitude height:(int)ht length:(int)lt {
//    if (self.actions == nil) {
//        ShowResult(@"Action element is nil, reallocing");
//        self.actions = [[NSMutableArray alloc] init];
//    }
//    double alt = altitude;
//    if (alt < ht+1) {
////        alt = ht + 1;
//        return;
//    }
//    
//    //calculate GPS consider heading
//    double ang,latLt,lonLt;
//    if (_heading>90) {
//        //facing ES
//        ang = _heading - 90;
//        latLt = -sin(ang)*lt;
//        lonLt = cos(ang)*lt;
//    }else if(_heading>0){
//        //facing NE
//        ang = _heading;
//        latLt = sin(ang)*lt;
//        lonLt = cos(ang)*lt;
//    }else if(_heading>-90){
//        //facing NW
//        ang = -_heading;
//        latLt = sin(ang)*lt;
//        lonLt = -cos(ang)*lt;
//    }else{
//        //facing SW
//        ang = 90 - _heading;
//        latLt = -sin(ang)*lt;
//        lonLt = -cos(ang)*lt;
//    }
//    double temp = alt;
//    
//    NSLog(@"alt:%f,latLt:%f,lonLt:%f",alt,latLt,lonLt);
//    while (temp > 1 && alt - temp < ht) {
//        //right
//        DJIGoToAction* gotoAction1 = [[DJIGoToAction alloc] initWithCoordinate:CLLocationCoordinate2DMake(targetLocation.latitude + latLt * ONE_METER_OFFSET, targetLocation.longitude + lonLt * ONE_METER_OFFSET) altitude:temp];
//        [self.actions addObject:gotoAction1];
//        NSLog(@"%f,%f,%f",temp,targetLocation.latitude + latLt * ONE_METER_OFFSET, targetLocation.longitude + lonLt * ONE_METER_OFFSET);
//        ShowResult(@"%f,%f,%f",temp,targetLocation.latitude + latLt * ONE_METER_OFFSET, targetLocation.longitude + lonLt * ONE_METER_OFFSET);
//        //down
//        DJIGoToAction* gotoAction2 = [[DJIGoToAction alloc] initWithCoordinate:CLLocationCoordinate2DMake(targetLocation.latitude + latLt * ONE_METER_OFFSET, targetLocation.longitude + lonLt * ONE_METER_OFFSET) altitude:--temp];
//        [self.actions addObject:gotoAction2];
//        NSLog(@"%f,%f,%f",temp,targetLocation.latitude + latLt * ONE_METER_OFFSET, targetLocation.longitude + lonLt * ONE_METER_OFFSET);
//        ShowResult(@"%f,%f,%f",temp,targetLocation.latitude + latLt * ONE_METER_OFFSET, targetLocation.longitude + lonLt * ONE_METER_OFFSET);
//        //left
//        DJIGoToAction* gotoAction3 = [[DJIGoToAction alloc] initWithCoordinate:CLLocationCoordinate2DMake(targetLocation.latitude, targetLocation.longitude) altitude:temp];
//        [self.actions addObject:gotoAction3];
//        NSLog(@"%f,%f,%f",temp,targetLocation.latitude, targetLocation.longitude);
//        ShowResult(@"%f,%f,%f",temp,targetLocation.latitude + latLt * ONE_METER_OFFSET, targetLocation.longitude + lonLt * ONE_METER_OFFSET);
//        //down
//        DJIGoToAction* gotoAction4 = [[DJIGoToAction alloc] initWithCoordinate:CLLocationCoordinate2DMake(targetLocation.latitude, targetLocation.longitude) altitude:--temp];
//        [self.actions addObject:gotoAction4];
//        NSLog(@"%f,%f,%f",temp,targetLocation.latitude, targetLocation.longitude);
//        ShowResult(@"%f,%f,%f",temp,targetLocation.latitude + latLt * ONE_METER_OFFSET, targetLocation.longitude + lonLt * ONE_METER_OFFSET);
//    }
////    return action;
//}
//
//-(void) initializeHCleaningMission:(CLLocationCoordinate2D) targetLocation altitude:(double)altitude height:(int)ht length:(int)lt {
//    if (self.actions == nil) {
//        self.actions = [[NSMutableArray alloc] init];
//    }
//    double alt = altitude;
////    double alt = 14;
////    if (14 < ht+1) {
//    if (alt < ht+1) {
////        alt = ht + 1;
//        return;
//    }
//    
//    //calculate GPS consider heading
//    double ang,latLt,lonLt;
//    if (_heading>90) {
//        //facing ES
//        ang = _heading - 90;
//        latLt = -sin(ang);
//        lonLt = cos(ang);
//    }else if(_heading>0){
//        //facing NE
//        ang = _heading;
//        latLt = sin(ang);
//        lonLt = cos(ang);
//    }else if(_heading>-90){
//        //facing NW
//        ang = -_heading;
//        latLt = sin(ang);
//        lonLt = -cos(ang);
//    }else{
//        //facing SW
//        ang = 90 - _heading;
//        latLt = -sin(ang);
//        lonLt = -cos(ang);
//    }
//    NSLog(@"alt:%f,latLt:%f,lonLt:%f",alt,latLt,lonLt);
//    double temp = alt;
//    for (int lonth = 0; lonth<=lt;) {
//        DJIGoToAction* gotoAction1 = [[DJIGoToAction alloc] initWithCoordinate:CLLocationCoordinate2DMake(targetLocation.latitude + lonth * ONE_METER_OFFSET * latLt, targetLocation.longitude + lonth * ONE_METER_OFFSET * lonLt) altitude:temp-ht];
//        [self.actions addObject:gotoAction1];
//        NSLog(@"%d,%f,%f,%f",lonth,targetLocation.latitude + lonth * ONE_METER_OFFSET * latLt, targetLocation.longitude + lonth * ONE_METER_OFFSET * lonLt,temp-ht);
//        lonth++;
//        DJIGoToAction* gotoAction2 = [[DJIGoToAction alloc] initWithCoordinate:CLLocationCoordinate2DMake(targetLocation.latitude + lonth * ONE_METER_OFFSET * latLt, targetLocation.longitude + lonth * ONE_METER_OFFSET * lonLt) altitude:temp-ht];
//        [self.actions addObject:gotoAction2];
//        NSLog(@"%d,%f,%f,%f",lonth,targetLocation.latitude + lonth * ONE_METER_OFFSET * latLt, targetLocation.longitude + lonth * ONE_METER_OFFSET * lonLt,temp-ht);
//        DJIGoToAction* gotoAction3 = [[DJIGoToAction alloc] initWithCoordinate:CLLocationCoordinate2DMake(targetLocation.latitude + lonth * ONE_METER_OFFSET * latLt, targetLocation.longitude + lonth * ONE_METER_OFFSET * lonLt) altitude:temp-1];
//        [self.actions addObject:gotoAction3];
//        NSLog(@"%d,%f,%f,%f",lonth,targetLocation.latitude + lonth * ONE_METER_OFFSET * latLt, targetLocation.longitude + lonth * ONE_METER_OFFSET * lonLt,temp-1);
//        lonth++;
//        DJIGoToAction* gotoAction4 = [[DJIGoToAction alloc] initWithCoordinate:CLLocationCoordinate2DMake(targetLocation.latitude + lonth * ONE_METER_OFFSET * latLt, targetLocation.longitude + lonth * ONE_METER_OFFSET * lonLt) altitude:temp-1];
//        [self.actions addObject:gotoAction4];
//        NSLog(@"%d,%f,%f,%f",lonth,targetLocation.latitude + lonth * ONE_METER_OFFSET * latLt, targetLocation.longitude + lonth * ONE_METER_OFFSET * lonLt,temp-1);
//    }
//}

-(void)startMission {
    //schedule
    NSError *error = [[DJISDKManager missionControl] scheduleElements:self.actions];
    if (error) {
        ShowResult(@"Schedule Timeline Actions Failed:%@", error.description);
    } else {
        ShowResult(@"Actions schedule succeed!");
    }
    //start
    [[DJISDKManager missionControl] addListener:self
                    toTimelineProgressWithBlock:^(DJIMissionControlTimelineEvent event, id<DJIMissionControlTimelineElement>  _Nullable element, NSError * _Nullable error, id  _Nullable info)
     {
         NSMutableString *statusStr = [NSMutableString new];
         [statusStr appendFormat:@"Current Event:%@\n", [[self class] timelineEventString:event]];
         [statusStr appendFormat:@"Element:%@\n", [element description]];
         [statusStr appendFormat:@"Info:%@\n", info];
         if (error) {
             [statusStr appendFormat:@"Error:%@\n", error.description];
         }
         //         self.statusLabel.text = statusStr;
         NSLog(@"%@", statusStr);
         if (error) {
             [[DJISDKManager missionControl] stopTimeline];
             [[DJISDKManager missionControl] unscheduleEverything];
             ShowResult(@"Timeline Actions Failed:%@", error.description);
         }
     }];
    
    [[DJISDKManager missionControl] startTimeline];
}

-(void)stopMission {
    [[DJISDKManager missionControl] stopTimeline];
    [[DJISDKManager missionControl] unscheduleEverything];
    [[DJISDKManager missionControl] removeListener:self];
    
    DJIFlightController* fc = [DemoUtility fetchFlightController];
    if (fc) {
        [fc setFlightOrientationMode:self.orientationMode withCompletion:^(NSError * _Nullable error) {
            if (error) {
                ShowResult(@"Course Lock:%@", error.localizedDescription);
            }
        }];
    }
    else
    {
        ShowResult(@"Component Not Exist.");
    }
}

-(void)finishMission {
    [[DJISDKManager missionControl] stopTimeline];
    [[DJISDKManager missionControl] unscheduleEverything];
    [[DJISDKManager missionControl] removeListener:self];
    
    DJIFlightController* fc = [DemoUtility fetchFlightController];
    if (fc) {
        [fc setFlightOrientationMode:self.orientationMode withCompletion:^(NSError * _Nullable error) {
            if (error) {
                ShowResult(@"Course Lock:%@", error.localizedDescription);
            }
        }];
    }
    else
    {
        ShowResult(@"Component Not Exist.");
    }
}

+ (NSString*)timelineEventString:(DJIMissionControlTimelineEvent)event
{
    NSString *eventString = @"N/A";
    
    switch (event) {
        case DJIMissionControlTimelineEventPaused:
            eventString = @"Paused";
            break;
        case DJIMissionControlTimelineEventResumed:
            eventString = @"Resumed";
            break;
        case DJIMissionControlTimelineEventStarted:
            eventString = @"Started";
            break;
        case DJIMissionControlTimelineEventStopped:
            eventString = @"Stopped";
            break;
        case DJIMissionControlTimelineEventFinished:
            eventString = @"Finished";
            break;
        case DJIMissionControlTimelineEventStopError:
            eventString = @"Stop Error";
            break;
        case DJIMissionControlTimelineEventPauseError:
            eventString = @"Pause Error";
            break;
        case DJIMissionControlTimelineEventProgressed:
            eventString = @"Progressed";
            break;
        case DJIMissionControlTimelineEventStartError:
            eventString = @"Start Error";
            break;
        case DJIMissionControlTimelineEventResumeError:
            eventString = @"Resume Error";
            break;
        case DJIMissionControlTimelineEventUnknown:
            eventString = @"Unknown";
            break;
        default:
            break;
    }
    return eventString;
}

@end
