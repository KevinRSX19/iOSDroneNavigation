//
//  TakeoffViewController.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/6/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TakeoffViewController;

@protocol TakeoffViewControllerDelegate<NSObject>

- (void)TakeoffBtnActionInTakeoffVC:(TakeoffViewController *)TakeoffVC;
- (void)CancelBtnActionInTakeoffVC:(TakeoffViewController *)TakeoffVC;

@end

@interface TakeoffViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *takeoffBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UITextView *takeoffMessage;
@property (assign, nonatomic) NSString * takeoffHint;

@property (weak, nonatomic) id <TakeoffViewControllerDelegate> delegate;

- (IBAction)takeoffBtnAction:(id)sender;
- (IBAction)cancelBtnAction:(id)sender;
- (NSString *)getTakeoffHint;
- (void)executeTakeoff;
- (void)stopMission;

@end
