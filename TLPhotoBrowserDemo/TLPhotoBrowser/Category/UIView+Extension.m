//
//  UIView+Extension.m
//  TLPhotoBrowserDemo
//
//  Created by Creolophus on 7/11/15.
//  Copyright (c) 2015 liang.tao. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

+ (CGRect)frameWithW:(CGFloat)w h:(CGFloat)h center:(CGPoint)center{
    
    CGFloat x = center.x - w * .5f;
    CGFloat y = center.y - h * .5f;
    CGRect frame = (CGRect){CGPointMake(x, y),CGSizeMake(w, h)};
    
    return frame;
}

+ (instancetype)viewFromXIB{
    
    NSString *name=NSStringFromClass(self);
    
    UIView *xibView=[[[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil] firstObject];
    
    if(xibView==nil){
        NSLog(@"从xib创建视图失败，当前类是：%@",name);
    }
    
    return xibView;
}

@end
