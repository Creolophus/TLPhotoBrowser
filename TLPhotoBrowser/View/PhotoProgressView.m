//
//  PhotoProgressView.m
//  TLPhotoBrowserDemo
//
//  Created by Creolophus on 7/13/15.
//  Copyright (c) 2015 liang.tao. All rights reserved.
//

#import "PhotoProgressView.h"
#import "LFRoundProgressView.h"

#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface PhotoProgressView ()
@property (strong, nonatomic) LFRoundProgressView *progressView;

@end

@implementation PhotoProgressView


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        //视图准备
        [self viewPrepare];
    }
    
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self=[super initWithCoder:aDecoder];
    
    if(self){
        
        //视图准备
        [self viewPrepare];
    }
    
    return self;
}



/*
 *  视图准备
 */
-(void)viewPrepare{
    
    self.backgroundColor = rgba(0, 0, 0, .5f);
    
    [self addSubview:self.progressView];
    
    self.clipsToBounds = YES;
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.layer.cornerRadius = self.bounds.size.width * .5f;
    
    
    
    CGFloat d_xy = 5.0f;
    
    self.progressView.frame = CGRectInset(self.bounds, d_xy, d_xy);
}


-(void)setProgress:(CGFloat)progress{
    
    _progress = progress;
    
    self.progressView.progress = progress;
    
    if(progress >= 1){
        [UIView animateWithDuration:.5f animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}


-(LFRoundProgressView *)progressView{
    
    if(_progressView == nil){
        
        _progressView =[[LFRoundProgressView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    }
    
    return _progressView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
