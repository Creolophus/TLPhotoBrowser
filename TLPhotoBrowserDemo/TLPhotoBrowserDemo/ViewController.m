//
//  ViewController.m
//  TLPhotoBrowserDemo
//
//  Created by Creolophus on 7/11/15.
//  Copyright (c) 2015 liang.tao. All rights reserved.
//

#import "ViewController.h"
#import "PhotoBrowserVC.h"
#import <UIImageView+WebCache.h>
#import "PicCell.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, PicCellDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *networkThumbnails;
@property (strong, nonatomic) NSMutableArray *networkImgs;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:PicCellId bundle:nil] forCellReuseIdentifier:PicCellId];
    [self.view addSubview:_tableView];
    
    _networkThumbnails = [@[
  @[@"http://desk.fd.zol-img.com.cn/g2/M00/08/01/Cg-4WVWjJcGIYi0nAACBvDIme1YAAHD5gFNat0AAIHU016.jpg",
    @"http://desk.fd.zol-img.com.cn/g2/M00/08/01/ChMlWlWjI8yIHquLAABld7246ucAAHD2QFoGLwAAGWP767.jpg"],
  
  @[@"http://desk.fd.zol-img.com.cn/g2/M00/04/0B/ChMlWlWfdayIeC29AAB_vF2LwYkAAG2ewAtHikAAH_U439.jpg",
    @"http://desk.fd.zol-img.com.cn/g2/M00/04/06/Cg-4WVWfMP2IWbzNAAC03tffIGAAAG1VwLIGkMAALT2558.jpg"],
  
  @[@"http://desk.fd.zol-img.com.cn/g2/M00/03/09/ChMlWlWeJtWIArsMAACN_c0fDCIAAGx5gFCfpcAAI4V844.jpg",
    @"http://desk.fd.zol-img.com.cn/g2/M00/03/09/ChMlWlWeJqaIIqtIAAByWNJ7uRAAAGx5APx6pIAAHJw034.jpg"],
  
  @[@"http://desk.fd.zol-img.com.cn/g2/M00/03/08/Cg-4WVWeIQeIaa3LAACvY6VNbKMAAGxzAK0AJUAAK97646.jpg",
    @"http://desk.fd.zol-img.com.cn/g2/M00/03/05/Cg-4WVWd4lmIdRzHAACWe1P2MgAAAGxFgGyoNoAAJaT801.jpg"]
  
  ] mutableCopy];
    _networkImgs = [@[
                      @[@"http://b.zol-img.com.cn/desk/bizhi/image/6/1440x900/1436755164523.jpg",
                        @"http://b.zol-img.com.cn/desk/bizhi/image/6/1440x900/1436754726998.jpg"],
                      
                      @[@"http://b.zol-img.com.cn/desk/bizhi/image/6/1024x768/1436513450927.jpg",
                        @"http://b.zol-img.com.cn/desk/bizhi/image/6/1366x768/1436495787140.jpg"],
                      
                      @[@"http://b.zol-img.com.cn/desk/bizhi/image/6/1280x1024/1436427858881.jpg",
                        @"http://b.zol-img.com.cn/desk/bizhi/image/6/1280x1024/1436426451272.jpg"],
                      
                      @[@"http://b.zol-img.com.cn/desk/bizhi/image/6/1280x1024/1436410773444.jpg",
                        @"http://b.zol-img.com.cn/desk/bizhi/image/6/1280x1024/1436409042766.jpg"]
                         ] mutableCopy];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _networkThumbnails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PicCell *cell = [tableView dequeueReusableCellWithIdentifier:PicCellId forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell.picView sd_setImageWithURL:[NSURL URLWithString:_networkThumbnails[indexPath.row][0]]];
    [cell.picView2 sd_setImageWithURL:[NSURL URLWithString:_networkThumbnails[indexPath.row][1]]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}


#pragma mark -- cell delegate

- (void)picCell:(PicCell *)cell clickedImageViews:(NSArray *)imageViews atIndex:(NSUInteger)index atIndexPath:(NSIndexPath *)indexPath{
    __weak ViewController *wkSelf = self;
    [PhotoBrowserVC show:self type:PhotoBrowserVCTypeZoom contentType:BrowserContentTypePicNews index:index photoModelBlock:^NSArray *{
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[wkSelf.networkThumbnails[indexPath.row] count]];
        for (int i=0; i<[wkSelf.networkThumbnails[indexPath.row] count]; i++) {
            Photo *photo = [Photo new];
            photo.mid = i + 1;
            photo.title = [NSString stringWithFormat:@"这是标题%@",@(i+1)];
            photo.desc = [NSString stringWithFormat:@"我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字%@",@(i+1)];
            photo.imageURL = wkSelf.networkImgs[indexPath.row][i];
            
            UIImageView *imageView = imageViews[i];
            photo.thumbnail = imageView.image;
            photo.sourceImageView = imageView;
            
            [photos addObject:photo];
        }
        return photos;
    }];
}


- (BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
@end
