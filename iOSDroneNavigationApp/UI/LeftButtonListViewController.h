//
//  LeftButtonListViewController.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 11/29/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DJIGSViewMode) {
    DJIGSViewMode_ViewMode,
    DJIGSViewMode_MissionMode,
};

@class LeftButtonListViewController;

@protocol LeftButtonListViewControllerDelegate <NSObject>

- (void) takeoffBtnActionInLBtnVC:(LeftButtonListViewController *)LBtnVC;
- (void) landingBtnActionInLBtnVC:(LeftButtonListViewController *)LBtnVC;
- (void) followMeBtnActionInLBtnVC:(LeftButtonListViewController *)LBtnVC;

@end

@interface LeftButtonListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *takeoffBtn;
@property (weak, nonatomic) IBOutlet UIButton *landingBtn;
@property (weak, nonatomic) IBOutlet UIButton *followmeBtn;

@property (assign, nonatomic) DJIGSViewMode mode;
@property (weak,nonatomic) id <LeftButtonListViewControllerDelegate> delegate;

- (IBAction)takeoffBtnAction:(id)sender;
- (IBAction)landingBtnAction:(id)sender;
- (IBAction)followmeBtnAction:(id)sender;

@end
