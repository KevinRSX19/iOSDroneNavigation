//
//  AddPinViewController.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/6/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddPinViewController;

@protocol AddPinViewControllerDelegate<NSObject>

- (void)setBtnClickedInAddPinVC:(AddPinViewController *)AddPinVC;
- (void)cancelBtnClickedInAddPinVC:(AddPinViewController *)AddPinVC;

@end

@interface AddPinViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *lat;
@property (weak, nonatomic) IBOutlet UITextField *lon;
@property (weak, nonatomic) IBOutlet UISegmentedControl *type;

@property (weak, nonatomic) id <AddPinViewControllerDelegate> delegate;

- (IBAction)setBtnClicked:(id)sender;
- (IBAction)cancelBtnClicked:(id)sender;

@end
