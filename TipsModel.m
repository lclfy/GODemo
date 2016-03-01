//
//  TipsModel.m
//  GODemo
//
//  Created by 罗思聪 on 16/2/18.
//  Copyright © 2016年 罗思聪. All rights reserved.
//

#import "TipsModel.h"
#import <BmobSDK/Bmob.h>

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
            NSLog(@"-修改出错 %@",error);
        }
    }];
    
}

+ (void)deleteTipsData:(NSIndexPath *)indexPath allTips:(NSMutableArray *)tipsArray{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Tips"];
        TipsModel *tip = tipsArray[indexPath.row];
        [bquery getObjectInBackgroundWithId:tip.tipsId block:^(BmobObject *object,NSError *error){
            if (error) {
                NSLog(@"-删除出错 %@",error);
            }else{
                if (object) {
                    [object deleteInBackground];
                }
            }
        }];

}







@end
