//
//  AnniversaryCell.h
//  GODemo
//
//  Created by 罗思聪 on 16/3/3.
//  Copyright © 2016年 罗思聪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnniversaryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *anniversaryName;
@property (strong, nonatomic) IBOutlet UILabel *dueDate;
@property (strong, nonatomic) IBOutlet UILabel *compareWithNowDate;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIImageView *topBar;



@end
