//
//  PhotoBrowerVC.m
//  TLPhotoBrowserDemo
//
//  Created by Creolophus on 7/11/15.
//  Copyright (c) 2015 liang.tao. All rights reserved.
//

#import "PhotoBrowserVC.h"
#import "PhotoItemView.h"
#import "UIView+Extension.h"
#import "PBScrollView.h"
#import "UIImage+ImageEffects.h"

@interface PhotoBrowserVC ()<UIScrollViewDelegate>
/* IBOutLet */
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet PBScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (weak, nonatomic) IBOutlet UILabel *topBarLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomBarView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

/* presenting view controller */
@property (weak, nonatomic) UIViewController *handleVC;

/* 初始显示的index,不随滑动页面而变动 */
@property (assign, nonatomic) NSUInteger index;

/* 总页数 */
@property (assign, nonatomic) NSUInteger pageCount;

/* 当前页数 */
@property (assign, nonatomic) NSUInteger page;

/* 转场的样式 */
@property (assign, nonatomic) PhotoBrowserVCType browserType;

/* 内容的样式 */
@property (assign, nonatomic) BrowserContentType browserContentType;

/* 数据源 */
@property (strong, nonatomic) NSArray *photos;

/** 当前显示中的itemView */
@property (weak, nonatomic) PhotoItemView *currentItemView;

/* photoItemView数组 */
@property (strong, nonatomic) NSMutableDictionary *photoItemViewsDic;

/* 记录statusBarStyle */
@property (assign, nonatomic) UIStatusBarStyle statusBarStyle;

@end

@implementation PhotoBrowserVC

+ (void)show:(UIViewController *)handleVC type:(PhotoBrowserVCType)type contentType:(BrowserContentType)contentType index:(NSUInteger)index photoModelBlock:(NSArray *(^)())photoModelBlock{
    NSArray *photos = photoModelBlock();
    
    if (photos.count == 0) {
        return;
    }
    
    NSString *result = [Photo check:photos type:type];
    
    if (result) {
        NSLog(@"错误信息,%@", result);
        return;
    }
    
    if (index >= photos.count) {
        NSLog(@"index不能越界");
        return;
    }

    
    PhotoBrowserVC *pbVC = [PhotoBrowserVC new];
    pbVC.statusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    pbVC.index = index;
    pbVC.photos = photos;
    pbVC.browserType = type;
    pbVC.handleVC = handleVC;
    pbVC.pageCount = photos.count;
    pbVC.browserContentType = contentType;
    [pbVC show];
}

/** show */
- (void)show{
    
    switch (_browserType) {
        case PhotoBrowserVCTypePush://push
            
            [self pushPhotoVC];
            
            break;
        case PhotoBrowserVCTypeModal://modal
            
            [self modalPhotoVC];
            
            break;
            
//        case PhotoBrowserVCTypeTransition://transition====>TBC
            
//            [self transitionPhotoVC];
            
            break;
            
        case PhotoBrowserVCTypeZoom://zoom
            
            [self zoomPhotoVC];
            
            break;
            
        default:
            break;
    }
}



- (void)setBrowserContentType:(BrowserContentType)browserContentType{
    _browserContentType = browserContentType;
    switch (browserContentType) {
        case BrowserContentTypePhotoBrowser:
            self.bottomBarView.hidden = YES;
            self.backBtn.hidden = YES;
            break;
        case BrowserContentTypePicNews:
            self.bottomBarView.hidden = NO;
            self.backBtn.hidden = NO;
            break;
        default:
            break;
    }
}

/** push */
- (void)pushPhotoVC{
    self.view.backgroundColor = [UIColor blackColor];
    [_handleVC.navigationController pushViewController:self animated:YES];
}

/** modal */
- (void)modalPhotoVC{
    self.view.backgroundColor = [UIColor blackColor];
    [_handleVC presentViewController:self animated:YES completion:nil];
}


