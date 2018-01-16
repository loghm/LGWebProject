//
//  AppDelegate+Jpush.m
//  HybridApp
//
//  Created by iOSgo on 2017/9/12.
//  Copyright © 2017年 iOSgo. All rights reserved.
//

#import "AppDelegate+Jpush.h"

//极光推送
#import "JPUSHService.h" // 引入JPush功能所需头文件
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@implementation AppDelegate (Jpush)

- (void)setupJpushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
        
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
        
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
//    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    
    
#pragma mark -- 添加初始化JPush代码
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions
                           appKey:JPUSH_APPKEY
                          channel:JpushChannel
                 apsForProduction:JpushProduction
            advertisingIdentifier:nil];
    NSLog(@"jpushappkey:----------%@",JPUSH_APPKEY);
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            NSString *userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
            if (userid.length>0) {
//                [JPUSHService setTags:nil alias:userid callbackSelector:nil object:nil];
                [JPUSHService setAlias:userid completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
                    
                } seq:1];
            }
            
        } else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
#pragma mark - 本地缓存
    self.db = [[FMDBManager shareInstance] getDBWithDBName:@"Notification.sqlite"];
    
    //[[FMDBManager shareInstance] clearDatabase:self.db from:@"NotiMessage"];
    
    [[FMDBManager shareInstance] DataBase:self.db createTable:@"NotiMessage" keyTypes:@{@"date":@"text",@"type":@"text",@"title":@"text",@"content":@"text",@"id":@"text"}];
    
    //极光自定义发送消息
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
#pragma mark -- 本地推送
    // iOS8注册本地通知类型
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    //进入程序,红点设置为0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSString *content = [userInfo valueForKey:@"content"];
    
    NSDictionary *notiDict = [HelpManager dictionaryWithJsonString:content];
    
    NSDictionary *extras = [notiDict valueForKey:@"extra"];
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    
#pragma mark -- 本地通知
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil) return;
    
    localNotif.fireDate = [NSDate date];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    if ([notiDict[@"type"] intValue] == 2) {
        localNotif.alertBody = notiDict[@"content"];
    } else {
        localNotif.alertBody = notiDict[@"title"];
    }
    
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    localNotif.alertTitle = nil;
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
    localNotif.userInfo = userInfo;
    // 设置好本地推送后必须调用此方法启动此推送
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
    [[FMDBManager shareInstance] DataBase:self.db insertKeyValues:extras intoTable:@"NotiMessage"];
}


#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        [[FMDBManager shareInstance] DataBase:self.db insertKeyValues:userInfo intoTable:@"NotiMessage"];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        
        [[FMDBManager shareInstance] DataBase:self.db insertKeyValues:userInfo intoTable:@"NotiMessage"];
        
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


#pragma mark - 处理后台和前台通知点击
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    [self changeLocalNotifi:notification];
}

- (void)changeLocalNotifi:(UILocalNotification *)localNotifi{
    // 如果在前台直接返回
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        return;
    }
    // 获取通知信息
    NSString *selectIndex = localNotifi.userInfo[@"selectIndex"];
    // 获取根控制器TabBarController
    UITabBarController *rootController = (UITabBarController *)self.window.rootViewController;
    // 跳转到指定控制器
    rootController.selectedIndex = [selectIndex intValue];
}



@end
