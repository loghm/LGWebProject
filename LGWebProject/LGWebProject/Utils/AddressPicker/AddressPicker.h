//
//  AddressPicker.h
//  jiajuO2O
//
//  Created by iOSgo on 2017/9/1.
//  Copyright © 2017年 JfChen. All rights reserved.
//


#import <UIKit/UIKit.h>
@class AddressPicker;
@protocol AddressPickerDelegate <NSObject>
@optional
/** 代理方法返回省市区*/
- (void)AddressPicker:(AddressPicker *)picker
             Province:(NSString *)province
                 city:(NSString *)city
                 area:(NSString *)area;
/** 取消代理方法*/
- (void)AddressPickerCancleAction;
@end
@interface AddressPicker : UIView

@property (strong, nonatomic) NSArray *pickerArray;
@property (strong, nonatomic) UIPickerView *pickView;

@property (strong, nonatomic) NSDictionary *sourceDict;

/** 省 */
@property (nonatomic, strong) NSString *province;
/** 市 */
@property (nonatomic, strong) NSString *city;
/** 区 */
@property (nonatomic, strong) NSString *area;
@property (nonatomic, weak) id<AddressPickerDelegate> delegate;

//block
@property (nonatomic, copy) void(^addressBlock) (AddressPicker *picker,NSString *province,NSString *city,NSString *area);
//- (void)updateAddressAtProvince:(NSString *)province city:(NSString *)city town:(NSString *)town;
/** 内容字体 */
@property (nonatomic, strong) UIFont *font;

- (void)show;
- (void)remove;

@end
