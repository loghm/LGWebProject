//
//  FileUploader.h
//  IOSHorienMallProject
//
//  Created by iOSgo on 2017/8/25.
//  Copyright © 2017年 敲代码mac1号. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ResposeStyle) {
    JSON,
    XML,
    Data,
};

typedef NS_ENUM(NSUInteger, RequestStyle) {
    RequestJSON,
    RequestString,
    RequestDefault
};

@interface FileUploader : NSObject

/**
 上传图片
 
 @param url         接口地址
 @param parameters  参数
 @param images      图片数组
 @param name        图片匹配字段
 @param style       返回类型
 @param progress    上传进度
 @param success     成功回调
 @param failure     失败回调
 */
+ (void)upLoadFile:(NSString *)url
        parameters:(NSDictionary *)parameters
            images:(NSArray <UIImage *> *)images
              name:(NSString *)name
          response:(ResposeStyle)style
          progress:(void (^)(NSProgress *))progress
           success:(void (^)(NSURLSessionDataTask *, id))success
           failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;


/**
 上传文件
 
 @param url         接口地址
 @param parameters  参数
 @param fileData    文件
 @param name        文件匹配字段
 @param fileName    文件名
 @param mimeType    文件类型
 @param style       返回类型
 @param progress    上传进度
 @param success     成功回调
 @param failure     失败回调
 */
+ (void)upLoadFile:(NSString *)url
        parameters:(NSDictionary *)parameters
          fileData:(NSData *)fileData
              name:(NSString *)name
          fileName:(NSString *)fileName
          mimeType:(NSString *)mimeType
          response:(ResposeStyle)style
          progress:(void (^)(NSProgress *))progress
           success:(void (^)(NSURLSessionDataTask *, id))success
           failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;


+ (void)upLoadFile:(NSString *)url
        parameters:(NSDictionary *)parameters
           fileURL:(NSURL *)fileURL
              name:(NSString *)name
          fileName:(NSString *)fileName
          mimeType:(NSString *)mimeType
          response:(ResposeStyle)style
          progress:(void (^)(NSProgress *))progress
           success:(void (^)(NSURLSessionDataTask *, id))success
           failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

//
+ (NSString *)getDate:(NSString *)dateStr
                 With:(NSString *)formatStr;

@end
