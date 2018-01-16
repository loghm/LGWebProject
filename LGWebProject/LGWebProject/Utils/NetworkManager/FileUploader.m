//
//  FileUploader.m
//  IOSHorienMallProject
//
//  Created by iOSgo on 2017/8/25.
//  Copyright © 2017年 敲代码mac1号. All rights reserved.
//

#import "FileUploader.h"

@implementation FileUploader


+ (void)upLoadFile:(NSString *)url
        parameters:(NSDictionary *)parameters
            images:(NSArray <UIImage *> *)images
              name:(NSString *)name
          response:(ResposeStyle)style
          progress:(void (^)(NSProgress *))progress
           success:(void (^)(NSURLSessionDataTask *, id))success
           failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    //1.获取单例的网络管理对象
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.根据style 的类型 去选择返回值得类型
    switch (style) {
        case JSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case XML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case Data:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        default:
            break;
    }
    
    //3.设置相应数据支持的类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"application/json", @"application/x-www-form-urlencoded", nil]];
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImage *image = obj;
            NSData *fileData = UIImagePNGRepresentation(image);
            
            NSString *fileName = [self getDate:[NSString stringWithFormat:@"%f%lu",[[NSDate date] timeIntervalSince1970],(unsigned long)idx] With:@"yyyyMMddhhMMss"];
            fileName = [fileName stringByAppendingString:@".png"];
            
            [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:@"image/jpeg"];
        }];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (uploadProgress) {
            progress(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(task, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(task, error);
        }
    }];
    
}



+ (void)upLoadFile:(NSString *)url
        parameters:(NSDictionary *)parameters
          fileData:(NSData *)fileData
              name:(NSString *)name
          fileName:(NSString *)fileName
          mimeType:(NSString *)mimeType
          response:(ResposeStyle)style
          progress:(void (^)(NSProgress *))progress
           success:(void (^)(NSURLSessionDataTask *, id))success
           failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    //1.获取单例的网络管理对象
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.根据style 的类型 去选择返回值得类型
    switch (style) {
        case JSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case XML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case Data:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        default:
            break;
    }
    
    //3.设置相应数据支持的类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"application/json", @"application/x-www-form-urlencoded", nil]];
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (uploadProgress) {
            progress(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(task, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(task, error);
        }
    }];
}


+ (void)upLoadFile:(NSString *)url
        parameters:(NSDictionary *)parameters
           fileURL:(NSURL *)fileURL
              name:(NSString *)name
          fileName:(NSString *)fileName
          mimeType:(NSString *)mimeType
          response:(ResposeStyle)style
          progress:(void (^)(NSProgress *))progress
           success:(void (^)(NSURLSessionDataTask *, id))success
           failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    //1.获取单例的网络管理对象
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.根据style 的类型 去选择返回值得类型
    switch (style) {
        case JSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case XML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case Data:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        default:
            break;
    }
    
    //3.设置相应数据支持的类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"application/json", @"application/x-www-form-urlencoded", nil]];
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *fileData = [NSData dataWithContentsOfURL:fileURL];
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (uploadProgress) {
            progress(uploadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(task, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(task, error);
        }
    }];
    
}


+ (NSString *)getDate:(NSString *)dateStr With:(NSString *)formatStr {
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[dateStr doubleValue] / 1000];
    NSDateFormatter *DATEFormatter = [[NSDateFormatter alloc] init];
    [DATEFormatter setDateFormat:formatStr];
    NSString *getdateStr = [DATEFormatter stringFromDate:confromTimesp];
    return getdateStr;
}


@end
