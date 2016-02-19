//
//  AddEditTipsViewController.m
//  GODemo
//
//  Created by 罗思聪 on 16/2/19.
//  Copyright © 2016年 罗思聪. All rights reserved.
//

#import "AddEditTipsViewController.h"

@interface AddEditTipsViewController ()

@end

@implementation AddEditTipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)cancelBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
