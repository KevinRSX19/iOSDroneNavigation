//
//  ExploreConfigViewController.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/6/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExploreConfigViewController;

@protocol ExploreConfigViewControllerDelegate<NSObject>

- (void)startBtnActionInExploreVC:(ExploreConfigViewController *)ExploreVC;
- (void)cancelBtnActionInExploreVC:(ExploreConfigViewController *)ExploreVC;

@end

@interface ExploreConfigViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@property (weak, nonatomic) id <ExploreConfigViewControllerDelegate> delegate;

- (IBAction)startBtnAction:(id)sender;
- (IBAction)cancelBtnAction:(id)sender;

- (void)stopMission;

@end
