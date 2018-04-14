//
//  TakeoffControl.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/6/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TakeoffControl : NSObject

@property (assign, nonatomic) NSString * takeoffHint;

- (NSString *)getTakeoffHint;
- (void)executeTakeoff;
- (void)stopTakeoff;

@end
