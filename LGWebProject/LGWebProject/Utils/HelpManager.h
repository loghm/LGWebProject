//
//  HelpManager.h
//  AHXRingApp
//
//  Created by 敲代码mac1号 on 16/8/16.
//  Copyright © 2016年 敲代码mac1号. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <Accelerate/Accelerate.h>

@interface HelpManager : NSObject

@property (nonatomic , strong) NSMutableArray *teamClassArray;

+ (HelpManager *)shareFMDBHelper;



+ (NSString *)md5HexDigest:(NSString *)url;

+ (void)changeBtnNOenabled:(UIButton *)sender;

+ (void)changeBtnenabled:(UIButton *)sender;

//判断是否有特殊字符
+ (BOOL)isHaveIllegalChar:(NSString *)str;

//判断是否有中文
+ (BOOL)IsChinese:(NSString *)str;

//获取时间差(当前, 几分钟前, 几小时前)
+(NSString*)stringFromDateString:(NSString*)date;

//按比例缩小图片
+ (UIImage *)scaleImage:(UIImage *)img toScale:(CGFloat )scale;

+ (UIColor *)colorWithRGBHex:(UInt32)hex;


+ (UIImage *)createImageWithColor:(UIColor *)color;


//上传图片
+ (void)postRequestWithUrl:(NSString *)url params:(NSDictionary *)params file:(NSArray *)file name:(NSString *)name success:(void(^)(id json))success failure:(void(^)(NSError *error))failure;


+ (NSString *) getDate :(NSString *)dateStr;


+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

//判断是否开启通讯录
+(void)CheckAddressBookAuthorization:(void (^)(bool isAuthorized))block;

+ (void)clispView:(UIView *)custView With:(float)cornerRadius;



//时间格式
+ (NSString *)getDate:(NSString *)dateStr With:(NSString *)formatStr ;

//中文
+ (BOOL) deptNameInputShouldChinese:(NSString *)text;

//判断全数字：

+ (BOOL) deptNumInputShouldNumber:(NSString *)text;

//判断全字母：

+ (BOOL) deptPassInputShouldAlpha:(NSString *)text;

//判断仅输入字母或数字：

+ (BOOL) deptIdInputShouldAlphaNum:(NSString *)text;


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString;
+ (NSString*)arrayToJson:(NSArray *)ary;


@end
