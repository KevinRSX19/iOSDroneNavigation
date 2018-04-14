//
//  ToLocationConfigViewController.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/6/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import "ToLocationConfigViewController.h"
#import <DJISDK/DJISDK.h>
#import "DemoUtility.h"
#import "WayPointModel.h"

#define ONE_METER_OFFSET (0.00000901315)

@interface ToLocationConfigViewController ()

@property (nonatomic) DJIWaypointMissionOperator *wpOperator;
@property (nonatomic) DJIWaypointMission *downloadMission;

@end

@implementation ToLocationConfigViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.wpOperator = [[DJISDKManager missionControl] waypointMissionOperator];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.wpOperator removeListenerOfExecutionEvents:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _altitude.text = @"15";
    _flySpeed.text = @"3";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stopedit:(id)sender {
    [self.view endEditing:YES];
}

- (void)setFlightConfig:(NSArray *)wayPoints {
    //1. create mission
    DJIMutableWaypointMission * waypointMission = [[DJIMutableWaypointMission alloc] init];
    waypointMission.maxFlightSpeed = 6.0;
    waypointMission.autoFlightSpeed = 4.0;
    waypointMission.headingMode = (DJIWaypointMissionHeadingMode)0;
    [waypointMission setFinishedAction:(DJIWaypointMissionFinishedAction)0];
    
    //2: add waypoints into the mission
    for (int i = 0; i < wayPoints.count; i++) {
        CLLocation* location = [wayPoints objectAtIndex:i];
        if (CLLocationCoordinate2DIsValid(location.coordinate)) {
            DJIWaypoint* waypoint = [[DJIWaypoint alloc] initWithCoordinate:location.coordinate];
            waypoint.altitude = _altitude.text.floatValue;
            [waypointMission addWaypoint:waypoint];
        }
    }
    waypointMission.autoFlightSpeed = _flySpeed.text.floatValue;
    
    //    [self.tolocationMissionControl createWayPointMissionByWaypointMission:waypointMission];
    //3: upload mission
    NSError *error = [self.wpOperator loadMission:waypointMission];
    if (error) {
        ShowResult(@"Prepare Mission Failed:%@", error);
        return;
    }
    __weak typeof(self) weakSelf = self;
    //    WeakRef(target);
    [self.wpOperator addListenerToUploadEvent:self withQueue:nil andBlock:^(DJIWaypointMissionUploadEvent * _Nonnull event) {
        //        WeakReturn(target);
        [weakSelf onUploadEvent:event];
    }];
    
    [self.wpOperator uploadMissionWithCompletion:^(NSError * _Nullable error) {
        //        WeakReturn(target);
        if (error) {
            ShowResult(@"ERROR: uploadMission:withCompletion:. %@", error.description);
        }
        else {
            ShowResult(@"SUCCESS: uploadMission:withCompletion:.");
        }
    }];
}

- (void)setCleaningConfig:(NSArray *)wayPoints {
    //1. create mission
    DJIMutableWaypointMission * waypointMission = [[DJIMutableWaypointMission alloc] init];
    waypointMission.maxFlightSpeed = 5.0;
    waypointMission.autoFlightSpeed = 1.0;
    waypointMission.headingMode = (DJIWaypointMissionHeadingMode)2; //heading controlled by RC
    [waypointMission setFinishedAction:(DJIWaypointMissionFinishedAction)0];
    
    //2: add waypoints into the mission
    for (int i = 0; i < wayPoints.count; i++) {
        WayPointModel* wayPoint = [wayPoints objectAtIndex:i];
        if (CLLocationCoordinate2DIsValid(wayPoint.wayPoint)) {
            DJIWaypoint* waypoint = [[DJIWaypoint alloc] initWithCoordinate:wayPoint.wayPoint];
            waypoint.altitude = wayPoint.altitude;
            [waypointMission addWaypoint:waypoint];
        }
    }
//    waypointMission.autoFlightSpeed = 1.0;
    
    //    [self.tolocationMissionControl createWayPointMissionByWaypointMission:waypointMission];
    //3: upload mission
    NSError *error = [self.wpOperator loadMission:waypointMission];
    if (error) {
        ShowResult(@"Prepare Mission Failed:%@", error);
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.wpOperator addListenerToUploadEvent:self withQueue:nil andBlock:^(DJIWaypointMissionUploadEvent * _Nonnull event) {
        [weakSelf onUploadEvent:event];
    }];
    
    [self.wpOperator uploadMissionWithCompletion:^(NSError * _Nullable error) {
        if (error) {
            ShowResult(@"ERROR: uploadMission:withCompletion:. %@", error.description);
        }
        else {
            ShowResult(@"SUCCESS: uploadMission:withCompletion:.");
        }
    }];
}

