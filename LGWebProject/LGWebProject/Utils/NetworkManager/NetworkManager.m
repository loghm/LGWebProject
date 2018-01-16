//
//  NetworkManager.m
//  cxDemo
//
//  Created by iOSgo on 2017/9/5.
//  Copyright © 2017年 iOSgo. All rights reserved.
//

#import "NetworkManager.h"

//@implementation AFHTTPSessionManager (AFHttpSession)
//
//+ (instancetype)shareInstance {
//    static AFHTTPSessionManager *manager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//
//        manager = [AFHTTPSessionManager manager];
//
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//
//        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//
//        //3.设置相应数据支持的类型
//        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"application/json", @"application/x-www-form-urlencoded", nil]];
//    });
//
//    return manager;
//}
//
//@end


@implementation NetworkManager

+ (instancetype)shareInstance {
    static NetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[NetworkManager alloc] init];
    });
    return manager;
}

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
                  failure:(void(^)(NSURLSessionDataTask *task, NSError *error, NSString *errMessage))failure {
    
    //AFHTTPSessionManager *manager = [AFHTTPSessionManager shareInstance];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"application/json", @"application/x-www-form-urlencoded", nil]];
    
    //添加manager 配置信息
    NSString *debug = [NSString stringWithFormat:@"DEBUG userId=%@", [userDef objectForKey:@"userID"]];
    if ([userDef objectForKey:@"userID"]) {
        [manager.requestSerializer setValue:debug forHTTPHeaderField:@"Authorization"];
    }
    
    [manager GET:url
      parameters:parameters
        progress:^(NSProgress * _Nonnull uploadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             success(task,responseObject);
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             [self doDataHandler:error completionHandler:^(NSError *error, NSString *errMessage) {
                 
                 failure(task,error,errMessage);
                 
             }];
             
         }];
    
}

- (void)requestNoHeadGetWithURL:(NSString *)url
                     parameters:(NSDictionary *)parameters
                        success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void(^)(NSURLSessionDataTask *task, NSError *error, NSString *errMessage))failure {
    
    //AFHTTPSessionManager *manager = [AFHTTPSessionManager shareInstance];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"application/json", @"application/x-www-form-urlencoded", nil]];
    
    [manager GET:url
      parameters:parameters
        progress:^(NSProgress * _Nonnull uploadProgress) {
            
        }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             success(task,responseObject);
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [self doDataHandler:error completionHandler:^(NSError *error, NSString *errMessage) {
                 failure(task,error,errMessage);
             }];
         }];
    
}

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
                   failure:(void(^)(NSURLSessionDataTask *task, NSError *error, NSString *errMessage))failure {
    
    //AFHTTPSessionManager *manager = [AFHTTPSessionManager shareInstance];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"application/json", @"application/x-www-form-urlencoded", nil]];
    
    //添加manager 配置信息
    NSString *debug = [NSString stringWithFormat:@"DEBUG userId=%@", [userDef objectForKey:@"userID"]];
    if ([userDef objectForKey:@"userID"]) {
        [manager.requestSerializer setValue:debug forHTTPHeaderField:@"Authorization"];
    }
    
    [manager POST:url
       parameters:parameters
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              success(task,responseObject);
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              [self doDataHandler:error completionHandler:^(NSError *error, NSString *errMessage) {
                  
                  failure(task,error,errMessage);
                  
              }];
              
          }];

    

    
}

- (void)requestNoHeadPostWithURL:(NSString *)url
                      parameters:(NSDictionary *)parameters
                         success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void(^)(NSURLSessionDataTask *task, NSError *error, NSString *errMessage))failure {
    
    //AFHTTPSessionManager *manager = [AFHTTPSessionManager shareInstance];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"application/json", @"application/x-www-form-urlencoded", nil]];
    
    [manager POST:url
       parameters:parameters
         progress:^(NSProgress * _Nonnull uploadProgress) {
             
         }
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              success(task,responseObject);
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              [self doDataHandler:error completionHandler:^(NSError *error, NSString *errMessage) {
                  
                  failure(task,error,errMessage);
                  
              }];
              
          }];
    
}



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
                  failure:(void(^)(NSURLSessionDataTask *task, NSError *error, NSString *errMessage))failure {
    
    AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
    response.removesKeysWithNullValues = YES;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //添加manager 配置信息
    NSString *debug = [NSString stringWithFormat:@"DEBUG userId=%@", [userDef objectForKey:@"userID"]];
    if ([userDef objectForKey:@"userID"]) {
        [manager.requestSerializer setValue:debug forHTTPHeaderField:@"Authorization"];
    }
    //加密
    //[manager.requestSerializer setValue:[[HelpManager shareHelpManager ] getDataWithEvent:@"PUT" WithUrl:urlStr]forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"application/json", @"application/x-www-form-urlencoded", nil]];
    
    [manager PUT:url
      parameters:parameters
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             success(task,responseObject);
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             [self doDataHandler:error completionHandler:^(NSError *error, NSString *errMessage) {
                 failure(task,error,errMessage);
             }];
             
         }];
    
}

- (void)requestDeleteWithURL:(NSString *)url
                  parameters:(NSDictionary *)parameters
                     success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                     failure:(void(^)(NSURLSessionDataTask *task, NSError *error, NSString *errMessage))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //添加manager 配置信息
    NSString *debug = [NSString stringWithFormat:@"DEBUG userId=%@", [userDef objectForKey:@"userID"]];
    if ([userDef objectForKey:@"userID"]) {
        [manager.requestSerializer setValue:debug forHTTPHeaderField:@"Authorization"];
    } else {
//        LoginViewController *loginVC = [[LoginViewController alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//        [kWindow.rootViewController presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"application/json", @"application/x-www-form-urlencoded", nil]];
    
    [manager DELETE:url
         parameters:parameters
            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                success(task,responseObject);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [self doDataHandler:error completionHandler:^(NSError *error, NSString *errMessage) {
                    
                    failure(task,error,errMessage);
                    
                }];
                
            }];
    
}


- (void)doDataHandler:(NSError *)error
    completionHandler:(void(^)(NSError *error, NSString *errMessage))completionHandler {
    
    //数据请求失败，返回错误信息原因 error
    NSInteger errorCode = [error code];
    NSError *customerError = nil;
    switch (errorCode) {
        case -1011:
        {
            NSData *errorData = [error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"];
            NSDictionary *errDict =[NSJSONSerialization JSONObjectWithData:errorData options:0 error:nil];
            if ([errDict objectForKey:@"message"]) {
                customerError = [[NSError alloc] initWithDomain:errDict[@"message"] code:[error code]userInfo:nil];
                completionHandler(error,errDict[@"message"]);
            }else{
                customerError = [[NSError alloc] initWithDomain:error.localizedDescription code:[error code] userInfo:nil];
                completionHandler(error,@"");
            }
            
        }
            break;
        default:
        {
            NSString *dic = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            customerError = [[NSError alloc] initWithDomain:error.localizedDescription code:[error code] userInfo:nil];
            completionHandler(error,dic);
            
        }
            break;
    }
    
    
}


@end
