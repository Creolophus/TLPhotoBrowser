//
//  Photo.h
//  TLPhotoBrowserDemo
//
//  Created by Creolophus on 7/11/15.
//  Copyright (c) 2015 liang.tao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PhotoBrowserType.h"

@interface Photo : NSObject

/** mid，保存图片缓存唯一标识，必须传 */
@property (assign, nonatomic) NSUInteger mid;

/** 网络图片 */
@property (strong, nonatomic) NSString *imageURL;

/** 网络图片的缩略图 */
@property (strong, nonatomic) UIImage *thumbnail;

/** 本地图片 */
@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) UIImage *blurImage;

/** 标题 */
@property (strong, nonatomic) NSString *title;

/** 描述 */
@property (strong, nonatomic) NSString *desc;

/** 源frame */
@property (nonatomic,assign,readonly) CGRect sourceFrame;

/** 源imageView */
@property (weak, nonatomic) UIImageView *sourceImageView;

/** 是否从源frame放大呈现 */
@property (assign, nonatomic) BOOL isFromSourceFrame;

+ (NSString *)check:(NSArray *)photos type:(PhotoBrowserVCType)type;
@end