- (void)onUploadEvent:(DJIWaypointMissionUploadEvent *) event
{
    
    if (event.currentState == DJIWaypointMissionStateReadyToExecute) {
        ShowResult(@"SUCCESS: the whole waypoint mission is uploaded.");
        //        [self.progrxessBar setHidden:YES];
        [self.wpOperator removeListenerOfUploadEvents:self];
    }
    else if (event.error) {
        ShowResult(@"ERROR: waypoint mission uploading failed. %@", event.error.description);
        //        [self.progressBar setHidden:YES];
        [self.wpOperator removeListenerOfUploadEvents:self];
    }
    else if (event.currentState == DJIWaypointMissionStateReadyToUpload ||
             event.currentState == DJIWaypointMissionStateNotSupported ||
             event.currentState == DJIWaypointMissionStateDisconnected) {
        ShowResult(@"ERROR: waypoint mission uploading failed. %@", event.error.description);
        //        [self.progressBar setHidden:YES];
        [self.wpOperator removeListenerOfUploadEvents:self];
    } else if (event.currentState == DJIWaypointMissionStateUploading) {
        //        [self.progressBar setHidden:NO];
//        DJIWaypointUploadProgress *progress = event.progress;
//        float progressInPercent = progress.uploadedWaypointIndex / progress.totalWaypointCount;
        //        [self.progressBar setProgress:progressInPercent];
    }
}

- (void)onStartButtonClicked {
    
    [self.wpOperator startMissionWithCompletion:^(NSError * _Nullable error) {
        if (error) {
            ShowResult(@"ERROR: startMissionWithCompletion:. %@", error.description);
        }
        else {
            ShowResult(@"SUCCESS: startMissionWithCompletion:. ");
        }
    }];
}

- (IBAction)startBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(startBtnActionInLocaConfigVC:)]) {
        [_delegate startBtnActionInLocaConfigVC:self];
        NSLog(@"executing to location mission!");
        
        [self onStartButtonClicked];
    }
}

- (IBAction)cancelBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(cancelBtnActionInLocaConfigVC:)]) {
        [_delegate cancelBtnActionInLocaConfigVC:self];
        NSLog(@"to location mission canceled!");
    }
}

- (IBAction)uploadBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(uploadBtnActionInLocaConfigVC:)]) {
        [_delegate uploadBtnActionInLocaConfigVC:self];
        NSLog(@"to location mission uploaded!");
        
//        [self.tolocationMissionControl ]
    }
}

- (void)stopMission{
    [self.wpOperator stopMissionWithCompletion:^(NSError * _Nullable error) {
        if (error) {
            ShowResult(@"ERROR: stopMissionExecutionWithCompletion:. %@", error.description);
        }
        else {
            ShowResult(@"SUCCESS: stopMissionExecutionWithCompletion:. ");
        }
    }];
}

-(void) showWaypointMission:(DJIWaypointMission*)wpMission {
    NSMutableString* missionInfo = [NSMutableString stringWithString:@"The waypoint mission is downloaded successfully: \n"];
    [missionInfo appendString:[NSString stringWithFormat:@"RepeatTimes: %zd\n", wpMission.repeatTimes]];
    [missionInfo appendString:[NSString stringWithFormat:@"HeadingMode: %u\n", (unsigned int)wpMission.headingMode]];
    [missionInfo appendString:[NSString stringWithFormat:@"FinishedAction: %u\n", (unsigned int)wpMission.finishedAction]];
    [missionInfo appendString:[NSString stringWithFormat:@"FlightPathMode: %u\n", (unsigned int)wpMission.flightPathMode]];
    [missionInfo appendString:[NSString stringWithFormat:@"MaxFlightSpeed: %f\n", wpMission.maxFlightSpeed]];
    [missionInfo appendString:[NSString stringWithFormat:@"AutoFlightSpeed: %f\n", wpMission.autoFlightSpeed]];
    [missionInfo appendString:[NSString stringWithFormat:@"There are %zd waypoint(s). ", wpMission.waypointCount]];
    //    [self.statusLabel setText:missionInfo];
}

+(NSString *)descriptionForMissionState:(DJIWaypointMissionState)state {
    switch (state) {
        case DJIWaypointMissionStateUnknown:
            return @"Unknown";
        case DJIWaypointMissionStateExecuting:
            return @"Executing";
        case DJIWaypointMissionStateUploading:
            return @"Uploading";
        case DJIWaypointMissionStateRecovering:
            return @"Recovering";
        case DJIWaypointMissionStateDisconnected:
            return @"Disconnected";
        case DJIWaypointMissionStateNotSupported:
            return @"NotSupported";
        case DJIWaypointMissionStateReadyToUpload:
            return @"ReadyToUpload";
        case DJIWaypointMissionStateReadyToExecute:
            return @"ReadyToExecute";
        case DJIWaypointMissionStateExecutionPaused:
            return @"ExecutionPaused";
    }
    
    return @"Unknown";
}

+(NSString *)descriptionForExecuteState:(DJIWaypointMissionExecuteState)state {
    switch (state) {
        case DJIWaypointMissionExecuteStateInitializing:
            return @"Initializing";
            break;
        case DJIWaypointMissionExecuteStateMoving:
            return @"Moving";
        case DJIWaypointMissionExecuteStatePaused:
            return @"Paused";
        case DJIWaypointMissionExecuteStateBeginAction:
            return @"BeginAction";
        case DJIWaypointMissionExecuteStateDoingAction:
            return @"Doing Action";
        case DJIWaypointMissionExecuteStateFinishedAction:
            return @"Finished Action";
        case DJIWaypointMissionExecuteStateCurveModeMoving:
            return @"CurveModeMoving";
        case DJIWaypointMissionExecuteStateCurveModeTurning:
            return @"CurveModeTurning";
        case DJIWaypointMissionExecuteStateReturnToFirstWaypoint:
            return @"Return To first Point";
        default:
            break;
    }
    return @"Unknown";
}

@end
