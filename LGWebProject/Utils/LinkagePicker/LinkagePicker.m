//
//  CommonPicker.m
//  HybridApp
//
//  Created by iOSgo on 2017/9/14.
//  Copyright © 2017年 iOSgo. All rights reserved.
//

#import "LinkagePicker.h"

#define MAINSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define MAINSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define DEFAULT_HEIGHT (260)

@interface LinkagePicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic , copy) NSMutableArray *dataAry;//原始数据

@property (nonatomic , strong) NSMutableArray<NSArray *> *contentAry;//内容数组即每个Component的二维数组

@property (nonatomic , copy) NSString *contentStr; //结果返回字符串 中间用空格拼接

@property (nonatomic , copy) NSMutableArray *selectRowAry; //选中picker(component row),元素为字符串

@property (nonatomic , copy) NSMutableArray *resultAry; //结果返回数组



@end

@implementation LinkagePicker {
    
    UIControl *_overView;
    NSInteger _component;
    BOOL _isHave;
    NSInteger _currentIndex;
    NSArray *_childrenAry ;
}


+ (LinkagePicker *)createLinkagePicker:(NSArray *)dataAry{
    
    LinkagePicker *linkagePicker = [[[NSBundle mainBundle] loadNibNamed:@"LinkagePicker" owner:nil options:nil] lastObject];
    
    [linkagePicker setup];
    
    [linkagePicker setupDatas:dataAry];
    
    return linkagePicker;
    
}


- (void)setup {
    
    self.frame=CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, DEFAULT_HEIGHT);
    self.backgroundColor = [UIColor whiteColor];
    
    _overView=[[UIControl alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _overView.backgroundColor=[UIColor colorWithWhite:0.6 alpha:0.3];
    
    [_overView addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)setupDatas:(NSArray *)dataAry {
    
    self.dataAry = dataAry;
    _component = 0;
    
    _contentAry = [NSMutableArray array];
    _selectRowAry = [NSMutableArray array];
    
    [self recursion:dataAry];
    

    [self.pickerView reloadAllComponents];
    
    [self confirmContentPicker];
    
    
}

//递归(首次)获取数据
- (void)recursion:(NSArray *)dataAry {
    
    NSMutableArray *firstAry = [NSMutableArray array];
    
    [dataAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [firstAry addObject:obj[@"name"]];
        
    }];
    
    [self.contentAry addObject:firstAry];
    
    _component++;
    
    NSArray *childrenAry = [dataAry firstObject][@"children"];
    
    if (childrenAry.count > 0) {
        [self recursion:childrenAry];
    }
    
    
}

//递归刷新row获取数据
- (void)reloadRecursion:(NSArray *)dataAry {
    
    NSMutableArray *firstAry = [NSMutableArray array];
    
    [dataAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [firstAry addObject:obj[@"name"]];
        
    }];
    
    [self.contentAry addObject:firstAry];
    
    
    [_selectRowAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NSArray *tempAry = [obj componentsSeparatedByString:@" "];
        
        if ([[tempAry firstObject] integerValue] == _currentIndex) {
            _childrenAry = [NSArray arrayWithArray:[dataAry objectAtIndex:[[tempAry lastObject] integerValue]][@"children"]];
        } else {
             _childrenAry = [NSArray arrayWithArray:[dataAry firstObject][@"children"]];
        }
        
    }];
    
    _currentIndex++;
    
    if (_childrenAry.count > 0) {
        
        [self reloadRecursion:_childrenAry];
    }
    
//    [self recursion:[self.dataAry objectAtIndex:row][@"children"]];
//    
//    
//    [self recursion:[[self.dataAry firstObject][@"children"] objectAtIndex:row][@"children"]];
    
    
}

//递归选中获取数据
- (void)selectRecursion:(NSArray *)dataAry {
    
    [dataAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *temp = [_selectRowAry objectAtIndex:_currentIndex];
        NSArray *tempAry = [temp componentsSeparatedByString:@" "];
        
        NSInteger component = [[tempAry firstObject] integerValue];
        NSInteger row = [[tempAry lastObject] integerValue];
        NSLog(@"%d,%d,%d,%d",_currentIndex,component,idx,row);
        if (_currentIndex == component && idx == row) {
            [self.resultAry addObject:@{@"id":obj[@"id"],
                                  @"name":obj[@"name"]}];
        }
        
    }];
    
    NSString *temp = [_selectRowAry objectAtIndex:_currentIndex];
    NSArray *tempAry = [temp componentsSeparatedByString:@" "];
    NSInteger row = [[tempAry lastObject] integerValue];
    
    NSArray *childrenAry = [dataAry objectAtIndex:row][@"children"];
    
    _currentIndex++;
    
    if (childrenAry.count > 0) {
        
        [self selectRecursion:childrenAry];
    }
    
    
    
    
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
    
    [_selectRowAry removeAllObjects];
    for (int idx=0; idx<_component; idx++) {
        
        NSInteger selectRow = [self.pickerView selectedRowInComponent:idx];
        
        NSString *tempString = [NSString stringWithFormat:@"%d %d",idx,selectRow];
        
        [_selectRowAry addObject:tempString];

    }
    
    _currentIndex = 0;
    _resultAry = [NSMutableArray array];
    [self selectRecursion:self.dataAry];
    
    
    [self remove];
    if (self.confirmBlock) {
        self.confirmBlock(self.contentStr,self.resultAry);
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
 
    for (int i=0; i<_component; i++) {
        if (component == i) {
            
            NSString *tempString = [NSString stringWithFormat:@"%d %d",component,row];
            
            if (self.selectRowAry.count <= 0) {
                [self.selectRowAry addObject:tempString];
            } else {
                
                NSArray *tempAry = [NSArray arrayWithArray:self.selectRowAry];
                [tempAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   
                    NSString *key = [[obj componentsSeparatedByString:@" "] firstObject];
                    if ([key integerValue] == component) {
                        [self.selectRowAry removeObjectAtIndex:idx];
                        [self.selectRowAry addObject:tempString];
                    } else {
                        [self.selectRowAry addObject:tempString];
                    }
                    
                }];
                
            }
            
//            NSArray * subAry = [self.contentAry subarrayWithRange:NSMakeRange(0, i+1)];
//            
//            self.contentAry = [NSMutableArray arrayWithArray:subAry];
//            
//            //[self recursion:[self.dataAry objectAtIndex:row][@"children"]];
//            
//            
//            [self recursion:[[self.dataAry firstObject][@"children"] objectAtIndex:row][@"children"]];
            [self.contentAry removeAllObjects];
            _currentIndex = 0;
            [self reloadRecursion:self.dataAry];
            
            
        }
        
        if (i > component) {
            
            [pickerView reloadComponent:i];
            [pickerView selectedRowInComponent:i];
        }
        
        
        
    }
    
    [self confirmContentPicker];
    
}




- (void)confirmContentPicker {
    
    self.contentStr = nil;
    for (int i= 0; i<_component-1; i++) {
        if (self.contentStr) {
            self.contentStr = [NSString stringWithFormat:@"%@ %@",self.contentStr,[self.contentAry[i] objectAtIndex:[self.pickerView selectedRowInComponent:i]]];
        } else {
            self.contentStr = [self.contentAry[i] objectAtIndex:[self.pickerView selectedRowInComponent:i]];
        }
    }
    
    //self.contentLabel.text = self.contentStr;
    
}

@end