/** zoom */
-(void)zoomPhotoVC{
    
    UIWindow *window = _handleVC.view.window;
    
    if(window == nil){
        
        NSLog(@"错误：windows为空！");
        return;
    }

//    Photo *photo = _photos[_index];
    self.view.frame = [UIScreen mainScreen].bounds;
    [window addSubview:self.view];
    [_handleVC addChildViewController:self];
    [self didMoveToParentViewController:_handleVC];
    
    Photo *photo = _photos[_index];
//    photo.sourceImageView.hidden = YES;
    self.topBarView.alpha = 0;
    self.bottomBarView.alpha = 0;
    self.view.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.25f animations:^{
        self.topBarView.alpha = 1;
        self.bottomBarView.alpha = 1;
        self.view.backgroundColor = [UIColor blackColor];

    } completion:^(BOOL finished) {
        photo.sourceImageView.hidden = NO;
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self vcPrepare];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)vcPrepare{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat widthEachPage = [UIScreen mainScreen].bounds.size.width;
    _scrollView.contentSize = CGSizeMake(widthEachPage * _photos.count, 0);
    _photoItemViewsDic = [NSMutableDictionary dictionary];
    self.page = _index;
    CGFloat offsetX = widthEachPage * _index;
    
    //需要等autolayout更新frame,延时0.1s
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (offsetX == 0) {
            [self buildViewsForCurrentOffset];
            
        }else{
            
            [_scrollView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
        }
        [self blurBackground];
        self.browserContentType = _browserContentType;
    });
}

#pragma mark - getter && setter
- (PhotoItemView *)currentItemView{
    if (_photoItemViewsDic.count <= 0) {
        return nil;
    }
    return _photoItemViewsDic[@(_page)];
}

- (void)setPhotos:(NSArray *)photos{
    _photos = photos;
    Photo *photo = photos[_index];
    photo.isFromSourceFrame = YES;
}


- (void)setPage:(NSUInteger)page{
    if (_page != 0 && _page == page) {
        return;
    }
    _page = page;
    NSString *topBarTitle = [NSString stringWithFormat:@"%@ / %@", @(page + 1) , @(self.pageCount)];
    self.topBarLabel.text = topBarTitle;
    Photo *photo = _photos[page];
    self.titleLabel.text = photo.title;
    self.descLabel.text = photo.desc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    [self buildViewsForCurrentOffset];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.page = page;
    [self resetPhotoItemViewZoomScale];
    [self blurBackground];

}

- (void)buildViewsForCurrentOffset{
    for (int i=0; i<_photos.count; i++) {
        Photo *photo = _photos[i];
        PhotoItemView *photoItemView = [_scrollView photoItemViewForPhoto:photo];
        CGRect itemViewFrame = [_scrollView frameForPhotoItemViewAtPage:i];
        if (photoItemView) {
            photoItemView.frame = itemViewFrame;
        }
        if ([_scrollView shouldRenderPhotoItemView:itemViewFrame]) {
            if (!photoItemView) {
                NSLog(@"Adding view at page %u", i);
                PhotoItemView *photoItemView = [PhotoItemView viewFromXIB];
                photoItemView.pageIndex = i;
                photoItemView.browserType = _browserType;
                photoItemView.photo = photo;
                photoItemView.frame = itemViewFrame;
                photoItemView.photoItemViewSingleTapBlock = ^(){
                    [self singleTap];
                };
                [_scrollView addSubview:photoItemView];
                _photoItemViewsDic[@(i)] = photoItemView;
            }
        }else{
            if (photoItemView) {
                NSLog(@"Deleting view at index %u", i);
                [photoItemView removeFromSuperview];
                [_photoItemViewsDic removeObjectForKey:@(i)];
            }
        }
    }
}

- (void)resetPhotoItemViewZoomScale{
    if (_page > 0) {
        PhotoItemView *leftView = _photoItemViewsDic[@(_page - 1)];
        leftView.zoomScale = 1.f;
    }
    if (_page < _photos.count - 1) {
        PhotoItemView *rightView = _photoItemViewsDic[@(_page + 1)];
        rightView.zoomScale = 1.f;
        
    }

}

