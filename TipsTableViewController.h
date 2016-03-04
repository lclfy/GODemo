//
//  TipsTableViewController.h
//  GODemo
//
//  Created by 罗思聪 on 16/2/18.
//  Copyright © 2016年 罗思聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEditViewController.h"
#import "AnniversaryCell.h"


@interface TipsTableViewController : UITableViewController <AddEditViewControllerDelegate,AnniversaryCellDelegate>

- (void)editAnniversary;

@end
