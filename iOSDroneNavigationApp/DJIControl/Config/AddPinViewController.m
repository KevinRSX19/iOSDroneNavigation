//
//  AddPinViewController.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 12/6/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import "AddPinViewController.h"

@interface AddPinViewController ()

@end

@implementation AddPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.type setSelectedSegmentIndex:1];
    self.lon.text = @"-121.863";
    self.lat.text = @"37.352";
    self.address.text = @"999 E Caribbean Dr, Sunnyvale";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)stopedit:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)setBtnClicked:(id)sender {
    if ([_delegate respondsToSelector:@selector(setBtnClickedInAddPinVC:)]) {
        [_delegate setBtnClickedInAddPinVC:self];
    }
}

- (IBAction)cancelBtnClicked:(id)sender {
    if ([_delegate respondsToSelector:@selector(cancelBtnClickedInAddPinVC:)]) {
        [_delegate cancelBtnClickedInAddPinVC:self];
    }
}
@end