- (void)blurBackground{

    if (self.currentItemView.photo.blurImage) {
        _backgroundView.image = self.currentItemView.photo.blurImage;
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage *blurImage = [self.currentItemView.photo.thumbnail applyBlurWithRadius:20 tintColor:[UIColor colorWithWhite:0.030 alpha:0.800] saturationDeltaFactor:1.8 maskImage:nil];
            self.currentItemView.photo.blurImage = blurImage;
            dispatch_async(dispatch_get_main_queue(), ^{
                _backgroundView.image = blurImage;
            });
            
        });
    }

}

bool hidden = YES;
- (void)singleTap{
    switch (_browserContentType) {
        case BrowserContentTypePicNews:{
            hidden = !_topBarView.alpha;
            [[UIApplication sharedApplication] setStatusBarHidden:!hidden withAnimation:UIStatusBarAnimationFade];
            [UIView animateWithDuration:.25f animations:^{
                _topBarView.alpha = _bottomBarView.alpha = _backgroundView.alpha = hidden?1:0;
            } completion:nil];
        }
            break;
        case BrowserContentTypePhotoBrowser:{
            [self dismiss];
        }
        default:
            break;
    }

}


- (IBAction)backBtnClicked:(id)sender {
    [self dismiss];
}


- (void)dismiss{
    switch (_browserType) {
        case PhotoBrowserVCTypePush:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case PhotoBrowserVCTypeModal:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
//        case PhotoBrowserVCTypeTransition:
//            break;
        case PhotoBrowserVCTypeZoom:
            if (self.currentItemView.zoomScale > 1) {
                self.currentItemView.zoomScale = 1;
//                self.view.userInteractionEnabled = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.view.userInteractionEnabled = YES;
                    [self zoomOut];
                });
            }else{
                [self zoomOut];
            }
        default:
            break;
    }
}

- (void)zoomOut{
    _backgroundView.image = nil;
    [UIView animateWithDuration:.2f animations:^{
        self.topBarView.alpha = 0;
        self.bottomBarView.alpha = 0;
        self.view.backgroundColor = [UIColor clearColor];
    }];
    Photo *photo = _photos[_page];
    CGRect sourceF = photo.sourceFrame;
    
    //检查sourceF是否在屏幕里面
    CGRect screenF =[UIScreen mainScreen].bounds;
    
    BOOL isInScreen = CGRectIntersectsRect(sourceF, screenF);

    if (!self.currentItemView) {
        isInScreen = NO;
    }
    
    if (isInScreen) {
        //currentItemView是weak类型
        [self.currentItemView zoomDismiss:^{
            [self zoomOutHandle];
        }];
    }else{
        [UIView animateWithDuration:.5f animations:^{
            
            self.view.transform= CGAffineTransformMakeScale(1.2, 1.2);
            self.view.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            [self zoomOutHandle];
        }];
    }
}

-(void)zoomOutHandle{
    
    _handleVC = nil;
    
    self.photos = nil;
    
    //移除视图
    [self.view removeFromSuperview];
    
    self.view = nil;
    
    [self removeFromParentViewController];
    
    [[UIApplication sharedApplication] setStatusBarStyle:_statusBarStyle animated:YES];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    CGFloat widthEachPage = [UIScreen mainScreen].bounds.size.width;
    _scrollView.contentSize = CGSizeMake(widthEachPage * _photos.count, 0);
    for (int i=0; i<_photos.count; i++) {
        Photo *photo = _photos[i];
        PhotoItemView *photoItemView = [_scrollView photoItemViewForPhoto:photo];
        CGRect itemViewFrame = [_scrollView frameForPhotoItemViewAtPage:i];
        if (photoItemView) {
            [_scrollView setContentOffset:CGPointMake(_page * widthEachPage, 0) animated:NO];
            photoItemView.frame = itemViewFrame;
            [photoItemView.photoImageView calFrame];
            photoItemView.photoImageView.frame = photoItemView.photoImageView.calF;
        }
    }

}

- (BOOL)shouldAutorotate{
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
