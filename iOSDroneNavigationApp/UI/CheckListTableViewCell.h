//
//  CheckListTableViewCell.h
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 11/30/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckListTableViewCell : UITableViewCell

+ (instancetype)initTableViewCell:(UITableView *)tableView andCellIdentify:(NSString *)cellIdentify;
@property (weak, nonatomic) IBOutlet UILabel *checkNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (nonatomic, strong) NSDictionary *dic;

@end
