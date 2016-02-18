//
//  TipsModel.h
//  GODemo
//
//  Created by 罗思聪 on 16/2/18.
//  Copyright © 2016年 罗思聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TipsModel : NSObject
//提醒事项的数据模型

//提醒事项里面的四个属性，分别是提醒名字，提醒时间，是否完成，需要提醒fou
@property (nonatomic,copy) NSString *tipsName;
@property (nonatomic,copy) NSString *tipsTime;
@property (nonatomic,assign) BOOL isCompleted;
@property (nonatomic,assign) BOOL needToRemind;

//存储和获取Tips
+ (void)saveTips:(NSMutableArray *)tipsArray;



@end
