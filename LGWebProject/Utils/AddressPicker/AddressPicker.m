//
//  AddressPicker.m
//  jiajuO2O
//
//  Created by iOSgo on 2017/9/1.
//  Copyright © 2017年 JfChen. All rights reserved.
//

#import "AddressPicker.h"


#define heightPicker 230

@interface AddressPicker ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) NSDictionary *pickerDic;

@property (strong, nonatomic) NSMutableArray *selectedArray;
@property (strong, nonatomic) NSMutableArray *provinceArray;
@property (strong, nonatomic) NSMutableArray *cityArray;
@property (strong, nonatomic) NSMutableArray *townArray;

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIView *overView;

@end

@implementation AddressPicker {
    NSInteger _row ;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        
        _selectedArray = [NSMutableArray array];
        _provinceArray = [NSMutableArray array];
        _cityArray = [NSMutableArray array];
        _townArray = [NSMutableArray array];
        
        [self getAddressInformation];
        [self setBaseView];
        
        // 2.设置自身的属性
        self.userInteractionEnabled = YES;
        self.bounds = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:102.0/255];
        self.layer.opacity = 0.0;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(remove)]];
        
        
    }
    return self;
}

- (void)getAddressInformation {
    
    //读取本地的文件
    NSData *JSONData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"region_data" ofType:@"json"]];
    
    self.pickerArray = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    
    [self.pickerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NSDictionary *dict = obj;
        [self.provinceArray addObject:dict[@"label"]];
        
    }];
    
    self.selectedArray = [self.pickerArray objectAtIndex:0][@"children"];
    
    
    if (self.selectedArray.count > 0) {
        
        [self.selectedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = obj;
            [self.cityArray addObject:dict[@"label"]];
        }];
        
    }
    
    [[self.selectedArray objectAtIndex:0][@"children"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NSDictionary *dict = obj;
        [self.townArray addObject:dict[@"label"]];
        
    }];
    
    
    
    

    
}

- (void)setBaseView {
    
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIColor *color = [UIColor whiteColor];
    UIColor *btnColor = kCOLOR_HEX(0x25D484);
    
    [self addSubview:self.contentView];
    
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    selectView.backgroundColor = color;
    
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"取消" forState:0];
    [cancleBtn setTitleColor:btnColor forState:0];
    cancleBtn.frame = CGRectMake(0, 0, 60, 40);
    [cancleBtn addTarget:self action:@selector(dateCancleAction) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:cancleBtn];
    
    UIButton *ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ensureBtn setTitle:@"确定" forState:0];
    [ensureBtn setTitleColor:btnColor forState:0];
    ensureBtn.frame = CGRectMake(width - 60, 0, 60, 40);
    [ensureBtn addTarget:self action:@selector(dateEnsureAction) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:ensureBtn];
    [self.contentView addSubview:selectView];
    
    
    self.pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30 , width,  heightPicker)];
    self.pickView.delegate   = self;
    self.pickView.dataSource = self;
    self.pickView.backgroundColor = color;
    [self.contentView addSubview:self.pickView];
    [self.pickView reloadAllComponents];
    
    [self updateAddress];
    
    
    
}

- (void)setSourceDict:(NSDictionary *)sourceDict {
    
    _sourceDict = sourceDict;
    [self defaultSelectAddress];
    
}

- (void)defaultSelectAddress {
    
    
    [self.provinceArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj isEqualToString:_sourceDict[@"province"][@"label"]]) {
            
            [self.pickView reloadComponent:0];
            [self.pickView selectRow:idx inComponent:0 animated:YES];
            
        }
        
    }];
    
    [self.cityArray removeAllObjects];
    
    self.selectedArray = [self.pickerArray objectAtIndex:[self.pickView selectedRowInComponent:0]][@"children"];
    if (self.selectedArray.count > 0) {
        [self.selectedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = obj;
            [self.cityArray addObject:dict[@"label"]];
        }];
    } else {
        self.cityArray = [NSMutableArray arrayWithArray:@[]];
    }
    
    [self.cityArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isEqualToString:_sourceDict[@"city"][@"label"]]) {
            
            [self.pickView reloadComponent:1];
            [self.pickView selectRow:idx inComponent:1 animated:YES];
            
        }
        
    }];
    
    [self.townArray removeAllObjects];
    
    if (self.cityArray.count > 0) {
        
        [[self.selectedArray objectAtIndex:[self.pickView selectedRowInComponent:1]][@"children"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *dict = obj;
            [self.townArray addObject:dict[@"label"]];
            
        }];
        
    } else {
        self.townArray = [NSMutableArray arrayWithArray:@[]];
    }
    
    [self.townArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isEqualToString:_sourceDict[@"district"][@"label"]]) {
            
            [self.pickView reloadComponent:2];
            [self.pickView selectRow:idx inComponent:2 animated:YES];
            
            
        }
        
    }];
    
    
    
    [self updateAddress];
}


- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self setCenter:[UIApplication sharedApplication].keyWindow.center];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];
    
    CGRect frameContent =  self.contentView.frame;
    frameContent.origin.y -= self.contentView.frame.size.height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.layer setOpacity:1.0];
        self.contentView.frame = frameContent;
    } completion:^(BOOL finished) {
    }];
    
}

