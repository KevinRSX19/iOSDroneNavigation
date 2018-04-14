//
//  CheckListTableViewCell.m
//  iOSDroneNavigationApp
//
//  Created by 王凯旋 on 11/30/17.
//  Copyright © 2017 Kaixuan Wang. All rights reserved.
//

#import "CheckListTableViewCell.h"

@implementation CheckListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)initTableViewCell:(UITableView *)tableVieW andCellIdentify:(NSString *)cellIdentify{
    CheckListTableViewCell *cell = [tableVieW dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentify owner:nil options:nil]lastObject];
    }//由于是从xib中创建，所以调用loadNibName的方法
    return cell;
}

- (void)setDic:(NSDictionary *)dic

{
    
    if (dic) {
        _dic = dic;
        _checkNameLabel.text = [_dic objectForKey:@"checkName"];
        _statusLabel.text = [_dic objectForKey:@"status"];
    }
}

@end
