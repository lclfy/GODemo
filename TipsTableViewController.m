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


@interface TipsTableViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *tipsArray;

@end

@implementation TipsTableViewController

- (NSMutableArray *)tipsArray{
    if (_tipsArray == nil) {
        _tipsArray = [NSMutableArray array];
    }
    return _tipsArray;
}

- (void)getTipsData{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Tips"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
        
        for (BmobObject *obj in array) {
            TipsModel *tips = [[TipsModel alloc]init];
            tips.tipsName = [obj objectForKey:@"tipsName"];
            tips.tipsTime = [obj objectForKey:@"tipsTime"];
            tips.isCompleted = [[obj objectForKey:@"tipsIsCompleted"] boolValue];
            tips.needToRemind = [[obj objectForKey:@"tipsNeedToRemind"] boolValue];
            [_tipsArray addObject:tips];
            
        }
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tipsArray];
    [self getTipsData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//返回按钮
- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Tips"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Tips"];
    }

    TipsModel *tips = _tipsArray[indexPath.row];
    cell.textLabel.text = tips.tipsName;
    cell.detailTextLabel.text = tips.tipsTime;
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"AddTips"]) {
        UINavigationController *naviCon = segue.destinationViewController;
//        AddEditTipsViewController *controller = (AddEditTipsViewController *)naviCon.topViewController;
        
    }else if ([segue.identifier isEqualToString:@"EditTips"]){
        UINavigationController *naviCon = segue.destinationViewController;
//        AddEditTipsViewController *controller = (AddEditTipsViewController *)naviCon.topViewController;
        naviCon.title = @"修改提醒";
    }

    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
@end
