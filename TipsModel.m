//
//  TipsModel.m
//  GODemo
//
//  Created by 罗思聪 on 16/2/18.
//  Copyright © 2016年 罗思聪. All rights reserved.
//

#import "TipsModel.h"
#import <BmobSDK/Bmob.h>
#import "ProgressHUD.h"

@implementation TipsModel

//将tips存储到网络，读取方法在对应的Tips-viewController里面
//修改单条tip内容，删除单条tip


+ (void)saveTipsArray:(NSMutableArray *)tipsArray{
    BmobObject *tips = [BmobObject objectWithClassName:@"Tips"];
    for (TipsModel *tip in tipsArray) {
        [tips setObject:tip.tipsName forKey:@"tipsName"];
        [tips setObject:[NSNumber numberWithBool:tip.isCompleted] forKey:@"tipsIsCompleted"];
        [tips setObject:[NSNumber numberWithBool:tip.needToRemind] forKey:@"tipsNeedToRemind"];
        [tips setObject:tip.dueDate forKey:@"dueDate"];
        
    }
    [tips saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error){
        if (isSuccessful) {
            NSLog(@"Success!");
        }else if (error != nil){
            NSLog(@"%@",error);
        }
    }];
}

+ (void)editTipsData:(NSIndexPath *)indexPath allTips:(NSMutableArray *)tipsArray{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Tips"];
    TipsModel *tip = tipsArray[indexPath.row];
    [bquery getObjectInBackgroundWithId:tip.tipsId block:^(BmobObject *object,NSError *error){
        if (!error) {
            if (object) {
                BmobObject *tips = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                [tips setObject:tip.tipsName forKey:@"tipsName"];
                [tips setObject:[NSNumber numberWithBool:tip.isCompleted] forKey:@"tipsIsCompleted"];
                [tips setObject:[NSNumber numberWithBool:tip.needToRemind] forKey:@"tipsNeedToRemind"];
                [tips setObject:tip.dueDate forKey:@"dueDate"];
                [tips updateInBackground];
            }
        }else{
            static int i = 0;
            if (i < 5) {
                [self editTipsData:indexPath allTips:tipsArray];
                NSLog(@"%d",i);
            }else{
                [ProgressHUD showError:@"修改出错，请重试"];
            }
            NSLog(@"-修改出错 %@",error);
        }
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [ProgressHUD dismiss]; });
    }];
    
}

+ (void)deleteTipsData:(NSIndexPath *)indexPath allTips:(NSMutableArray *)tipsArray{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Tips"];
        TipsModel *tip = tipsArray[indexPath.row];
        [bquery getObjectInBackgroundWithId:tip.tipsId block:^(BmobObject *object,NSError *error){
            if (error) {
                    [ProgressHUD showError:@"删除出错，请重试"];
            }else{
                if (object) {
                    [object deleteInBackground];
                }
            }
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [ProgressHUD dismiss]; });
        }];

}







@end
