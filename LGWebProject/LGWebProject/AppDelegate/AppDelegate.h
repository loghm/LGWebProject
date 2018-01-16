//
//  AppDelegate.h
//  LGWebProject
//
//  Created by loghm on 2018/1/15.
//  Copyright © 2018年 loghm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FMDatabase.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic , strong) FMDatabase *db;

@property (nonatomic, copy) void(^wxReqResult) (NSInteger result);
@property (nonatomic, copy) void(^alipayReqResult) (NSString *result);


@end

