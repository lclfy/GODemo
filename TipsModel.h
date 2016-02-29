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

//提醒事项里面的四个属性，分别是提醒名字，提醒时间，是否完成，需要提醒，ID
@property (nonatomic,copy) NSString *tipsName;
@property (nonatomic,assign) BOOL isCompleted;
@property (nonatomic,assign) BOOL needToRemind;
@property (nonatomic,copy) NSDate *dueDate;
@property (nonatomic,copy) NSString *tipsId;

//存储，修改，删除
+ (void)saveTipsArray:(NSMutableArray *)tipsArray;

+ (void)editTipsData:(NSIndexPath *)indexPath allTips:(NSMutableArray *)tipsArray;

+ (void)deleteTipsData:(NSIndexPath *)indexPath allTips:(NSMutableArray *)tipsArray;

@end
