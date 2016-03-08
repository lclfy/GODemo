//
//  AddEditTipsViewController.m
//  GODemo
//
//  Created by 罗思聪 on 16/2/19.
//  Copyright © 2016年 罗思聪. All rights reserved.
//

#import "AddEditViewController.h"
#import "TipsModel.h"
#import "AnniversaryModel.h"

@interface AddEditViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) TipsModel *tips;
@property (nonatomic,strong) AnniversaryModel *anniversary;
@property (nonatomic,copy) NSDate *dueDate;
@property (strong, nonatomic) IBOutlet UILabel *dueDateLabel;


@property (strong, nonatomic) IBOutlet UILabel *EnabledToRemind;
@property (strong, nonatomic) IBOutlet UISwitch *EnableToRemindSwitch;




@end

@implementation AddEditViewController{
    NSDate *_dueDate;
    BOOL _datePickerVisible;
}

#pragma mark - 懒加载
- (TipsModel *)tips{
    if (_tips == nil) {
        _tips = [[TipsModel alloc]init];
    }
    return _tips;
}

- (AnniversaryModel *)anniversary{
    if (_anniversary == nil) {
        _anniversary = [[AnniversaryModel alloc]init];
    }
    return _anniversary;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",[NSNumber numberWithBool:self.tipAndAnni]);
    [self.textField becomeFirstResponder];
    [self.textField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
    //分为编辑界面和添加界面分别规定界面元素内容
    if (!self.tipAndAnni) {
        if (_tipsToEdit != nil) {
            self.title = @"修改提醒";
            self.textField.text = self.tipsToEdit.tipsName;
            self.doneBtn.enabled = YES;
            [self.remindSwitchControl setOn:self.tipsToEdit.needToRemind];
            _dueDate = self.tipsToEdit.dueDate;
            
            
        }else{
            self.remindSwitchControl.on = NO;
            _dueDate = [NSDate date];
        }
    }else{
        if (_anniversaryToEdit != nil) {
            self.title = @"修改纪念日";
            self.textField.text = self.anniversaryToEdit.anniversaryName;
            self.doneBtn.enabled = YES;
            _dueDate = self.anniversaryToEdit.dueDate;
        }else{
            self.title = @"添加纪念日";
            _dueDate = [NSDate date];
        }
    }
    
    
    [self updateDueDateLabel];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 更新时间标签

- (void)updateDueDateLabel{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    if (!_tipAndAnni) {
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
    }else{
        [formatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    self.dueDateLabel.text = [formatter stringFromDate:_dueDate];
    
}

#pragma mark - 显示隐藏时间选择器/选择器改变值的时候的方法

- (void)showDatePicker{
    _datePickerVisible = YES;
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
    [self.tableView insertRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    UITableViewCell *datePickerCell = [self.tableView cellForRowAtIndexPath:indexPathDatePicker];
    UIDatePicker *datePicker = (UIDatePicker *)[datePickerCell viewWithTag:100];
    [datePicker setDate:_dueDate animated:YES];
}

- (void)dateChanged:(UIDatePicker *)datePicker{
    _dueDate = datePicker.date;
    [self updateDueDateLabel];
}

- (void)hideDatePicker{
    if (_datePickerVisible) {
        _datePickerVisible = NO;
        NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:1 inSection:1];
        NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDateRow];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        
        [self.tableView beginUpdates];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.tableView endUpdates];
    }
}

#pragma mark - 监听文本框
//监听内容：如果文本不为空 则完成按钮开启，将编辑和添加分别赋值。

- (void)textChanged{
    if (_textField.text.length) {
        self.doneBtn.enabled = YES;
    }else{
        self.doneBtn.enabled = NO;
    }
    if (!_tipAndAnni) {
        if (_tipsToEdit != nil) {
            self.tipsToEdit.tipsName = _textField.text;
            NSLog(@"edit-tip");
        }else{
            self.tips.tipsName = _textField.text;
            NSLog(@"%@",_textField.text);
        }
    }else{
        if (_tipsToEdit != nil) {
            self.anniversaryToEdit.anniversaryName = _textField.text;
            NSLog(@"edit-anni");
        }else{
            self.anniversary.anniversaryName = _textField.text;
            NSLog(@"%@",_textField.text);
        }
    }
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self hideDatePicker];
}

#pragma mark - 按钮作用

- (IBAction)doneBtn:(id)sender {
    if (!_tipAndAnni) {
        if (_tipsToEdit != nil) {
            _tipsToEdit.needToRemind = self.remindSwitchControl.on;
            _tipsToEdit.dueDate = _dueDate;
            [self.delegate AddEditViewControllerForTip:self didFinishEditingTips:_tipsToEdit];
        }else{
            _tips.needToRemind = self.remindSwitchControl.on;
            _tips.dueDate = _dueDate;
            [self.delegate AddEditViewControllerForTip:self didFinishAddingTips:_tips];
        }
    }else{
        if (_anniversaryToEdit != nil) {
            _anniversaryToEdit.dueDate = _dueDate;
            [self.delegate AddEditViewControllerForAnniversary:self didFinishEditingAnniversary:_anniversaryToEdit];
        }else{
            _anniversary.dueDate = _dueDate;
            [self.delegate AddEditViewControllerForAnniversary:self didFinishAddingAnniversary:_anniversary];
        }
    }
    
}

- (IBAction)deleteBtn:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"将删除该内容" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (_anniversaryToEdit != nil) {
            [self.delegate AddEditViewControllerForAnniversary:self didDeleteAnniversary:_anniversaryToEdit];
        }else if (_tipsToEdit != nil){
            [self.delegate AddEditViewControllerForTip:self didDeleteTips:_tipsToEdit];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}



- (IBAction)cancelBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableView Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tipAndAnni) {
        self.EnabledToRemind.text = @"请选择倒数日的时间";
        [self.EnableToRemindSwitch setHidden:YES];
    }
    
    if (indexPath.section == 1 && indexPath.row == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DatePickerCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DatePickerCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 216.0f)];
            if (!_tipAndAnni) {
                datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            }else{
                datePicker.datePickerMode = UIDatePickerModeDate;
            }
            
            datePicker.tag = 100;
            [cell.contentView addSubview:datePicker];
            
            [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        }
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1 && _datePickerVisible) {
        return 3;
    }else{
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //临时隐藏在添加状态下的“删除”按钮
    //判断什么时候应该出现删除按钮
    if (_tipsToEdit != nil || _anniversaryToEdit != nil) {
        
    }else{
        if (indexPath.section == 2 && indexPath.row == 0) {
            return 0;
        }
    }
    
    if (indexPath.section == 1 && indexPath.row == 2) {
        return 217.0f;
    }else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.textField resignFirstResponder];
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        if (!_datePickerVisible) {
            [self showDatePicker];
        }else{
            
            [self hideDatePicker];
        }
    }
}



- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1 && indexPath.section == 1) {
        return indexPath;
    }else{
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 2) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        return [super tableView:tableView indentationLevelForRowAtIndexPath:newIndexPath];
    }else{
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}





@end
