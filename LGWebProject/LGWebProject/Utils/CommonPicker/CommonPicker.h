//
//  CommonPicker.h
//  HybridApp
//
//  Created by iOSgo on 2017/9/14.
//  Copyright © 2017年 iOSgo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonPicker : UIView

/** 内容字体 */
@property (nonatomic, strong) UIFont *font;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (nonatomic, copy) void(^confirmBlock) (NSString *content);

@property (nonatomic, copy) void(^cancelBlock) ();

+ (CommonPicker *)createCommonPicker:(NSArray *)dataAry;

- (void)show;

- (void)remove;

@end
