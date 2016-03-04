//
//  AnniversaryCell.m
//  GODemo
//
//  Created by 罗思聪 on 16/3/3.
//  Copyright © 2016年 罗思聪. All rights reserved.
//

#import "AnniversaryCell.h"
#import "TipsTableViewController.h"

@implementation AnniversaryCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 点击按钮后执行的动作
- (IBAction)editButton:(id)sender {
    [TipsTableViewController editAnniversary];
    
}




@end
