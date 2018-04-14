//
//  OthersViewController.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/22/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OthersViewController;

@protocol OthersViewControllerDelegate<NSObject>

- (void)closeBtnActionInOthersVC:(OthersViewController *)OthersVC;

@end

@interface OthersViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *maxRadiusLimit;
@property (weak, nonatomic) IBOutlet UISwitch *limitSwitch;
@property (weak, nonatomic) IBOutlet UITextField *heightLimit;

@property (weak, nonatomic) id <OthersViewControllerDelegate> delegate;

- (IBAction)limitSwitchAction:(UISwitch*)sender;
- (IBAction)closeBtnAction:(id)sender;
- (IBAction)finishEditing:(id)sender;
- (IBAction)closeKeyboard:(id)sender;

-(void) displayMaxFlightHeight;
-(void) displayFlightRadiusLimitation;

@end
