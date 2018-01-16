//
//  AudioViewController.h
//  IOSHorienMallProject
//
//  Created by iOSgo on 2017/8/23.
//  Copyright © 2017年 敲代码mac1号. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioViewController : UIViewController

@property (nonatomic , copy) void(^getFilepath) (NSString *filePath);


@end
