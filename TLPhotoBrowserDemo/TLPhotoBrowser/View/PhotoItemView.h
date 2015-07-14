//
//  PhotoItemView.h
//  TLPhotoBrowserDemo
//
//  Created by Creolophus on 7/11/15.
//  Copyright (c) 2015 liang.tao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"
#import "PhotoImageView.h"
#import "PhotoBrowserType.h"

typedef void(^PhotoItemViewSingleTapBlock)();

@interface PhotoItemView : UIView

@property (strong, nonatomic) Photo *photo;

/** 当前的页标 */
@property (nonatomic,assign) NSUInteger pageIndex;

/** 是否有图片数据 */
@property (nonatomic,assign) BOOL hasImage;

/** 当前缩放比例 */
@property (nonatomic,assign) CGFloat zoomScale;


/** 展示照片的视图 */
@property (nonatomic,strong) PhotoImageView *photoImageView;

/** type */
@property (nonatomic,assign) PhotoBrowserVCType browserType;

/* 单击回调block */
@property (copy, nonatomic) PhotoItemViewSingleTapBlock photoItemViewSingleTapBlock;

/* 缩小返回 */
-(void)zoomDismiss:(void(^)())compeletionBlock;

@end
