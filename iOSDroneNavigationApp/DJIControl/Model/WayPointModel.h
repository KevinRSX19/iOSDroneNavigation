//
//  WayPointModel.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 03/03/2018.
//  Copyright © 2018 Kaixuan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WayPointModel : NSObject

@property(nonatomic, assign) CLLocationCoordinate2D wayPoint;
@property(nonatomic, assign) double altitude;

@end
