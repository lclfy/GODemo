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
#import "AddEditViewController.h"
#import "NoTipsViewCell.h"
#import "ProgressHUD.h"
#import "AnniversaryCell.h"
#import "AnniversaryModel.h"


@interface TipsTableViewController () <UITableViewDataSource,UITableViewDelegate,AddEditViewControllerDelegate>

@property (nonatomic,strong) NSMutableArray *tipsArray;
@property (nonatomic,strong) NSMutableArray *anniversaryArray;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentOfTipsAndAnni;
//tips和anniversary, 0的时候是tip，1的时候是anniversary
@property (nonatomic,assign) BOOL tipAndAnni;

@end

@implementation TipsTableViewController

#pragma mark - 懒加载数组

- (NSMutableArray *)tipsArray{
    if (_tipsArray == nil) {
        _tipsArray = [NSMutableArray array];
    }
    return _tipsArray;
}

- (NSMutableArray *)anniversaryArray{
    if (_anniversaryArray == nil) {
        _anniversaryArray = [NSMutableArray array];
    }
    return _anniversaryArray;
}

#pragma mark - 使用segment来控制是哪一个

- (void)isTipOrAnni{
    if (!_tipAndAnni) {
        _tipAndAnni = !_tipAndAnni;
//        [self getAnniversaryData];
        [self.tableView reloadData];
    }else{
        _tipAndAnni = !_tipAndAnni;
//        [self getTipsData];
        [self.tableView reloadData];
    }

    NSLog(@"%@",[NSNumber numberWithBool:_tipAndAnni]);
}


#pragma mark - 对服务器数据进行操作/提醒/纪念日

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

- (void)getAnniversaryData{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Anniversary"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
        
        if (error != nil) {
            [ProgressHUD showError:@"无网络"];
            NSLog(@"%@",error);
        }else{
            for (BmobObject *obj in array) {
                AnniversaryModel *anniversary = [[AnniversaryModel alloc]init];
                anniversary.anniversaryName = [obj objectForKey:@"anniversaryName"];
                anniversary.isDue = [[obj objectForKey:@"anniversaryIsDue"]boolValue];
                anniversary.dueDate = [obj objectForKey:@"dueDate"];
                anniversary.anniversaryId = [obj objectForKey:@"objectID"];
                [_anniversaryArray addObject:anniversary];
                
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
    [self anniversaryArray];
//    [self getNewArray];
    [self getTipsData];
    [self getAnniversaryData];
    [self.segmentOfTipsAndAnni addTarget:self action:@selector(isTipOrAnni) forControlEvents:UIControlEventValueChanged];
    

}

//用来临时往服务器里面添加数据…
- (void)getNewArray{
//    TipsModel *tip1 = [[TipsModel alloc]init];
//    tip1.tipsName = @"这是一个提醒";
//    tip1.dueDate = [NSDate date];
//    tip1.isCompleted = NO;
//    tip1.needToRemind = NO;
//    [self.tipsArray addObject:tip1];
//    [TipsModel saveTipsArray:_tipsArray];
    
    AnniversaryModel *anni1 = [[AnniversaryModel alloc]init];
    anni1.dueDate = [[NSDate alloc]initWithTimeIntervalSinceReferenceDate:400000000];
    NSDate *now = [NSDate date];
    if ([anni1.dueDate laterDate:now] == anni1.dueDate ) {
        //如果更晚的是dueDate，就说明还没有到期，就返回NO
        anni1.isDue = NO;
    }else{
        anni1.isDue = YES;
    }
    NSString *name = @"iPhone发布";
    anni1.anniversaryName = name;
    [self.anniversaryArray addObject:anni1];
    [AnniversaryModel saveAnniversaryArray:self.anniversaryArray];
    
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
    //通过tipsAndAnni来判断到底是哪个（提醒是0，倒数日是1）
    if (!_tipAndAnni) {
        if (_tipsArray.count != 0) {
            return _tipsArray.count;
        }else{
            return 1;
        }
        
        return _tipsArray.count;
    }else{

    return [_anniversaryArray count];
    }
}

- (NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    if (!_tipAndAnni) {
            [dateFormatter setDateFormat:@"yy-MM-dd HH:mm"];
    }else{
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!_tipAndAnni) {
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
            tableView.scrollEnabled = YES;
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            return cell;
        }else{
            //如果没有任何提醒，则设置一个空白页面，页面使用NoTipsViewCell
            static NSString *CellIdentifier = @"NoTips";
            NoTipsViewCell *cell = (NoTipsViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil)
            {
                cell= (NoTipsViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"NoTipsViewCell" owner:self options:nil]  lastObject];
            }
            //不能滑，不能选
            tableView.scrollEnabled = NO;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        }else{
            //显示倒数日时
            static NSString *reuseID = @"AnniversaryCell";
            AnniversaryCell *cell = (AnniversaryCell *)[tableView dequeueReusableCellWithIdentifier:reuseID];
            if (cell == nil) {
                cell = (AnniversaryCell *)[[[NSBundle mainBundle] loadNibNamed:@"AnniversaryCell" owner:self options:nil]lastObject];
            }
            AnniversaryModel *model1 = _anniversaryArray[indexPath.row];
            NSString *nameWithTag = [[NSString alloc]init];
            if (model1.isDue) {
                nameWithTag = [model1.anniversaryName stringByAppendingString:@"已经"];
            }else{
                nameWithTag = [model1.anniversaryName stringByAppendingString:@"还有"];
            }
            if (indexPath.row == 0) {
                [cell.editButton setHidden:YES];
            }else{
                [cell.topBar setHidden:YES];
            }
            cell.anniversaryName.text = nameWithTag;
            cell.dueDate.text = [self stringFromDate:model1.dueDate];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.scrollEnabled = YES;
            
            return cell;

        }
    

    

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_tipAndAnni) {
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


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_tipAndAnni) {
        if (_tipsArray.count != 0) {
            return 50;
        }else{
            return self.view.bounds.size.height;
        }
    }else{
        return 100;
    }

}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_tipAndAnni) {
        if (_tipsArray.count != 0) {
            return YES;
        }else{
            return NO;
        }
    }else{
        if (indexPath.row == 0) {
            return NO;
        }else{
            return YES;
        }
    }

}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (!_tipAndAnni) {
            [TipsModel deleteTipsData:indexPath allTips:_tipsArray];
            //        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [_tipsArray removeObjectAtIndex:indexPath.row];
            [tableView reloadData];
        }else{
            [AnniversaryModel deleteAnniversaryData:indexPath allAnniversaries:_anniversaryArray];
            //        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [_anniversaryArray removeObjectAtIndex:indexPath.row];
            [tableView reloadData];
        }
    }

}

