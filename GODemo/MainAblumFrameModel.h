//
//  MainAblumFrameModel.h
//  GODemo
//
//  Created by 罗思聪 on 16/3/17.
//  Copyright © 2016年 罗思聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MainAlbumModel.h"

@interface MainAblumFrameModel : NSObject

@property (nonatomic,assign,readonly) CGRect image1F;
@property (nonatomic, assign,readonly) CGRect image2F;
@property (nonatomic, assign,readonly) CGRect image3F;
@property (nonatomic, assign,readonly) CGRect image4F;
@property (nonatomic, assign,readonly)CGFloat cellH;

@property (nonatomic,strong) MainAlbumModel *photos;

@end
