//
//  DownLoadFileManager.m
//  YunStone
//
//  Created by iOSgo on 2017/9/5.
//  Copyright © 2017年 iOSgo. All rights reserved.
//

#import "DownLoadFileManager.h"

@implementation DownLoadFileManager


+ (instancetype)getInstance
{
    static DownLoadFileManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DownLoadFileManager alloc]init];
    });
    return manager;
}


/**
 *  AFN3.0 下载
 */
- (void)downloadFileWithOption:(NSDictionary *)paramDic
                   withFileUrl:(NSString*)requestURL
                      fileName:(NSString *)fileName
                   fileCreated:(UInt32)created
               downloadSuccess:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))success
                      progress:(void (^)(NSProgress *downloadProgress))progress{
    
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.确定请求的URL地址
    NSURL *url = [NSURL URLWithString:requestURL];
    
    //3.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //下载任务
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //打印下下载进度
        NSLog(@"%lf",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        progress(downloadProgress);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //- block的返回值, 要求返回一个URL, 返回的这个URL就是文件的位置的路径
        
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        
        //再次之前先删除本地文件夹里面相同的文件夹
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *contents = [fileManager contentsOfDirectoryAtPath:cachesPath error:NULL];
        NSEnumerator *e = [contents objectEnumerator];
        NSString *filename;
        NSString *extension = @"zip";
        while ((filename = [e nextObject])) {
            
            if ([[filename pathExtension] isEqualToString:extension]) {
                
                [fileManager removeItemAtPath:[cachesPath stringByAppendingPathComponent:filename] error:NULL];
            }
        }
        NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:path];
        
        /*
        //下载地址
        NSLog(@"默认下载地址:%@",targetPath);
        
        //设置下载路径，通过沙盒获取缓存地址，最后返回NSURL对象
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        return [NSURL fileURLWithPath:filePath];
        */
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        success(response,filePath,error);
        
        //下载完成调用的方法
        NSLog(@"下载完成：");
        NSLog(@"%@--%@",response,filePath);
        
    }];
    
    //开始启动任务
    [task resume];
    
}



@end
