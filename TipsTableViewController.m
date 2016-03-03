//
//  TipsTableViewController.m
//  GODemo
//
//  Created by 罗思聪 on 16/2/18.
//  Copyright © 2016年 罗思聪. All rights reserved.
//

#import "TipsTableViewController.h"
#import "TipsModel.h"
#import <BmobSDK/Bmob.h>
#import "AddEditTipsViewController.h"
#import "NoTipsViewCell.h"
#import "ProgressHUD.h"
#import "AnniversaryCell.h"


@interface TipsTableViewController () <UITableViewDataSource,UITableViewDelegate,AddEditTipsViewControllerDelegate>

@property (nonatomic,strong) NSMutableArray *tipsArray;

@end

@implementation TipsTableViewController

- (NSMutableArray *)tipsArray{
    if (_tipsArray == nil) {
        _tipsArray = [NSMutableArray array];
    }
    return _tipsArray;
}

#pragma mark - 对服务器数据进行操作

- (void)getTipsData{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Tips"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
    
        if (error != nil) {
            [ProgressHUD showError:@"无网络"];
            NSLog(@"%@",error);
        }else{
        for (BmobObject *obj in array) {
            TipsModel *tips = [[TipsModel alloc]init];
            tips.tipsName = [obj objectForKey:@"tipsName"];
            tips.isCompleted = [[obj objectForKey:@"tipsIsCompleted"] boolValue];
            tips.needToRemind = [[obj objectForKey:@"tipsNeedToRemind"] boolValue];
            tips.dueDate = [obj objectForKey:@"dueDate"];
            tips.tipsId = [obj objectForKey:@"objectId"];
            [_tipsArray addObject:tips];
            
        }
        }
        [self.tableView reloadData];
        //延时1秒消失
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [ProgressHUD dismiss]; });
    }];

    
}



#pragma -mark viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tipsArray];
//    [self getNewArray];
    [self getTipsData];
    

}

//用来临时往服务器里面添加数据…
- (void)getNewArray{
    TipsModel *tip1 = [[TipsModel alloc]init];
    tip1.tipsName = @"这是一个提醒";
    tip1.dueDate = [NSDate date];
    tip1.isCompleted = NO;
    tip1.needToRemind = NO;
    [self.tipsArray addObject:tip1];
    [TipsModel saveTipsArray:_tipsArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//返回按钮
- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//删除分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (_tipsArray.count != 0) {
        return _tipsArray.count;
    }else{
        return 1;
    }
    
    return _tipsArray.count;
}

//BmobQuery *query = [BmobQuery queryWithClassName:@"Tips"];
//[query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
//    
//    for (BmobObject *obj in array) {
//        TipsModel *tips = [[TipsModel alloc]init];
//        tips.tipsName = [obj objectForKey:@"tipsName"];
//        tips.tipsTime = [obj objectForKey:@"tipsTime"];
//        tips.isCompleted = [[obj objectForKey:@"tipsIsCompleted"] boolValue];
//        tips.needToRemind = [[obj objectForKey:@"tipsNeedToRemind"] boolValue];
//        [tipsArray addObject:tips];
//        
//    }
//}];

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yy-MM-dd HH:mm"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //显示提醒事项时
    if (_tipsArray.count != 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Tips"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Tips"];
        }
        
        TipsModel *tips = _tipsArray[indexPath.row];
        cell.textLabel.text = tips.tipsName;
        //如果需要提醒，就显示时间
        if (tips.needToRemind) {
            cell.detailTextLabel.text = [self stringFromDate:tips.dueDate];
            
        }else{
            cell.detailTextLabel.text = nil;
        }
        //设置完成和未完成时候的图片
        if (tips.isCompleted) {
            cell.imageView.image = [UIImage imageNamed:@"_remind_isCompleted"];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"_remind_isNotCompleted"];
        }
        
        //隐藏多余的分隔线
        [self setExtraCellLineHidden:tableView];
        return cell;
    }else{
        //如果没有任何提醒，则设置一个空白页面，页面使用NoTipsViewCell
        static NSString *CellIdentifier = @"NoTips";
        NoTipsViewCell *cell = (NoTipsViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell= (NoTipsViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"NoTipsViewCell" owner:self options:nil]  lastObject];
        }
//        AnniversaryCell *cell = (AnniversaryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (cell == nil) {
//            cell = (AnniversaryCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"AnniversaryCell" owner:self options:nil]  lastObject];
//        }
        //不能滑，不能选
        tableView.scrollEnabled = NO;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tipsArray.count != 0) {
        TipsModel *tips = _tipsArray[indexPath.row];
        if (tips.isCompleted) {
            tips.isCompleted = NO;
        }else{
            tips.isCompleted = YES;
        }
        _tipsArray[indexPath.row] = tips;
        [TipsModel editTipsData:indexPath allTips:_tipsArray];
        [self.tableView reloadData];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_tipsArray.count != 0) {
        return 50;
    }else{
        return self.view.bounds.size.height;
    }

}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_tipsArray.count != 0) {
        return YES;
    }else{
        return NO;
    }
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [TipsModel deleteTipsData:indexPath allTips:_tipsArray];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_tipsArray removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}

#pragma mark - 添加/修改内部数据的代理方法

- (void)AddEditTipsViewController:(AddEditTipsViewController *)controller didFinishAdding:(TipsModel *)tips{
    
    [self.tipsArray addObject:tips];
    [TipsModel saveTipsArray:_tipsArray];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)AddEditTipsViewController:(AddEditTipsViewController *)controller didFinishEditing:(TipsModel *)tips{
    
    NSInteger index = [_tipsArray indexOfObject:tips];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [TipsModel editTipsData:indexPath allTips:_tipsArray];
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)AddEditTipsViewControllerDidCancel:(AddEditTipsViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddTips"]) {
        UINavigationController *naviCon = segue.destinationViewController;
        AddEditTipsViewController *controller = (AddEditTipsViewController *)naviCon.topViewController;
        controller.delegate = self;
        controller.tipsToEdit = nil;
        
        
    }else if ([segue.identifier isEqualToString:@"EditTips"]){
        UINavigationController *naviCon = segue.destinationViewController;
        AddEditTipsViewController *controller = (AddEditTipsViewController *)naviCon.topViewController;
        controller.delegate = self;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        controller.tipsToEdit = _tipsArray[indexPath.row];
        
    }

}




@end
