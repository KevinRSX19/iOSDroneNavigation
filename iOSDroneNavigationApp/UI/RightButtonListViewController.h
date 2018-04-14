//
//  RightButtonListViewController.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 11/29/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RightBtnViewMode) {
    RightBtnViewMode_ViewMode,
    RightBtnViewMode_MissionMode,
};

@class RightButtonListViewController;

@protocol RightButtonListViewControllerDelegate <NSObject>

- (void) gimbleBtnActionInRBtnVC:(RightButtonListViewController *)RBtnVC;
- (void) exploreBtnActionInRBtnVC:(RightButtonListViewController *)RBtnVC;
- (void) stopBtnActionInRBtnVC:(RightButtonListViewController *)RBtnVC;
- (void) tolocationBtnActionInRBtnVC:(RightButtonListViewController *)RBtnVC;
- (void) cleaningBtnActionInRBtnVC:(RightButtonListViewController *)RBtnVC;

@end

@interface RightButtonListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *gimbleBtn;
@property (weak, nonatomic) IBOutlet UIButton *exploreBtn;
@property (weak, nonatomic) IBOutlet UIButton *tolocationBtn;
@property (weak, nonatomic) IBOutlet UIButton *cleaningBtn;

@property (assign, nonatomic) RightBtnViewMode mode;
@property (weak, nonatomic) id <RightButtonListViewControllerDelegate> delegate;

- (IBAction)exploreBtnAction:(id)sender;
- (IBAction)gimbleBtnAction:(id)sender;
- (IBAction)tolocationBtnAction:(id)sender;
- (IBAction)stopBtnAction:(id)sender;
- (IBAction)cleaningBtnAction:(id)sender;


@end
