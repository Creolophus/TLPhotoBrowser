//
//  PhotoBrowerVC.h
//  TLPhotoBrowserDemo
//
//  Created by Creolophus on 7/11/15.
//  Copyright (c) 2015 liang.tao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoBrowserType.h"
#import "Photo.h"

@interface PhotoBrowserVC : UIViewController

+ (void)show:(UIViewController *)handleVC type:(PhotoBrowserVCType)type contentType:(BrowserContentType)contentType index:(NSUInteger)index photoModelBlock:(NSArray *(^)())photoModelBlock ;

@end
