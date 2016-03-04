//
//  AnniversaryCell.h
//  GODemo
//
//  Created by 罗思聪 on 16/3/3.
//  Copyright © 2016年 罗思聪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnniversaryCell;

@protocol AnniversaryCellDelegate <NSObject>
//提醒和倒数日的代理方法


- (void)AnniversaryCellWillEdit:(AnniversaryCell *)cell;

@end



@interface AnniversaryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *anniversaryName;
@property (strong, nonatomic) IBOutlet UILabel *dueDate;
@property (strong, nonatomic) IBOutlet UILabel *timeFromNow;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIImageView *topBar;

@property (weak,nonatomic) id delegate;


@end
