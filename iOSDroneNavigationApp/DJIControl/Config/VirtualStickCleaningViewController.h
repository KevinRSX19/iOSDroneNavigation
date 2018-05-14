//
//  VirtualStickCleaningViewController.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 2018/4/29.
//  Copyright © 2018 Kaixuan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VirtualStickController.h"

typedef NS_ENUM(NSUInteger, CleaningMode) {
    CleaningMode_VerMode,
    CleaningMode_HoriMode,
};

typedef NS_ENUM(NSUInteger, CleaningProcess) {
    CleaningProcess_Lineward,
    CleaningProcess_LineChange,
};

@class VirtualStickCleaningViewController;

@protocol VirtualStickCleaningViewControllerDelegate<NSObject>

- (void) stopCleaningActionInVSCleaningVC:(VirtualStickCleaningViewController*)VSCleaningVC;

@end

@interface VirtualStickCleaningViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *rollSpeedValue;
@property (weak, nonatomic) IBOutlet UILabel *descendRangeValue;
@property (weak, nonatomic) IBOutlet UISlider *rollSpeedControl;
@property (weak, nonatomic) IBOutlet UISlider *descendRangeControl;
@property (assign, nonatomic) CleaningMode mode;
@property (assign, nonatomic) CleaningProcess process;
@property (weak, nonatomic) id <VirtualStickCleaningViewControllerDelegate> delegate;

@property (nonatomic) VirtualStickController* vsController;

- (IBAction)stopCleaningAction:(id)sender;
- (IBAction)rollSpeedAction:(id)sender;
- (IBAction)descendRangeAction:(id)sender;

- (void)stopMission;
- (void)startVSCleaning:(float)width height:(float)height cleaningMode:(CleaningMode)mode;

@end
