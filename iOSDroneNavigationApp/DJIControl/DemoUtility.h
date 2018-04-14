//
//  DemoUtility.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/4/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DJISDK/DJISDK.h>
#import <VideoPreviewer/VideoPreviewer.h>

#define weakSelf(__TARGET__) __weak typeof(self) __TARGET__=self
#define weakReturn(__TARGET__) if(__TARGET__==nil)return;
#define INVALID_POINT CGPointMake(CGFLOAT_MAX, CGFLOAT_MAX)
#define RADIAN(x) ((x)*M_PI/180.0)

extern void ShowResult(NSString *format, ...);
extern void ShowMessage(NSString *title, NSString *message, id target, NSString *cancleBtnTitle);

@interface DemoUtility : NSObject

/**
 *  Fetch DJI Project's component Objects.
 */
+ (DJIAircraft*) fetchAircraft;
+ (DJICamera*) fetchCamera;
+ (DJIGimbal*) fetchGimbal;
+ (DJIFlightController *) fetchFlightController;

/**
 *  Help to do the coordinate transformations.
 */
+ (CGPoint) pointFromStreamSpace:(CGPoint)point;
+ (CGPoint) pointToStreamSpace:(CGPoint)point withView:(UIView *)view;
+ (CGPoint) pointFromStreamSpace:(CGPoint)point withView:(UIView *)view;
+ (CGSize) sizeToStreamSpace:(CGSize)size;
+ (CGSize) sizeFromStreamSpace:(CGSize)size;
+ (CGRect) rectFromStreamSpace:(CGRect)rect;
+ (CGRect) rectToStreamSpace:(CGRect)rect withView:(UIView *)view;
+ (CGRect) rectFromStreamSpace:(CGRect)rect withView:(UIView *)view;
+ (CGRect) rectWithPoint:(CGPoint)point1 andPoint:(CGPoint)point2;

/**
 *  Returns the string object from related enum values.
 */
+ (NSString*) stringFromByPassDirection:(DJIBypassDirection)direction;
+ (NSString *) stringFromActiveTrackState:(DJIActiveTrackMissionState)state;
+ (NSString *) stringFromTargetState:(DJIActiveTrackTargetState)state;
+ (NSString *) stringFromCannotConfirmReason:(DJIActiveTrackCannotConfirmReason)reason;
+ (NSString *) stringFromTapFlyState:(DJITapFlyMissionState)state;

/**
 *  GPS & meter convert
 */
+ (double) LatToMeter:(double)Lat;
+ (double) LonToMeter:(double)Lon :(double)Lat;
+ (double) MeterToLat:(double)Meter;
+ (double) MeterToLon:(double)Meter :(double)Lat;

@end
