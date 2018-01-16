//
//  DatePicker.m
//  HybridApp
//
//  Created by iOSgo on 2017/9/8.
//  Copyright © 2017年 iOSgo. All rights reserved.
//

#import "DatePicker.h"

#define MAINSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define MAINSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define DEFAULT_HEIGHT (260)

@interface DatePicker ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIView *bottomView;


@end

@implementation DatePicker {
    
    UIControl *_overView;
    
}


+ (DatePicker *)createDatePicker {
    
    DatePicker *datePicker = [[[NSBundle mainBundle] loadNibNamed:@"DatePicker" owner:nil options:nil] lastObject];
    
    [datePicker setup];
    
    return datePicker;
    
}

- (void)setup {
    
    self.frame=CGRectMake(0, MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH, DEFAULT_HEIGHT);
    self.backgroundColor = [UIColor whiteColor];
    
    _overView=[[UIControl alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _overView.backgroundColor=[UIColor colorWithWhite:0.6 alpha:0.3];
    
    [_overView addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];

    
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



- (IBAction)dissmissBtnAction:(id)sender {
    
    [self remove];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
}

- (IBAction)comfirmBtnAction:(id)sender {
    
    [self remove];
    if (self.dateBlock) {
        self.dateBlock(self.datePicker.date);
    }
    
}

@end
