//
//  FollowmeMissionController.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/17/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DJISDK/DJISDK.h>
#import "FollowmeConfigModel.h"

@interface FollowmeMissionController : NSObject

@property(nonatomic, strong) CLLocationManager* locationManager;
@property(nonatomic, assign) CLLocationCoordinate2D droneLocation;
@property(nonatomic, assign) CLLocationCoordinate2D userLocation;

- (FollowmeConfigModel *) getDefaultSettings;

- (void) setFollowmeSettings:(FollowmeConfigModel *)setting;

- (void) startFollowmeMission;

- (void) stopFollowmeMission;

- (CLLocationCoordinate2D)updateDroneLocationDemo:(CLLocationCoordinate2D)drone;
- (void)loadDistanceLimit:(double)limit;
+ (CLLocationDistance) calculateDistanceBetweenPoint:(CLLocationCoordinate2D)point1 andPoint:(CLLocationCoordinate2D)point2;

@end
