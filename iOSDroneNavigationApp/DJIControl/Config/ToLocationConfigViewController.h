//
//  ToLocationConfigViewController.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/6/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToLocationConfigViewController;

@protocol ToLocationConfigViewControllerDelegate<NSObject>

- (void)startBtnActionInLocaConfigVC:(ToLocationConfigViewController*)LocaConfigVC;
- (void)cancelBtnActionInLocaConfigVC:(ToLocationConfigViewController*)LocaConfigVC;
- (void)uploadBtnActionInLocaConfigVC:(ToLocationConfigViewController*)LocaConfigVC;

@end

@interface ToLocationConfigViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *altitude;
@property (weak, nonatomic) IBOutlet UITextField *flySpeed;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) id <ToLocationConfigViewControllerDelegate> delegate;

- (IBAction)startBtnAction:(id)sender;
- (IBAction)cancelBtnAction:(id)sender;
- (IBAction)uploadBtnAction:(id)sender;

- (void)onStartButtonClicked;
- (void)stopMission;

- (void)setFlightConfig:(NSArray *)wayPoints;
- (void)setCleaningConfig:(NSArray *)wayPoints;

@end
