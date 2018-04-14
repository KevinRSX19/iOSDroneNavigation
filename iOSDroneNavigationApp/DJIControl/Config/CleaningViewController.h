//
//  CleaningViewController.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/20/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelineMissionController.h"

@class CleaningViewController;

@protocol CleaningViewControllerDelegate<NSObject>

- (void)uploadBtnActionInCleaningVC:(CleaningViewController *)CleaningVC;
- (void)startBtnActionInCleaningVC:(CleaningViewController *)CleaningVC;
- (void)cancelBtnActionInCleaningVC:(CleaningViewController *)CleaningVC;

@end

@interface CleaningViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *g_length;
@property (weak, nonatomic) IBOutlet UITextField *g_height;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mode;
@property (weak, nonatomic) IBOutlet UILabel *flightSpeed;
@property (weak, nonatomic) IBOutlet UITextField *flightInterval;

@property(nonatomic) TimelineMissionController * timeline;

@property (weak, nonatomic) id <CleaningViewControllerDelegate> delegate;

- (IBAction)uploadBtnAction:(id)sender;
- (IBAction)startBtnAction:(id)sender;
- (IBAction)cancelBtnAction:(id)sender;
//- (void)initalizeCleaningMission:(CLLocationCoordinate2D)target altitude:(double)altitude;
- (void)stopMission;

@end
