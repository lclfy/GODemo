//
//  TipsModel.h
//  GODemo
//
//  Created by 罗思聪 on 16/2/18.
//  Copyright © 2016年 罗思聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TipsModel : NSObject

@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *detail;

+ (void)saveUserInfo:(NSString *)name detail:(NSString *)detail userName:(NSString *)userName;

+ (void)getUserInfo;

@end
