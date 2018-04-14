//
//  FollowmeMissionController.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/17/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import "FollowmeMissionController.h"
#import "DemoUtility.h"
#import "MapViewController.h"
#import "FollowmeConfigModel.h"

#define RUNNING_DISTANCE_IN_METER   (3)
#define ONE_METER_OFFSET            (0.00000901315)

@interface FollowmeMissionController() <CLLocationManagerDelegate>
@property (nonatomic, weak) DJIFollowMeMissionOperator *followMeOperator;
@property (nonatomic, strong) NSTimer* updateTimer;
@property (nonatomic) CLLocationCoordinate2D currentTarget;
@property (nonatomic) CLLocationCoordinate2D target1;
@property (nonatomic) CLLocationCoordinate2D target2;
@property (nonatomic) CLLocationCoordinate2D prevTarget;
@property (nonatomic) BOOL isGoingToNorth;

@property (strong, nonatomic) MapViewController* mapVC;

@property (nonatomic) FollowmeConfigModel * followmeModel;

@property double distanceLimit;
//@property (nonatomic) NSString * mode;
//@property (nonatomic) NSString * gps;
//@property (nonatomic) NSString * vSpeed;
//@property (nonatomic) NSString * hSpeed;
//@property (nonatomic) NSString * altitude;

@end

@implementation FollowmeMissionController

- (void) initData{
    _followmeModel = [[FollowmeConfigModel alloc] init];
    _followmeModel.updateTimeInterval = @"0.5";
    _followmeModel.maxFlyHeight = @"10";
    _followmeModel.maxFlySpeed = @"3";
    self.followMeOperator = [[DJISDKManager missionControl] followMeMissionOperator];
    self.distanceLimit = 15.0;
    
    self.userLocation = kCLLocationCoordinate2DInvalid;
    self.droneLocation = kCLLocationCoordinate2DInvalid;
    //    self.distance = 0;
    //    self.mapController = [[DJIMapController alloc] init];
    //    self.mapView.showsUserLocation = YES;
    [self startUpdateLocation];
}

- (void)loadDistanceLimit:(double)limit {
    self.distanceLimit = limit;
}

-(void) startUpdateLocation
{
    if ([CLLocationManager locationServicesEnabled]) {
        if (self.locationManager == nil) {
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            self.locationManager.distanceFilter = 0.1;
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }
            [self.locationManager startMonitoringSignificantLocationChanges];
            [self.locationManager startUpdatingLocation];
        }
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"%@", locations);
    CLLocation* location = [locations lastObject];
    self.userLocation = location.coordinate;
}

- (FollowmeConfigModel *) getDefaultSettings {
    [self initData];
    
    return self.followmeModel;
}

- (void) setFollowmeSettings:(FollowmeConfigModel *)setting {
    if (setting.updateTimeInterval != nil) {
        _followmeModel.updateTimeInterval = setting.updateTimeInterval;
    }
    if (setting.maxFlyHeight != nil) {
        _followmeModel.maxFlyHeight = setting.maxFlyHeight;
    }
    if (setting.maxFlySpeed != nil) {
        _followmeModel.maxFlySpeed = setting.maxFlySpeed;
    }
}

- (void) startFollowmeMission {
    DJIFollowMeMission* mission = (DJIFollowMeMission*)[self initializeMission];
    [self.followMeOperator startMission:mission withCompletion:^(NSError * _Nullable error) {
        if (error) {
            ShowResult(@"Start Mission Failed:%@", error.localizedDescription);
            NSLog(@"follow me error: %@",error);
        } else {
            [self missionDidStart:error];
            NSLog(@"follow me succeed: %@",error);
        }
    }];
    
    [self.followMeOperator addListenerToEvents:self withQueue:nil andBlock:^(DJIFollowMeMissionEvent * _Nonnull event) {
        [self onReciviedFollowMeEvent:event];
    }];
}

-(void)onReciviedFollowMeEvent:(DJIFollowMeMissionEvent*)event
{
    NSMutableString *statusStr = [NSMutableString new];
    [statusStr appendFormat:@"previousState:%@\n", [[self class] descriptionForState:event.previousState]];
    [statusStr appendFormat:@"currentState:%@\n", [[self class] descriptionForState:event.currentState]];
    [statusStr appendFormat:@"distanceToFollowMeCoordinate:%f\n", event.distanceToFollowMeCoordinate];
    
    if (event.error) {
        [statusStr appendFormat:@"Mission Executing Error:%@", event.error.description];
    }
    //    [self.status setText:statusStr];
}

+(NSString *)descriptionForState:(DJIFollowMeMissionState)state {
    switch (state) {
        case DJIFollowMeMissionStateUnknown:
            return @"Unknown";
        case DJIFollowMeMissionStateExecuting:
            return @"Executing";
        case DJIFollowMeMissionStateRecovering:
            return @"Recovering";
        case DJIFollowMeMissionStateDisconnected:
            return @"Disconnected";
        case DJIFollowMeMissionStateNotSupported:
            return @"NotSupported";
        case DJIFollowMeMissionStateReadyToStart:
            return @"ReadyToStart";
    }
}

