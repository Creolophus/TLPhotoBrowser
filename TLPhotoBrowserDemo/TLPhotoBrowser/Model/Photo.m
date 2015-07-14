//
//  Photo.m
//  TLPhotoBrowserDemo
//
//  Created by Creolophus on 7/11/15.
//  Copyright (c) 2015 liang.tao. All rights reserved.
//

#import "Photo.h"

@implementation Photo


+ (NSString *)check:(NSArray *)photos type:(PhotoBrowserVCType)type{
    if(photos.count==0) {
        return nil;
    }
    
    __block NSString *result =nil;
    
    [photos enumerateObjectsUsingBlock:^(Photo *photo, NSUInteger idx, BOOL *stop) {
        
        if(photo.mid ==0){
            
            result = @"错误：请为每个相册模型对象传入唯一的mid标识，因为保存图片涉及缓存等需要唯一标识,且不能为0";
            *stop = YES;
        }
        
        if(type == PhotoBrowserVCTypeZoom){
            
            if(photo.sourceImageView == nil){
                result = @"错误：当PhotoBroswerVCTypeZoom == type时，请传入源imageView控件,即需要传photoModel.sourceImageView属性。";
                *stop = YES;
            }
        }
    }];
    
    return result;
}

-(CGRect)sourceFrame{
    return [_sourceImageView convertRect:_sourceImageView.bounds toView:_sourceImageView.window];
}


@end
