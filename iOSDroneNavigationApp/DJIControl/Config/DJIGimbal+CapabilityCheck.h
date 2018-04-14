//
//  DJIGimbal+CapabilityCheck.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/21/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <DJISDK/DJISDK.h>

@interface DJIGimbal (CapabilityCheck)

-(BOOL) isFeatureSupported:(NSString *)key;
-(NSNumber *) getParamMin:(NSString *)key;
-(NSNumber *) getParamMax:(NSString *)key;

@end
