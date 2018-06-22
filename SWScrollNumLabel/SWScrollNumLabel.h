//
//  SWScrollNumLabel.h
//  SWScrollNumLabel
//
//  Created by Snail on 2018/5/17.
//  Copyright © 2018年 Snail. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWScrollNumLabel : UIView

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
- (instancetype)initWithFont:(UIFont *)font textColor:(UIColor *)color;
// 设置numText
- (void)setNumText:(NSString *)numText animation:(BOOL)animation;
// 加count
- (void)addCount:(NSInteger)count;

@end
