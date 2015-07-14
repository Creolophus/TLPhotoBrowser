//
//  ViewControllerForNews.m
//  TLPhotoBrowserDemo
//
//  Created by Creolophus on 7/13/15.
//  Copyright (c) 2015 liang.tao. All rights reserved.
//

#import "ViewControllerForNews.h"
#import "PhotoBrowserVC.h"

@interface ViewControllerForNews ()
@property (weak, nonatomic) IBOutlet UIImageView *imgV1;
@property (weak, nonatomic) IBOutlet UIImageView *imgV2;
@property (weak, nonatomic) IBOutlet UIImageView *imgV3;
@property (weak, nonatomic) IBOutlet UIImageView *imgV4;
@property (strong, nonatomic) NSMutableArray *imgArray;
@property (strong, nonatomic) NSArray *imageViews;
@end

@implementation ViewControllerForNews

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imgArray = [NSMutableArray array];
    for (int i=1; i<5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d", i]];
        [_imgArray addObject:image];
    }
    
    _imageViews = @[_imgV1, _imgV2, _imgV3, _imgV4];
    

}


- (IBAction)tapped:(UITapGestureRecognizer *)sender{
    NSInteger index = sender.view.tag;
    __weak typeof(self) weakSelf=self;
    [PhotoBrowserVC show:self type:PhotoBrowserVCTypeZoom contentType:BrowserContentTypePhotoBrowser index:index photoModelBlock:^NSArray *{
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:_imgArray.count];
        for (int i=0; i<weakSelf.imgArray.count; i++) {
            Photo *photo = [Photo new];
            photo.mid = i + 1;
//            photo.title = [NSString stringWithFormat:@"这是标题%@",@(i+1)];
//            photo.desc = [NSString stringWithFormat:@"我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字%@",@(i+1)];
            photo.image = weakSelf.imgArray[i];
            //如果要使用zoom,必须传sourceImageView
            photo.sourceImageView = _imageViews[i];
            [photos addObject:photo];
        }
        return photos;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
