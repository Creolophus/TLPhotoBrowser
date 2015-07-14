//
//  UIView+Extension.h
//  TLPhotoBrowserDemo
//
//  Created by Creolophus on 7/11/15.
//  Copyright (c) 2015 liang.tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
+ (CGRect)frameWithW:(CGFloat)w h:(CGFloat)h center:(CGPoint)center;

+ (instancetype)viewFromXIB;

@end
