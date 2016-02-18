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

+ (void)saveUserInfo:(NSString *)name detail:(NSString *)detail userName:(NSString *)userName{
    BmobObject *tips = [BmobObject objectWithClassName:@"_User1"];
    [tips setObject:userName forKey:@"UserName"];
    [tips setObject:name forKey:@"name"];
    [tips setObject:detail forKey:@"detail"];
    
    [tips saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error){
        if (isSuccessful) {
            NSLog(@"Success!");
        }else{
            NSLog(@"Fail");
        }
    }];
}


+ (void)getUserInfo{
    BmobQuery *query = [BmobQuery queryWithClassName:@"User1"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error){
        
        for (BmobObject *obj in array) {
            static int i = 0;
            NSString *name = [obj objectForKey:@"name"];
            NSString *detail = [obj objectForKey:@"detail"];
            NSLog(@"%d --- 名字：%@ , 详情： %@", i , name , detail);
            i++;
        }
    }];
    
}




@end
