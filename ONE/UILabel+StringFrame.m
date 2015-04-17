//
//  UILabel+StringFrame.m
//  ONE
//
//  Created by 、雨凡 on 15/3/27.
//  Copyright (c) 2015年 、雨凡. All rights reserved.
//

#import "UILabel+StringFrame.h"

@implementation UILabel (StringFrame)

- (CGSize)boundingRectWithSize:(CGSize)size{
    self.numberOfLines = 0;
    CGSize retSize = [self.text boundingRectWithSize:size
                                             options: NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName: self.font}
                                             context:nil].size;
    return retSize;
}

@end
