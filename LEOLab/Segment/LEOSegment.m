//
//  LEOSegment.m
//  LEOLab
//
//  Created by zhangliaoyuan on 2018/6/7.
//  Copyright © 2018年 zhangliaoyuan. All rights reserved.
//

#import "LEOSegment.h"

@interface LEOSegment()
@property (strong, nonatomic) UIView *indicate;
@end

@implementation LEOSegment

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.indicate];
        [self bringSubviewToFront:self.indicate];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self.indicate setFrame:CGRectMake(frame.size.width/8, frame.size.height - 3.0f, frame.size.width/4, 3)];
}

- (UIView *)indicate {
    if (!_indicate) {
        _indicate = [[UIView alloc] initWithFrame:CGRectZero];
        [_indicate setBackgroundColor:[UIColor redColor]];
        [_indicate.layer setCornerRadius:1.0f];
    }
    return _indicate;
}

- (void)updateIndicateWithOffsetRate:(CGFloat)rate {
    if (rate >= 0 && rate <= 1.0f) {
        [self.indicate setCenter:CGPointMake(self.frame.size.width/2 * (1 - rate) + self.frame.size.width/4, self.frame.size.height - 1.5f)];
    }
}
@end
