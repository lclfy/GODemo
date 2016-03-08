//
//  AnniversaryModel.m
//  GODemo
//
//  Created by 罗思聪 on 16/3/3.
//  Copyright © 2016年 罗思聪. All rights reserved.
//

#import "AnniversaryModel.h"
#import <BmobSDK/Bmob.h>
#import "ProgressHUD.h"

@implementation AnniversaryModel

//将纪念日存储到网络，读取方法在对应的ViewController里面
//修改单条纪念日内容，删除单条信息


+ (void)saveAnniversaryArray:(NSMutableArray *)anniversaryArray{
    BmobObject *object = [BmobObject objectWithClassName:@"Anniversary"];
    for (AnniversaryModel *anniversaries in anniversaryArray) {
        [object setObject:anniversaries.anniversaryName forKey:@"anniversaryName" ];
        [object setObject:anniversaries.dueDate forKey:@"dueDate"];
//        [object setObject:anniversaries.timeFromNow forKey:@"timeFromNow" ];
//        [object setObject:[NSNumber numberWithBool:anniversaries.isDue] forKey:@"anniversaryIsDue"];

        
    }
    [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error){
        if (isSuccessful) {
            NSLog(@"Success!");
        }else if (error != nil){
            NSLog(@"%@",error);
        }
    }];
}

+ (void)editAnniversaryData:(NSIndexPath *)indexPath allAnniversaries:(NSMutableArray *)anniversaryArray{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Anniversary"];
    AnniversaryModel *anniversaries = anniversaryArray[indexPath.row];
    [bquery getObjectInBackgroundWithId:anniversaries.anniversaryId block:^(BmobObject *object,NSError *error){
        if (!error) {
            if (object) {
                BmobObject *object = [BmobObject objectWithoutDatatWithClassName:object.className objectId:object.objectId];
                [object setObject:anniversaries.anniversaryName forKey:@"anniversaryName" ];
                [object setObject:anniversaries.dueDate forKey:@"dueDate"];
                [object updateInBackground];
//                [object setObject:anniversaries.timeFromNow forKey:@"timeFromNow" ];
//                [object setObject:[NSNumber numberWithBool:anniversaries.isDue] forKey:@"anniversaryIsDue"];

            }
        }else{
            static int i = 0;
            if (i < 5) {
                [self editAnniversaryData:indexPath allAnniversaries:anniversaryArray];
                NSLog(@"%d",i);
            }else{
                [ProgressHUD showError:@"编辑出错，请重试"];
            }
            NSLog(@"-修改出错 %@",error);
        }
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [ProgressHUD dismiss]; });
    }];
    
}

+ (void)deleteAnniversaryData:(NSIndexPath *)indexPath allAnniversaries:(NSMutableArray *)anniversaryArray{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Anniversary"];
    AnniversaryModel *anniversaries = anniversaryArray[indexPath.row];
    [bquery getObjectInBackgroundWithId:anniversaries.anniversaryId block:^(BmobObject *object,NSError *error){
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