-(void)missionDidStart:(NSError *)error {
    // Only starts the updating if the mission is started successfully.
    if (error) return;
    //demo start
//    self.prevTarget = self.droneLocation;
//    self.target1 = self.droneLocation;
//    self.target2 = CLLocationCoordinate2DMake(self.target1.latitude + RUNNING_DISTANCE_IN_METER * ONE_METER_OFFSET, self.target1.longitude);
//    self.currentTarget = self.target2;
    //demo finished
    [self startUpdateTimer];
}

-(void) startUpdateTimer {
    if (self.updateTimer == nil) {
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:[_followmeModel.updateTimeInterval doubleValue] target:self selector:@selector(onUpdateTimerTicked:) userInfo:nil repeats:YES];
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
    //calculate max_distance = maxSpeed * updateTimeInterval
    CLLocationDistance distance = [FollowmeMissionController calculateDistanceBetweenPoint:self.userLocation andPoint:self.droneLocation];
    double maxDistance = [self.followmeModel.maxFlySpeed doubleValue] * [self.followmeModel.updateTimeInterval doubleValue];
    if (distance <= maxDistance) {
        [self.followMeOperator updateFollowMeCoordinate:self.userLocation];
    } else {
        double lat =(self.userLocation.latitude-self.droneLocation.latitude);
        double lon =(self.userLocation.longitude-self.droneLocation.longitude);
        double k =  lat/lon;
        double tarlat = self.droneLocation.latitude + lat/distance;
        double tarlon = tarlat/k;
//        double ang = atan(k);
        //if user is going to the west of the drone
//        if(self.userLocation.longitude<self.droneLocation.longitude)
//            maxDistance = -maxDistance;
//        double x = cos(ang) * maxDistance;
//        double y = sin(ang) * maxDistance;
        CLLocationCoordinate2D followPoint = CLLocationCoordinate2DMake(tarlat,tarlon);
        [self.followMeOperator updateFollowMeCoordinate:followPoint];
    }
//    if (err) {
////        [self stopFollowmeMission];
//        ShowResult(@"Followme update error:%@",err);
//    }
//    CLLocationDistance distance = [FollowmeMissionController calculateDistanceBetweenPoint:self.userLocation andPoint:self.droneLocation];
//    if (distance > self.distanceLimit) {
//        [self stopFollowmeMission];
//    }
    //demo start
//    float offset = 0.0;
//    if (self.currentTarget.latitude == self.target1.latitude) {
//        offset = -0.1 * ONE_METER_OFFSET;
//    }
//    else {
//        offset = 0.1 * ONE_METER_OFFSET;
//    }
//
//    CLLocationCoordinate2D target = CLLocationCoordinate2DMake(self.prevTarget.latitude + offset, self.prevTarget.longitude);
//    [self.followMeOperator updateFollowMeCoordinate:target];
//
//    self.prevTarget = target;
//
//    [self changeDirectionIfFarEnough];
    //demo finished
    
}

//demo method
//-(void) changeDirectionIfFarEnough {
//    CLLocationDistance distance = [FollowmeMissionController calculateDistanceBetweenPoint:self.prevTarget andPoint:self.currentTarget];
//
//    // close enough. Change the direction.
//    if (distance < 0.2) {
//        if (self.currentTarget.latitude == self.target1.latitude) {
//            self.currentTarget = self.target2;
//        }
//        else {
//            self.currentTarget = self.target1;
//        }
//    }
//}

+ (CLLocationDistance) calculateDistanceBetweenPoint:(CLLocationCoordinate2D)point1 andPoint:(CLLocationCoordinate2D)point2 {
    CLLocation* location1 = [[CLLocation alloc] initWithLatitude:point1.latitude longitude:point1.longitude];
    CLLocation* location2 = [[CLLocation alloc] initWithLatitude:point2.latitude longitude:point2.longitude];

    return [location1 distanceFromLocation:location2];
}

- (CLLocationCoordinate2D)updateDroneLocationDemo:(CLLocationCoordinate2D)drone {
    self.droneLocation = drone;
    return self.droneLocation;
}
//demo method finished

- (void) stopFollowmeMission {
    [self.followMeOperator stopMissionWithCompletion:^(NSError * _Nullable error) {
        if (error) {
            ShowResult(@"Stop Mission Failed:%@", error.localizedDescription);
        } else {
            [self stopUpdateTimer];
            [self.followMeOperator removeListener:self];
        }
    }];
}

#pragma Follow me
-(DJIMission*) initializeMission {
    DJIFollowMeMission* mission = [[DJIFollowMeMission alloc] init];
    mission.followMeCoordinate = self.droneLocation;
    mission.heading = DJIFollowMeHeadingTowardFollowPosition;
    mission.followMeAltitude = [_followmeModel.maxFlyHeight floatValue];
    
    return mission;
}

@end
