//
//  VirtualStickController.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 27/04/2018.
//  Copyright © 2018 Kaixuan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VirtualStickController : NSObject

@property (assign, nonatomic) float mXVelocity;
@property (assign, nonatomic) float mYVelocity;
@property (assign, nonatomic) float mYaw;
@property (assign, nonatomic) float mThrottle;

-(void) startVirtualStickAction;  //init Virtual Stack Action
-(void) setThrottle:(float)y;  //set descend range
-(void) setXVelocity:(float)x; //set move speed
-(void) setXVelocity:(float)x setThrottle:(float)y;

-(BOOL)getVirtualStickEnabled;
-(BOOL)isVirtualStickAvaliable;

@end
