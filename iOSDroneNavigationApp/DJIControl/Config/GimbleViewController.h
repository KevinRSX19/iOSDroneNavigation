//
//  GimbleViewController.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/6/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GimbleViewController;

@protocol GimbleViewControllerDelegate<NSObject>

- (void)startBtnActionInGimbleVC:(GimbleViewController *)GimbleVC;
- (void)cancelBtnActionInGimbleVC:(GimbleViewController *)GimbleVC;

@end

@interface GimbleViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *attitude;
@property (weak, nonatomic) IBOutlet UIButton *minBtn;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *maxBtn;

@property (weak, nonatomic) id <GimbleViewControllerDelegate> delegate;

- (IBAction)minBtnAction:(id)sender;
- (IBAction)subBtnAction:(id)sender;
- (IBAction)addBtnAction:(id)sender;
- (IBAction)maxBtnAction:(id)sender;

- (IBAction)startBtnAction:(id)sender;
- (IBAction)cancelBtnAction:(id)sender;
- (IBAction)attitudeChanged:(id)sender;
@end
