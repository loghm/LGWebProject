//
//  LGWebPageViewController.h
//  LGWebProject
//
//  Created by loghm on 2018/1/15.
//  Copyright © 2018年 loghm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>


@protocol JSObjcDelegate <JSExport>

//登录
- (NSString *)getToken;
- (NSString *)getLoginData;
- (void)login;  //登录
- (void)logout; //退出登录

- (void)forgetWord; // 忘记密码
- (void)tocleanCache;//清除缓存

- (NSString *)refreshToken; //刷新Token

- (void)back;   //从WebView返回原生
- (void)exit;   //退出App

- (void)getLocation:(NSString *)params; //获取定位

//支付
- (void)choosePay:(NSString *)payInfo;
- (void)pay:(NSString *)payInfo;

- (void)chooseShare:(NSString *)params; //分享 提供UI
- (void)share:(NSString *)params; //分享,不提供UI


- (void)chooseUpload:(NSString *)params; //选择文件上传

- (void)regionPicker:(NSString *)params; //省市区选择
- (void)datePicker:(NSString *)params; //日期选择
- (void)picker:(NSString *)jsonString; //通用Picker
- (void)linkagePicker:(NSString *)jsonString; //联动picker


- (void)enterFastLook; //跳转到推送消息页(首页快看)


-(void)myFunc:(JSValue*)value;

@end

@interface LGWebPageViewController : UIViewController <JSObjcDelegate>

@property (nonatomic, strong) JSContext *jsContext;

@end
