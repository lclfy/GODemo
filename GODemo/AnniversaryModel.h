//
//  AnniversaryModel.h
//  GODemo
//
//  Created by 罗思聪 on 16/3/3.
//  Copyright © 2016年 罗思聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnniversaryModel : NSObject

//纪念日的数据模型

//纪念日里面的属性，分别是名称，日期，已经/还有切换的BOOL，距今日期
@property (nonatomic,copy) NSString *anniversaryName;
@property (nonatomic,assign) BOOL isDue;
@property (nonatomic,copy) NSDate *dueDate;
@property (nonatomic,copy) NSString *anniversaryId;
@property (nonatomic,copy) NSString *timeFromNow;


//存储，修改，删除
+ (void)saveAnniversaryArray:(NSMutableArray *)anniversaryArray;

+ (void)editAnniversaryData:(NSIndexPath *)indexPath allAnniversaries:(NSMutableArray *)anniversaryArray;

+ (void)deleteAnniversaryData:(NSIndexPath *)indexPath allAnniversaries:(NSMutableArray *)anniversaryArray;


@end
