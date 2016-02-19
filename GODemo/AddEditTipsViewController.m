//
//  AddEditTipsViewController.m
//  GODemo
//
//  Created by 罗思聪 on 16/2/19.
//  Copyright © 2016年 罗思聪. All rights reserved.
//

#import "AddEditTipsViewController.h"
#import "TipsModel.h"

@interface AddEditTipsViewController ()

@property (nonatomic,strong) TipsModel *tips;


@end

@implementation AddEditTipsViewController

- (TipsModel *)tips{
    if (_tips == nil) {
        _tips = [[TipsModel alloc]init];
    }
    return _tips;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textField becomeFirstResponder];
    [self.textField addTarget:self action:@selector(textChanged) forControlEvents:UIControlEventEditingChanged];
    //分为编辑界面和添加界面分别规定界面元素内容
    if (_tipsToEdit != nil) {
        self.title = @"修改提醒";
        self.textField.text = self.tipsToEdit.tipsName;
        self.doneBtn.enabled = YES;
        self.remindSwitchControl.on = self.tipsToEdit.needToRemind;
        
    }else{
        self.remindSwitchControl.on = NO;
    }
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - 监听文本框
//监听内容：如果文本不为空 则完成按钮开启，将编辑和添加分别赋值。

- (void)textChanged{
    if (_textField.text.length) {
        self.doneBtn.enabled = YES;
    }else{
        self.doneBtn.enabled = NO;
    }
    if (_tipsToEdit != nil) {
        self.tipsToEdit.tipsName = _textField.text;
        NSLog(@"edit");
    }else{
        self.tips.tipsName = _textField.text;
        NSLog(@"%@",_textField.text);
    }
    
}

#pragma mark - 按钮作用

- (IBAction)doneBtn:(id)sender {
    if (_tipsToEdit != nil) {
        [self.delegate AddEditTipsViewController:self didFinishEditing:_tipsToEdit];
    }else{
    [self.delegate AddEditTipsViewController:self didFinishAdding:_tips];
    }
}


- (IBAction)cancelBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