- (void)remove
{
    CGRect frameContent =  self.contentView.frame;
    frameContent.origin.y += self.contentView.frame.size.height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.layer setOpacity:0.0];
        self.contentView.frame = frameContent;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



//- (void)updateAddressAtProvince:(NSString *)province city:(NSString *)city town:(NSString *)town {
//    self.province = province;
//    self.city = city;
//    self.area = town;
//    if (self.province) {
//        for (NSInteger i = 0; i < self.provinceArray.count; i++) {
//            NSString *city = self.provinceArray[i];
//            NSInteger select = 0;
//            if ([city isEqualToString:self.province]) {
//                select = i;
//                [self.pickView selectRow:i inComponent:0 animated:YES];
//                break;
//            }
//        }
//        self.cityArray = [self.pickerDic[self.province][0] allKeys];
//        for (NSInteger i = 0; i < self.cityArray.count; i++) {
//            NSString *city = self.cityArray[i];
//            if ([city isEqualToString:self.city]) {
//                [self.pickView selectRow:i inComponent:1 animated:YES];
//                break;
//            }
//        }
//        self.townArray = self.pickerDic[self.province][0][self.city];
//        for (NSInteger i = 0; i < self.townArray.count; i++) {
//            NSString *town = self.townArray[i];
//            if ([town isEqualToString:self.area]) {
//                [self.pickView selectRow:i inComponent:2 animated:YES];
//                break;
//            }
//        }
//    }
//    [self.pickView reloadAllComponents];
//    [self updateAddress];
//}

- (void)dateCancleAction {
    
    [self remove];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AddressPickerCancleAction)]) {
        [self.delegate AddressPickerCancleAction];
    }
}

- (void)dateEnsureAction {
    
    [self remove];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(AddressPicker:Province:city:area:)]) {
        [self.delegate AddressPicker:self Province:self.province city:self.city area:self.area];
    }
    
    if (self.addressBlock) {
        self.addressBlock(self, self.province, self.city, self.area);
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:self.font?:[UIFont boldSystemFontOfSize:14]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceArray.count;
    } else if (component == 1) {
        return self.cityArray.count;
    } else {
        return self.townArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [self.cityArray objectAtIndex:row];
    } else {
        return [self.townArray objectAtIndex:row];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.frame.size.width / 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {
        [self.cityArray removeAllObjects];
        [self.townArray removeAllObjects];
        
        self.selectedArray = [self.pickerArray objectAtIndex:row][@"children"];
        if (self.selectedArray.count > 0) {
            [self.selectedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dict = obj;
                [self.cityArray addObject:dict[@"label"]];
            }];
        } else {
            self.cityArray = [NSMutableArray arrayWithArray:@[]];
        }
        if (self.cityArray.count > 0) {
            
            [[self.selectedArray objectAtIndex:0][@"children"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSDictionary *dict = obj;
                [self.townArray addObject:dict[@"label"]];
                
            }];
            
        } else {
            self.townArray = [NSMutableArray arrayWithArray:@[]];
        }
        [pickerView reloadComponent:1];
        [pickerView selectedRowInComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectedRowInComponent:2];
    }
    if (component == 1) {
        
        [self.cityArray removeAllObjects];
        [self.townArray removeAllObjects];
        
        self.selectedArray = [self.pickerArray objectAtIndex:[self.pickView selectedRowInComponent:0]][@"children"];
    
        if (self.selectedArray.count > 0) {
            [self.selectedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dict = obj;
                [self.cityArray addObject:dict[@"label"]];
            }];
        } else {
            self.cityArray = [NSMutableArray arrayWithArray:@[]];
        }
        
        if (self.cityArray.count > 0) {
            
            [[self.selectedArray objectAtIndex:[self.pickView selectedRowInComponent:1]][@"children"]  enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSDictionary *dict = obj;
                [self.townArray addObject:dict[@"label"]];
                
            }];
            
        } else {
            self.townArray = [NSMutableArray arrayWithArray:@[]];
        }
        [pickerView reloadComponent:2];
        [pickerView selectedRowInComponent:2];
    }
    if (component == 2) {
        [pickerView reloadComponent:2];
        [pickerView selectedRowInComponent:2];
    }
    [self updateAddress];
}

- (void)updateAddress {
    
    self.province = [self.provinceArray objectAtIndex:[self.pickView selectedRowInComponent:0]];
    self.city  = [self.cityArray objectAtIndex:[self.pickView selectedRowInComponent:1]];
    self.area  = [self.townArray objectAtIndex:[self.pickView selectedRowInComponent:2]];
}


- (UIView *)contentView
{
    if (!_contentView) {
        CGFloat contentX = 0;
        CGFloat contentY = [UIScreen mainScreen].bounds.size.height;
        CGFloat contentW = [UIScreen mainScreen].bounds.size.width;
        CGFloat contentH = heightPicker+30;
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(contentX, contentY, contentW, contentH)];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
    }
    return _contentView;
}

@end
