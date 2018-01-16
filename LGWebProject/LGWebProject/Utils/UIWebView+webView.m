//
//  UIWebView+webView.m
//  HybridApp
//
//  Created by iOSgo on 2017/9/27.
//  Copyright © 2017年 iOSgo. All rights reserved.
//

#import "UIWebView+webView.h"

@implementation UIWebView (webView)

- (void)setup
{
    //设置webView背景颜色
    self.backgroundColor = [UIColor whiteColor];
    //上下固定(bounces past edge of content and back again)
    self.scrollView.bounces = NO;
    //默认值为NO，用户不可以放大或缩小页面；如果设置为YES，页面可以通过放大缩小去适应，用户也可以通过手势来放大和缩小
    self.scalesPageToFit = YES;
    //默认使NO。这个值决定了用内嵌HTML5播放视频还是用本地的全屏控制。
    //为了内嵌视频播放，不仅仅需要在这个页面上设置这个属性，还必须的是在HTML中的video元素必须包含webkit-playsinline属性。
    self.allowsInlineMediaPlayback = YES;
    //在iPhone和iPad上默认使YES。这个值决定了HTML5视频可以自动播放还是需要用户去启动播放
    self.mediaPlaybackRequiresUserAction = YES;
    
}

- (NSString *)getPageTitle
{
    return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (void)scrollToCommentField
{
    [self stringByEvaluatingJavaScriptFromString:@"scrollTo(0,20500)"];
}

- (JSContext *)getjavaScriptContext
{
    return [self valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
}

- (NSString *)getURLHost
{
    return self.request.URL.host;
}

- (NSString *)getURLString
{
    return [self stringByEvaluatingJavaScriptFromString:@"document.location.href"];
}

- (NSString *)getUserAgent
{
    return [self stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
}


- (void)webkitUserSelect
{
    [self stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

@end
