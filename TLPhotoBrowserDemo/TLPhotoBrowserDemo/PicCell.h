//
//  PicCell.h
//  TLPhotoBrowserDemo
//
//  Created by Creolophus on 7/13/15.
//  Copyright (c) 2015 liang.tao. All rights reserved.
//

#import <UIKit/UIKit.h>
#define PicCellId @"PicCell"

@class PicCell;

@protocol PicCellDelegate <NSObject>

- (void)picCell:(PicCell *)cell clickedImageViews:(NSArray *)imageViews atIndex:(NSUInteger)index atIndexPath:(NSIndexPath *)indexPath;

@end

@interface PicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UIImageView *picView2;
@property (strong, nonatomic) NSIndexPath *indexPath;

@property (assign, nonatomic) id<PicCellDelegate> delegate;

@end
