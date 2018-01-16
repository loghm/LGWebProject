//
//  AppDelegate.m
//  LGWebProject
//
//  Created by loghm on 2018/1/15.
//  Copyright © 2018年 loghm. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+UMeng.h"
#import "AppDelegate+Jpush.h"

@interface AppDelegate ()

@property (nonatomic, strong) STMURLCache *sCache;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    NSArray *whiteLists = @[INDEX_URL, @"http://www.zlzvip.com"];
    self.sCache = [STMURLCache create:^(STMURLCacheMk *mk) {
        mk.whiteListsHost(whiteLists).whiteUserAgent(@"starming").isUsingURLProtocol(NO).cacheTime(20);
    }];
    
    [self.sCache preLoadByRequestWithUrls:whiteLists];
    
    //友盟统计
    [self setupUMeng];
    
    NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"userInfo:....%@", userInfo);
    //极光推送
    [self setupJpushApplication:application didFinishLaunchingWithOptions:launchOptions];
    [LocationManager shareInstance];
    
    [self.window makeKeyWindow];
    [self.window makeKeyAndVisible];
    
    //加载主控制器
    [self makeRooterViewController];
    
    return YES;
}

- (void)makeRooterViewController {
    
    if (![userDef boolForKey:@"firstLaunch"]) {
        
        [userDef setBool:YES forKey:@"firstLaunch"];
//        GuideViewController *fristVC = [[GuideViewController alloc] init];
//        self.window.rootViewController = fristVC;
        
    } else {
        
        //判断登录
        
        if ([userDef boolForKey:USER_ISLOGINED]) {
            
//            MainViewController *mainvc = [[MainViewController alloc] init];
//            self.window.rootViewController = mainvc;
            
            
        } else {
//            LoginViewController *login = [[LoginViewController alloc] init];
//            NavViewController *loginNav = [[NavViewController alloc] initWithRootViewController:login];
//            self.window.rootViewController = loginNav;
        }

    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
