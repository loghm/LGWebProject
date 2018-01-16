//
//  LocationManager.h
//  HybridApp
//
//  Created by iOSgo on 2017/9/12.
//  Copyright © 2017年 iOSgo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationManager : NSObject

+ (instancetype)shareInstance;

/* 定位GPS json字符串 */
@property (nonatomic , strong) NSString *locationJsonString;

/* 定位开发设置 */
- (void)locationServicesStatus;

@end
