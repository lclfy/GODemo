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







@end
