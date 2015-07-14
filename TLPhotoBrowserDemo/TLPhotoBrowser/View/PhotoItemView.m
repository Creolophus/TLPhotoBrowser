//
//  PhotoItemView.m
//  TLPhotoBrowserDemo
//
//  Created by Creolophus on 7/11/15.
//  Copyright (c) 2015 liang.tao. All rights reserved.
//

#import "PhotoItemView.h"
#import "UIView+Extension.h"
#import "UIImage+ReMake.h"
#import <UIImageView+WebCache.h>
#import "PhotoProgressView.h"

@interface PhotoItemView ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet PhotoProgressView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

/* 单机手势 */
@property (strong, nonatomic) UITapGestureRecognizer *singleTapGesture;

/* 双击手势 */
@property (strong, nonatomic) UITapGestureRecognizer *doubleTapGesture;

@end

@implementation PhotoItemView
@synthesize zoomScale = _zoomScale;

- (void)awakeFromNib{
    _scrollView.delegate = self;
    
    [self addGestureRecognizer:self.singleTapGesture];
    [self addGestureRecognizer:self.doubleTapGesture];
}

#pragma mark - setter&&getter

- (PhotoImageView *)photoImageView{
    
    if(_photoImageView == nil){
        
        _photoImageView = [[PhotoImageView alloc] init];
        
        _photoImageView.userInteractionEnabled = YES;
        
        [_scrollView addSubview:_photoImageView];
    }
    
    return _photoImageView;
}

- (UITapGestureRecognizer *)singleTapGesture{
    if (!_singleTapGesture) {
        _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        _singleTapGesture.numberOfTapsRequired = 1;
        [_singleTapGesture requireGestureRecognizerToFail:self.doubleTapGesture];
    }
    return _singleTapGesture;
}

- (UITapGestureRecognizer *)doubleTapGesture{
    if (!_doubleTapGesture) {
        _doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        _doubleTapGesture.numberOfTapsRequired = 2;
    }
    return _doubleTapGesture;
}

- (void)setPhoto:(Photo *)photo{
    _photo = photo;
    [self dataPrepare];

}
-(CGFloat)zoomScale{
    return self.scrollView.zoomScale;
}

- (void)setZoomScale:(CGFloat)zoomScale{
    _zoomScale = zoomScale;
    [self.scrollView setZoomScale:zoomScale animated:YES];
}

#pragma mark - 处理数据
- (void)dataPrepare{
    if (!_photo) {
        return;
    }

    BOOL isNetWorkShow = _photo.image == nil;
    
    if (isNetWorkShow) {
        //如果没有传缩略图,则使用一张默认占位图,如果传了缩略图,则先显示缩略图,等图片下载完了再换成大图
        if (_photo.thumbnail) {
            self.photoImageView.image = _photo.thumbnail;
        }else{
            UIImage *image = [UIImage phImageWithSize:[UIScreen mainScreen].bounds.size zoom:.3f];
            
            self.photoImageView.image = image;
        }
        NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:_photo.imageURL]];
        UIImage *cachedImage = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:key];
        if (cachedImage) {
            self.photoImageView.image = cachedImage;
            self.hasImage = YES;
        }else{
            [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:_photo.imageURL] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                _progressView.hidden = NO;
                CGFloat progress = receivedSize /((CGFloat)expectedSize);
                _progressView.progress = progress;
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                self.hasImage = image !=nil;
                
                [UIView animateWithDuration:0.2f animations:^{
                    self.photoImageView.frame = self.photoImageView.calF;
                }];
                
                if(image!=nil && _progressView.progress <1.0f) {
                    _progressView.progress = 1.0f;
                }
                
            }];

        }
    }else{
        self.photoImageView.image = _photo.image;
        _hasImage = YES;
    }
    self.photoImageView.frame = _photo.sourceFrame;
    //如果该图片是由zoom模式点击的,则该图片需要有放大动画
    if(_photo.isFromSourceFrame && _browserType == PhotoBrowserVCTypeZoom){

        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.photoImageView.frame = self.photoImageView.calF;
        } completion:^(BOOL finished) {
        }];

        self.photo.isFromSourceFrame = NO;
    }else{
        self.photoImageView.frame = self.photoImageView.calF;
    }
}


#pragma mark - scroll view delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.photoImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    if(scrollView.zoomScale <=1) scrollView.zoomScale = 1.0f;
    
    CGFloat xcenter = scrollView.center.x , ycenter = scrollView.center.y;
    
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 : xcenter;
    
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 : ycenter;
    
    [self.photoImageView setCenter:CGPointMake(xcenter, ycenter)];

}




#pragma mark - gesture
- (void)singleTap:(UITapGestureRecognizer *)gesture{
    if (_photoItemViewSingleTapBlock) {
        _photoItemViewSingleTapBlock();
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)gesture{
    if (!self.hasImage) {
        return;
    }
    CGFloat zoomScale = self.scrollView.zoomScale;
    
    if(zoomScale<=1.0f){
        
        CGPoint loc = [gesture locationInView:gesture.view];
        
        CGFloat wh =1;
        
        CGRect rect = [UIView frameWithW:wh h:wh center:loc];
        
        [self.scrollView zoomToRect:rect animated:YES];
    }else{
        [self.scrollView setZoomScale:1.0f animated:YES];
    }
    
}

- (void)zoomDismiss:(void (^)())compeletionBlock{
    self.photo.sourceImageView.hidden = YES;

    [UIView animateWithDuration:0.3f animations:^{
        self.photoImageView.contentMode = self.photo.sourceImageView.contentMode;
        self.photoImageView.frame = self.photo.sourceFrame;
        self.photoImageView.clipsToBounds = YES;
    }completion:^(BOOL finished) {
        self.photo.sourceImageView.hidden = NO;
        if (finished) {
            compeletionBlock();
        }
    }];
}

@end