#pragma mark - 添加/修改内部数据的代理方法


//AddTip
- (void)AddEditViewControllerForTip:(AddEditViewController *)controller didFinishAddingTips:(TipsModel *)tips{
    
    [self.tipsArray addObject:tips];
    [TipsModel saveTipsArray:_tipsArray];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//EditTip
- (void)AddEditViewControllerForTip:(AddEditViewController *)controller didFinishEditingTips:(TipsModel *)tips{
    
    NSInteger index = [_tipsArray indexOfObject:tips];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [TipsModel editTipsData:indexPath allTips:_tipsArray];
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//AddAnniversary
- (void)AddEditViewControllerForAnniversay:(AddEditViewController *)controller didFinishAddingAnniversary:(AnniversaryModel *)anniversary{
    
    [self.anniversaryArray addObject:anniversary];
    [AnniversaryModel saveAnniversaryArray:_anniversaryArray];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//EditAnniversary
- (void)AddEditViewControllerForAnniversary:(AddEditViewController *)controller didFinishEditingAnniversary:(AnniversaryModel *)anniversary{
    NSInteger index = [_anniversaryArray indexOfObject:anniversary];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [AnniversaryModel editAnniversaryData:indexPath allAnniversaries:_anniversaryArray];
    //    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}





#pragma mark - Navigation
//注意：编辑倒数日的功能在下方，EditAnniversary方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (!_tipAndAnni) {
        if ([segue.identifier isEqualToString:@"Add"]) {
            UINavigationController *naviCon = segue.destinationViewController;
            AddEditViewController *controller = (AddEditViewController *)naviCon.topViewController;
            controller.delegate = self;
            controller.tipAndAnni = self.tipAndAnni;
            controller.tipsToEdit = nil;
            
            
        }else if ([segue.identifier isEqualToString:@"EditTips"]){
            UINavigationController *naviCon = segue.destinationViewController;
            AddEditViewController *controller = (AddEditViewController *)naviCon.topViewController;
            controller.delegate = self;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            controller.tipsToEdit = _tipsArray[indexPath.row];
            
        }
    }else{
        if ([segue.identifier isEqualToString:@"Add"]) {
            UINavigationController *naviCon = segue.destinationViewController;
            AddEditViewController *controller = (AddEditViewController *)naviCon.topViewController;
            controller.delegate = self;
            controller.tipAndAnni = self.tipAndAnni;
            controller.anniversaryToEdit = nil;
        }
    }


}

+ (void)editAnniversary{
    NSLog(@"11111");
    
}




@end
