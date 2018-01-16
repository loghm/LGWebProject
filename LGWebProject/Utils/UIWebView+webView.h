//
//  UIWebView+webView.h
//  HybridApp
//
//  Created by iOSgo on 2017/9/27.
//  Copyright © 2017年 iOSgo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface UIWebView (webView)

//将此webview的UI设置为简书风格（和VC分离，此处可单独设置不同风格的UI）
- (void)setup;
//获取当前页面的title
- (NSString *)getPageTitle;
//页面滑动到评论区域
- (void)scrollToCommentField;
//获取脚本对象
- (JSContext *)getjavaScriptContext;
//获取Host(域名)
- (NSString *)getURLHost;
//获取链接
- (NSString *)getURLString;
//获取userAgent
- (NSString *)getUserAgent;
//禁用webView手势
- (void)webkitUserSelect;
@end
