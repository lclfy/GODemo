//
//  MainAlbumModel.h
//  GODemo
//
//  Created by 罗思聪 on 16/3/11.
//  Copyright © 2016年 罗思聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MainAlbumModel : NSObject

//时间戳，单个图片，所有图片的名字，发表的文字，是否已经上传

@property (nonatomic,copy) NSDate *timeTag;
@property (nonatomic,copy) NSData *imageData;
@property (nonatomic,strong) NSArray *allPictures;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,assign) BOOL isUploaded;

//1. 保存到本地文件
//2. 从本地文件读取
//3. 用户选择保存图片
//4. 保存到服务器
//5. 从服务器读取
//6. 删除

@end
