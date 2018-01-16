//
//  CommonPicker.m
//  HybridApp
//
//  Created by iOSgo on 2017/9/14.
//  Copyright © 2017年 iOSgo. All rights reserved.
//

#import "CommonPicker.h"

#define MAINSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define MAINSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define DEFAULT_HEIGHT (260)

@interface CommonPicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic , copy) NSMutableArray<NSArray *> *contentAry;

@property (nonatomic , copy) NSString *contentStr;

@property (nonatomic , copy) NSMutableArray *resultAry;


@end

@implementation CommonPicker {
    
    UIControl *_overView;
    NSInteger _component;
    
}


+ (CommonPicker *)createCommonPicker:(NSArray *)dataAry {
    
    CommonPicker *commonPicker = [[[NSBundle mainBundle] loadNibNamed:@"CommonPicker" owner:nil options:nil] lastObject];
    
    [commonPicker setup];
    
    [commonPicker setupDatas:dataAry];
    
    return commonPicker;
    
}


- (void)setup {
    
    self.frame=CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, DEFAULT_HEIGHT);
    self.backgroundColor = [UIColor whiteColor];
    
    _overView=[[UIControl alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _overView.backgroundColor=[UIColor colorWithWhite:0.6 alpha:0.3];
    
    [_overView addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    
    
}

//首次获取数据
- (void)setupDatas:(NSArray *)dataAry {
    
    _component = dataAry.count;
    
    _contentAry = [NSMutableArray array];
    
    [dataAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NSMutableArray *items = [NSMutableArray array];
        NSArray *itemAry = obj;
        [itemAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *itemDict = obj;
            [items addObject:itemDict[@"name"]];
        }];
        
        [self.contentAry addObject:items];
        
    }];
    
    [self confirmContentPicker];
    
    
}


- (void)show
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:_overView];
    [keyWindow addSubview:self];
    
    CGRect frameContent =  self.frame;
    frameContent.origin.y -= self.frame.size.height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.layer setOpacity:1.0];
        self.frame = frameContent;
    } completion:^(BOOL finished) {
    }];
    
}

- (void)remove
{
    CGRect frameContent =  self.frame;
    frameContent.origin.y += self.frame.size.height;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.layer setOpacity:0.0];
        self.frame = frameContent;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_overView removeFromSuperview];
    }];
}




- (IBAction)dissMissBtnAction:(id)sender {
    
    [self remove];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
    
}
- (IBAction)confirmBtnAction:(id)sender {
    
    [self remove];
    if (self.confirmBlock) {
        self.confirmBlock(self.contentStr);
    }
    
}


#pragma mark - picker delegate/dataSource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.contentAry[component].count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _component;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return self.frame.size.width / _component;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.contentAry[component] objectAtIndex:row];
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
 
    [self confirmContentPicker];
    
}


- (void)confirmContentPicker {
    
    self.contentStr = nil;
    for (int i= 0; i<_component; i++) {
        if (self.contentStr) {
            self.contentStr = [NSString stringWithFormat:@"%@ %@",self.contentStr,[self.contentAry[i] objectAtIndex:[self.pickerView selectedRowInComponent:i]]];
        } else {
            self.contentStr = [self.contentAry[i] objectAtIndex:[self.pickerView selectedRowInComponent:i]];
        }
    }
    
    //self.contentLabel.text = self.contentStr;
    
}

@end
