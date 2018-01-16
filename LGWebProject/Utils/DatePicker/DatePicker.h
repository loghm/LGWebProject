//
//  DatePicker.h
//  HybridApp
//
//  Created by iOSgo on 2017/9/8.
//  Copyright © 2017年 iOSgo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePicker : UIView

@property (nonatomic, copy) void(^dateBlock)(NSDate *date);

@property (nonatomic, copy) void(^cancelBlock)();


+ (DatePicker *)createDatePicker;

- (void)show;

@end
