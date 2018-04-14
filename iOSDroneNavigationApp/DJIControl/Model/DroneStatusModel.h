//
//  DroneStatusModel.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 04/03/2018.
//  Copyright © 2018 Kaixuan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DroneStatusModel : NSObject

@property (nonatomic, assign) NSString *flightMode;
@property (nonatomic, assign) NSString *compass;
@property (nonatomic, assign) NSString *IMU;
@property (nonatomic, assign) NSString *ESC;
@property (nonatomic, assign) NSString *RCBattery;
@property (nonatomic, assign) NSString *aircraftBattery;
@property (nonatomic, assign) NSString *aircraftBatteryTemp;
@property (nonatomic, assign) NSString *gimbalStatus;
@property (nonatomic, assign) NSString *SDCardCapa;


@end
