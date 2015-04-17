//
//  UIImage+reSize.m
//  ONE_XIB
//
//  Created by 、雨凡 on 15/3/30.
//  Copyright (c) 2015年 、雨凡. All rights reserved.
//

#import "UIImage+reSize.h"

@implementation UIImage (reSize)
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}
@end
