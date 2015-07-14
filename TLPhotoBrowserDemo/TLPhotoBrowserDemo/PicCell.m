//
//  PicCell.m
//  TLPhotoBrowserDemo
//
//  Created by Creolophus on 7/13/15.
//  Copyright (c) 2015 liang.tao. All rights reserved.
//

#import "PicCell.h"

@implementation PicCell

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [_picView addGestureRecognizer:gesture1];
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [_picView2 addGestureRecognizer:gesture2];
}


- (void)tapped:(UITapGestureRecognizer *)gesture{
    if ([_delegate respondsToSelector:@selector(picCell:clickedImageViews:atIndex:atIndexPath:)]) {
        [_delegate picCell:self clickedImageViews:@[_picView, _picView2] atIndex:gesture.view.tag atIndexPath:_indexPath];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
