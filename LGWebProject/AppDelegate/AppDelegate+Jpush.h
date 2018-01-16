//
//  AppDelegate+Jpush.h
//  HybridApp
//
//  Created by iOSgo on 2017/9/12.
//  Copyright © 2017年 iOSgo. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Jpush) <JPUSHRegisterDelegate>

- (void)setupJpushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end
