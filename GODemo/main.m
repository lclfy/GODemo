//
//  main.m
//  GODemo
//
//  Created by 罗思聪 on 16/2/18.
//  Copyright © 2016年 罗思聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSString *appKey = @"ba0a7e0174f755e11964990187515341";
        [Bmob registerWithAppKey:appKey];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
