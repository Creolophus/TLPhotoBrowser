//
//  PBScrollView.h
//  TLPhotoBrowserDemo
//
//  Created by Creolophus on 7/11/15.
//  Copyright (c) 2015 liang.tao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoItemView;
@class Photo;

@interface PBScrollView : UIScrollView

@property (assign, nonatomic) NSUInteger index;


- (PhotoItemView *)photoItemViewForPhoto:(Photo *)photo;

- (CGRect)frameForPhotoItemViewAtPage:(NSUInteger)page;

- (BOOL)shouldRenderPhotoItemView:(CGRect)viewFrame;
@end
