//
//  SWScrollNumLabel.m
//  SWScrollNumLabel
//
//  Created by Snail on 2018/5/17.
//  Copyright © 2018年 Snail. All rights reserved.
//

#import "SWScrollNumLabel.h"
static const NSUInteger numberCellLineCount = 20;
static NSString * const numberCellText = @"0\n1\n2\n3\n4\n5\n6\n7\n8\n9\n0\n1\n2\n3\n4\n5\n6\n7\n8\n9";

@interface SWScrollNumLabel ()

@property (nonatomic, strong) NSMutableArray *cellArray;    // 位数Label数组
@property (nonatomic, assign) CGSize cellSize;              // 各位Label视图大小
@property (nonatomic, assign) CGFloat labelHeight;          // 视图高度

@end


@implementation SWScrollNumLabel{
    NSString *_oldNumText;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _font = [UIFont systemFontOfSize:17];
        _textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        [self initCells];
    }
    return self;
}

- (instancetype)initWithFont:(UIFont *)font textColor:(UIColor *)color {
    self = [super init];
    if (self) {
        _font = font;
        _textColor = color;
        self.clipsToBounds = YES;
        [self initCells];
    }
    return self;
}

- (NSMutableArray *)cellArray {
    if (_cellArray == nil) {
        _cellArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _cellArray;
}


- (void)setFont:(UIFont *)font {
    if (_font != font) {
        _font = font;
        CGRect rect = [numberCellText boundingRectWithSize:CGSizeZero
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:font}
                                                   context:nil];
        self.cellSize = rect.size;
        self.labelHeight = self.cellSize.height /numberCellLineCount;
        if (_oldNumText) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.cellSize.width *_oldNumText.length, self.labelHeight);
            for (NSInteger i = 0; i < _oldNumText.length; i++) {
                UILabel *numberCell = [self numberCellWithIndex:i];
                NSInteger num = [[_oldNumText substringWithRange:NSMakeRange((_oldNumText.length -1) -i, 1)] integerValue];
                CGFloat originX = ((_oldNumText.length -1) -i) *self.cellSize.width;
                numberCell.frame = CGRectMake(originX, -num*self.labelHeight, self.cellSize.width, self.cellSize.height);
                
            }
        }
    }
}
- (void)setTextColor:(UIColor *)textColor {
    if (_textColor !=textColor) {
        _textColor = textColor;
        if (_oldNumText) {
            for (NSInteger i = 0; i < _oldNumText.length; i++) {
                UILabel *numberCell = [self numberCellWithIndex:i];
                numberCell.textColor = textColor;
            }
        }
    }
}

- (void)initCells {
    CGRect rect = [numberCellText boundingRectWithSize:CGSizeZero
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:_font}
                                               context:nil];
    self.cellSize = rect.size;
    self.labelHeight = self.cellSize.height /numberCellLineCount;
    _oldNumText = @"";
    [self setNumText:@"" animation:NO];
}



- (void)setNumText:(NSString *)numText animation:(BOOL)animation {
    if ([numText isEqualToString:_oldNumText]) {
        return;
    }
    NSString *_numText = numText;
    while (_numText.length<_oldNumText.length) {
        _numText = [_numText stringByReplacingCharactersInRange:NSMakeRange(0, 0) withString:@"0"];
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.cellSize.width *numText.length, self.labelHeight);
    BOOL isTuiWei = YES;
    BOOL isLongWei = YES;
    for (NSInteger i = 0; i < _numText.length; i++) {
        
        NSInteger num = [[_numText substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger oldNum = 0;
        if (i >=_numText.length - _oldNumText.length) {
            oldNum = [[_oldNumText substringWithRange:NSMakeRange(i -(_numText.length - _oldNumText.length), 1)] integerValue];
        }
        
        CGFloat originX = i *self.cellSize.width;
        UILabel *numberCell = [self numberCellWithIndex:i];
        if (num == 0 && isTuiWei == YES) {
            if (i < _numText.length -1) {
                originX = -self.cellSize.width;
            }
        } else {
            isTuiWei = NO;
        }
        if (num == oldNum && isLongWei == YES) {
            
        } else {
            isLongWei = NO;
        }
        if (animation) {
            [UIView animateWithDuration:sqrt(1.0 +i)*0.3 animations:^{
                numberCell.frame = CGRectMake(originX, -(num<=oldNum&&isLongWei == NO?num+10:num)*self.labelHeight, self.cellSize.width, self.cellSize.height);
            } completion:^(BOOL finished) {
                numberCell.frame = CGRectMake(originX, -num*self.labelHeight, self.cellSize.width, self.cellSize.height);
            }];
        } else {
            numberCell.frame = CGRectMake(originX, -num*self.labelHeight, self.cellSize.width, self.cellSize.height);
        }
        
    }
    for (NSInteger i=numText.length; i< self.cellArray.count; ) {
        UILabel *label = [self.cellArray objectAtIndex:i];
        [label removeFromSuperview];
        [self.cellArray removeObject:label];
    }
    _oldNumText= numText;
}



- (UILabel *)numberCellWithIndex:(NSInteger)index {
    UILabel *cell;
    if (index< self.cellArray.count) {
        cell = (UILabel *)[self.cellArray objectAtIndex:index];
    } else {
        cell = [[UILabel alloc] init];
        cell.numberOfLines = numberCellLineCount;
        cell.text = numberCellText;
        cell.frame = CGRectMake(0, 0, self.cellSize.width, self.cellSize.height);
        [self addSubview:cell];
        [self.cellArray addObject:cell];
    }
    cell.font = _font;
    cell.textColor = _textColor;
    cell.tag = 100 +index;
    return cell;
}

// 数字字符串加上一个数值
- (void)addCount:(NSInteger)count {
    NSString *number = _oldNumText;
    NSInteger carry = count;
    for (int i=0; carry != 0; i++) {
        NSInteger num = 0;
        NSString *numStr = @"0";
        if (i <number.length) {
            num = [[number substringWithRange:NSMakeRange(number.length -1 -i, 1)] integerValue];
            numStr = [NSString stringWithFormat:@"%ld",(num +carry) %10];
            number = [number stringByReplacingCharactersInRange:NSMakeRange(number.length -1 -i, 1) withString:numStr];
        } else {
            numStr = [NSString stringWithFormat:@"%ld",(num +carry) %10];
            number = [number stringByReplacingCharactersInRange:NSMakeRange(0, 0) withString:numStr];
        }
        
        carry = (num +carry) /10;
    }
    [self setNumText:number animation:YES];
}



@end
