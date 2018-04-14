//
//  OthersViewController.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/22/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import "OthersViewController.h"
#import "DemoUtility.h"

@interface OthersViewController () <UITextFieldDelegate>

@end

@implementation OthersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    DJIFlightController* fc = [DemoUtility fetchFlightController];
    if (fc) {
        // initialize the UI
        [self displayMaxFlightHeight];
        [self displayFlightRadiusLimitation];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) displayMaxFlightHeight {
    DJIFlightController* fc = [DemoUtility fetchFlightController];
    if (fc) {
        [fc getMaxFlightHeightWithCompletion:^(float height, NSError * _Nullable error) {
            if (error) {
                ShowResult(@"Get Max Flight Height:%@", error.localizedDescription);
            }
            else
            {
                [self.heightLimit setText:[NSString stringWithFormat:@"%f", height]];
            }
        }];
    }
}

/**
 *  The setting for flight radius limitation is a bit complicated than flight height limitation. SDK provides the capability to toggle
 *  the radius limitation. Therefore, before fetching the exact radius limitation, we check if it is already enabled or not.
 */
-(void) displayFlightRadiusLimitation {
    DJIFlightController* fc = [DemoUtility fetchFlightController];
    if (fc) {
        [fc getMaxFlightRadiusLimitationEnabledWithCompletion:^(BOOL enabled, NSError * _Nullable error) {
            if (error) {
                ShowResult(@"Get RadiusLimitationEnable:%@", error.localizedDescription);
            }
            else
            {
                [self.limitSwitch setOn:enabled];
                
                // We check the flight radius limitation only if it is enabled.
                if (enabled) {
                    self.maxRadiusLimit.enabled = YES;
                    [fc getMaxFlightRadiusWithCompletion:^(float radius, NSError * _Nullable error) {
                        if (error) {
                            ShowResult(@"Get MaxFlightRadius:%@", error.localizedDescription);
                        }
                        else
                        {
                            self.maxRadiusLimit.text = [NSString stringWithFormat:@"%f", radius];
                        }
                    }];
                }
                else
                {
                    self.maxRadiusLimit.enabled = NO;
                    self.maxRadiusLimit.text = @"0";
                }
            }
        }];
    }
}

/**
 *  User can enable or disable the flight radius limitation using the UI component.
 *  Whenever the functionality is enabled, we fetch the limitation and display it.
 */
- (IBAction)limitSwitchAction:(UISwitch*)sender {
    DJIFlightController* fc = [DemoUtility fetchFlightController];
    if (fc) {
        [fc setMaxFlightRadiusLimitationEnabled:sender.on withCompletion:^(NSError * _Nullable error) {
            if (error) {
                ShowResult(@"setMaxFlightRadiusLimitationEnabled:%@", error.localizedDescription);
                [sender setOn:!sender.on animated:YES];
            }
            else
            {
                if (sender.on) {
                    self.maxRadiusLimit.enabled = YES;
                    DJIFlightController* fc = [DemoUtility fetchFlightController];
                    [fc getMaxFlightRadiusWithCompletion:^(float radius, NSError * _Nullable error) {
                        if (error) {
                            ShowResult(@"%@", error.localizedDescription);
                        }
                        else
                        {
                            self.maxRadiusLimit.text = [NSString stringWithFormat:@"%f", radius];
                        }
                    }];
                }
                else
                {
                    self.maxRadiusLimit.enabled = NO;
                    self.maxRadiusLimit.text = @"0";
                }
            }
        }];
    }
}

- (IBAction)closeBtnAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(closeBtnActionInOthersVC:) ]) {
        [_delegate closeBtnActionInOthersVC:self];
    }
}

- (IBAction)finishEditing:(id)sender {
}

- (IBAction)closeKeyboard:(id)sender {
    [self.view endEditing:YES];
    NSLog(@"click outside");
    if (![_heightLimit.text isEqualToString:@""]) {
        NSLog(@"h");
        float value = [_heightLimit.text floatValue];
        [self setMaxFlightHeight:value];
    }
    if (![_maxRadiusLimit.text isEqualToString:@""]) {
        NSLog(@"max");
        float value = [_maxRadiusLimit.text floatValue];
        [self setMaxFlightRadius:value];
    }
}

-(void) setMaxFlightHeight:(float)height
{
    DJIFlightController* fc = [DemoUtility fetchFlightController];
    if (fc) {
        [fc setMaxFlightHeight:height withCompletion:^(NSError * _Nullable error) {
            if (error) {
                ShowResult(@"setMaxFlightHeight:%@", error.localizedDescription);
            }
        }];
    }
}

-(void) setMaxFlightRadius:(float)radius
{
    DJIFlightController* fc = [DemoUtility fetchFlightController];
    if (fc) {
        [fc setMaxFlightRadius:radius withCompletion:^(NSError * _Nullable error) {
            if (error) {
                ShowResult(@"setMaxFlightRadius:%@", error.localizedDescription);
            }
        }];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ([textField isEqual:self.heightLimit]) {
        float value = [textField.text floatValue];
        if (value!=0.0 && value<20.0) {
            value = 20.0;
            [textField setText:@"20.0"];
        } else if(value>500.0){
            value = 500.0;
            [textField setText:@"500.0"];
        }
        [self setMaxFlightHeight:value];
    }
    else
    {
        float value = [textField.text floatValue];
        if (value!=0.0 && value<15.0) {
            value = 15.0;
            [textField setText:@"15.0"];
        } else if(value>300.0){
            value = 300.0;
            [textField setText:@"300.0"];
        }
        [self setMaxFlightRadius:value];
    }
    
    if (textField.isFirstResponder) {
        [textField resignFirstResponder];
    }
    NSLog(@"end");
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"return");
    return YES;
}

@end
