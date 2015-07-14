//
//  PBScrollView.m
//  TLPhotoBrowserDemo
//
//  Created by Creolophus on 7/11/15.
//  Copyright (c) 2015 liang.tao. All rights reserved.
//

#import "PBScrollView.h"
#import "PhotoItemView.h"

@interface PBScrollView ()

@property (nonatomic,assign) BOOL isScrollToIndex;

@end

@implementation PBScrollView

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
//    __block CGRect frame = self.bounds;
    
//    CGFloat w = frame.size.width ;

//    [self.subviews enumerateObjectsUsingBlock:^(PhotoItemView *photoItemView, NSUInteger idx, BOOL *stop) {
//
//        CGFloat x = w * photoItemView.pageIndex;
//
//        frame.origin.x = x;
//        
//        [UIView animateWithDuration:.01 animations:^{
//            photoItemView.frame = frame;
////            NSLog(@"%@", NSStringFromCGRect(photoItemView.frame));
//            
//        }];
//        
//    }];
    
//    if(!_isScrollToIndex){
//        
//        //显示第index张图
//        CGFloat offsetX = w * _index;
//        
//        [self setContentOffset:CGPointMake(offsetX, 0) animated:NO];
//        
//        _isScrollToIndex = YES;
//    }
    
}

- (PhotoItemView *)photoItemViewForPhoto:(Photo *)photo{
    for (PhotoItemView *photoItemView in [self photoItemSubViews]) {
        if (photoItemView.photo == photo) {
            return photoItemView;
        }
    }
    return nil;
}

- (NSArray *)photoItemSubViews {
    NSMutableArray *views = [NSMutableArray new];
    for (UIView *subview in self.subviews) {
        if ([subview class] == [PhotoItemView class]){
            [views addObject:subview];
        }
    }
    return views;
}

- (CGRect)frameForPhotoItemViewAtPage:(NSUInteger)page{
    CGRect frame = [UIScreen mainScreen].bounds;
    CGFloat x = frame.size.width * page;
    frame.origin.x = x;
    return frame;
}

- (BOOL)shouldRenderPhotoItemView:(CGRect)viewFrame{
    CGRect selfBounds = [UIScreen mainScreen].bounds;
    if (viewFrame.origin.x < self.contentOffset.x - selfBounds.size.width) {
        return NO;
    }
    if (viewFrame.origin.x > self.contentOffset.x + selfBounds.size.width) {
        return NO;
    }
    return YES;
}


@end
