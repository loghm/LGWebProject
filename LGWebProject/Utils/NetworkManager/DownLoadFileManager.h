//
//  DownLoadFileManager.h
//  YunStone
//
//  Created by iOSgo on 2017/9/5.
//  Copyright © 2017年 iOSgo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownLoadFileManager : NSObject


+ (instancetype)getInstance;



/**
 *  根据url判断是否已经保存到本地了
 *
 *  @param created 文件的创建时间  通过和fileName拼接成完整的文件路径
 *
 *  @param fileName 文件的名字
 *
 *  @return YES：本地已经存在，NO：本地不存在
 */
- (BOOL)isSavedFileToLocalWithCreated:(UInt32)created fileName:(NSString *)fileName;



/**
 *  根据文件的创建时间 设置保存到本地的路径
 *
 *  @param created  创建时间
 *  @param fileName 名字
 *
 *  @return 文件路径
 */
-(NSString *)setPathOfDocumentsByFileCreated:(UInt32)created fileName:(NSString *)fileName;



/**
 *  根据文件类型、名字、创建时间获得本地文件的路径，当文件不存在时，返回nil
 *
 *  @param fileName 文件名字
 *  @param created  文件在服务器创建的时间
 *
 *  @return 本地文件的路径
 */
- (NSURL *)getLocalFilePathWithFileName:(NSString *)fileName fileCreated:(UInt32)created;


- (void)downloadFileWithOption:(NSDictionary *)paramDic
                   withFileUrl:(NSString*)requestURL
                      fileName:(NSString *)fileName
                   fileCreated:(UInt32)created
               downloadSuccess:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))success
                      progress:(void (^)(NSProgress *downloadProgress))progress;


/**
 *  取消下载，并删除本地已经下载了的部分
 *
 *  @param created  文件在服务器创建的时间
 *  @param fileName 文件的名字
 */
- (void)cancleDownLoadFileWithServiceCreated:(UInt32)created fileName:(NSString *)fileName;

/**
 *  正在下载中
 *
 *
 */
- (BOOL)isDownLoadExecuting;

/**
 *  下载暂停
 */
- (void)downLoadPause;

/**
 *  下载继续
 */
- (void)downLoadResume;

@end
