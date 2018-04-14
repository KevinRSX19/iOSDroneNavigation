//
//  LandingViewController.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/6/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LandingViewController;

@protocol LandingViewControllerDelegate<NSObject>

- (void)landingBtnActionInLandingVC:(LandingViewController *)LandingVC;
- (void)cancelBtnActionInLandingVC:(LandingViewController *)LandingVC;

@end

@interface LandingViewController : UIViewController

- (IBAction)landingBtnAction:(id)sender;
- (IBAction)cancelBtnAction:(id)sender;

@property (weak, nonatomic) id <LandingViewControllerDelegate> delegate;

- (void)executeGoHome;
- (void)stopGoHome;
- (void)executeLanding;
- (void)stopMission;

@end
