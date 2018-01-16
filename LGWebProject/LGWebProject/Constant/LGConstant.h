//
//  LGConstant.h
//  LGWebProject
//
//  Created by loghm on 2018/1/15.
//  Copyright © 2018年 loghm. All rights reserved.
//

#ifndef LGConstant_h
#define LGConstant_h


#define BASE_URL @"http://server.haiyi.xmappservice.com"
#define INDEX_URL @"http://haiyi.xmappservice.com/#/index"

#pragma mark - ThirdPart

//第三方key等
#define Alipay [NSString stringWithFormat:@"%@app/alipay/", BASE_URL]
//微信支付
#define WXpay [NSString stringWithFormat:@"%@app/wxpay/", BASE_URL]
//友盟AppKey
#define USHARE_APPKEY @"59c4a631c8957659c2000046"
//极光推送AppKey
#define JPUSH_APPKEY @"8b602a32b5fb6cb3f5a4a732"
#define JpushChannel @"App Store"
#define JpushProduction @"0" //0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用
//环信SDK
#define EASEUIAppKey @"1156170510115784#gjb"

#pragma mark - color

//全局方法,变量
#define kCOLOR_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]



#pragma mark - 缓存

#define userDef [NSUserDefaults standardUserDefaults]

#pragma mark - key

#define USER_INFO @"userInfo"
#define USER_ACCOUNT @"userAccount"
#define USER_ISLOGINED @"userIsLogined"


#endif /* LGConstant_h */
