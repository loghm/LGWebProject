//
//  NetworkManager.h
//  cxDemo
//
//  Created by iOSgo on 2017/9/5.
//  Copyright © 2017年 iOSgo. All rights reserved.
//

#import <Foundation/Foundation.h>

//@interface AFHTTPSessionManager (AFHttpSession)
//
//+ (instancetype)shareInstance;
//
//@end


@interface NetworkManager : NSObject

+ (instancetype)shareInstance;



/*
 * GTE请求方法
 *
 * @param url 请求地址
 * @param parameters    请求参数
 * @param success 请求成功的回调
 * @param failure  请求失败的回调
 */
- (void)requestGetWithURL:(NSString *)url
               parameters:(NSDictionary *)parameters
                  success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(void(^)(NSURLSessionDataTask *task, NSError *error, NSString *errMessage))failure;

- (void)requestNoHeadGetWithURL:(NSString *)url
                     parameters:(NSDictionary *)parameters
                        success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void(^)(NSURLSessionDataTask *task, NSError *error, NSString *errMessage))failure;

/*
 * Post请求方法
 *
 * @param url 请求地址
 * @param parameters    请求参数
 * @param success 请求成功的回调
 * @param failure  请求失败的回调
 */
- (void)requestPostWithURL:(NSString *)url
                parameters:(NSDictionary *)parameters
                   success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                   failure:(void(^)(NSURLSessionDataTask *task, NSError *error, NSString *errMessage))failure;

- (void)requestNoHeadPostWithURL:(NSString *)url
                      parameters:(NSDictionary *)parameters
                         success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void(^)(NSURLSessionDataTask *task, NSError *error, NSString *errMessage))failure;



/*
 * Put/Delete请求方法
 *
 * @param url 请求地址
 * @param parameters    请求参数
 * @param success 请求成功的回调
 * @param failure  请求失败的回调
 */
- (void)requestPutWithURL:(NSString *)url
               parameters:(NSDictionary *)parameters
                  success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                  failure:(void(^)(NSURLSessionDataTask *task, NSError *error, NSString *errMessage))failure;

- (void)requestDeleteWithURL:(NSString *)url
                  parameters:(NSDictionary *)parameters
                     success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                     failure:(void(^)(NSURLSessionDataTask *task, NSError *error, NSString *errMessage))failure;

@end
