//
//  AddEditTipsViewController.h
//  GODemo
//
//  Created by 罗思聪 on 16/2/19.
//  Copyright © 2016年 罗思聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipsModel.h"
#import "AnniversaryModel.h"

@class TipsModel;
@class AnniversaryModel;
@class AddEditViewController;

@protocol AddEditViewControllerDelegate <NSObject>
//提醒和倒数日的代理方法

- (void)AddEditViewControllerForTip:(AddEditViewController *)controller didFinishEditingTips:(TipsModel *)tips;

- (void)AddEditViewControllerForTip:(AddEditViewController *)controller didFinishAddingTips:(TipsModel *)tips;

- (void)AddEditViewControllerForTip:(AddEditViewController *)controller didDeleteTips:(TipsModel *)tips;

- (void)AddEditViewControllerForAnniversary:(AddEditViewController *)controller didFinishEditingAnniversary:(AnniversaryModel *)anniversary;

- (void)AddEditViewControllerForAnniversary:(AddEditViewController *)controller didFinishAddingAnniversary:(AnniversaryModel *)anniversary;

- (void)AddEditViewControllerForAnniversary:(AddEditViewController *)controller didDeleteAnniversary:(AnniversaryModel *)anniversary;

@end


@interface AddEditViewController : UITableViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic,weak) id<AddEditViewControllerDelegate> delegate;
@property (nonatomic,strong) TipsModel *tipsToEdit;
@property (nonatomic,strong) AnniversaryModel *anniversaryToEdit;

//是否提醒的开关，完成按钮和删除按钮
@property (weak, nonatomic) IBOutlet UISwitch *remindSwitchControl;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;

@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

//判断是提醒还是纪念日
@property (nonatomic,assign) BOOL tipAndAnni;


@end
