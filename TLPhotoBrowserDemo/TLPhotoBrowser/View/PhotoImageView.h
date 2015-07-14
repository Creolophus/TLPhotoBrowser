//
//  PhotoImageView.h
//  TLPhotoBrowserDemo
//
//  Created by Creolophus on 7/11/15.
//  Copyright (c) 2015 liang.tao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoImageView : UIImageView

@property (nonatomic,assign) CGRect calF;

/**
 *  @author liang.tao, 15-07-14 10:07:51
 *
 *  @brief  旋转时候,需要重新计算一次Frame
 */
- (void)calFrame;
@end
