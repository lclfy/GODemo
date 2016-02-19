//
//  AddEditTipsViewController.h
//  GODemo
//
//  Created by 罗思聪 on 16/2/19.
//  Copyright © 2016年 罗思聪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TipsModel;
@class AddEditTipsViewController;

@protocol AddEditTipsViewControllerDelegate <NSObject>

- (void)AddEditTipsViewControllerDidCancel:(AddEditTipsViewController *)controller;

- (void)AddEditTipsViewController:(AddEditTipsViewController *)controller didFinishEditing:(TipsModel *)tips;

- (void)AddEditTipsViewController:(AddEditTipsViewController *)controller didFinishAdding:(TipsModel *)tips;

@end

@interface AddEditTipsViewController : UITableViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic,weak) id<AddEditTipsViewControllerDelegate> delegate;
@property (nonatomic,strong) TipsModel *tipsToEdit;


@property (weak, nonatomic) IBOutlet UISwitch *remindSwitchControl;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;


@end
