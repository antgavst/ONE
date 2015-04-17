//
//  ONETabBarController.h
//  ONE
//
//  Created by 、雨凡 on 15/3/31.
//  Copyright (c) 2015年 、雨凡. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ONETabBarController : UITabBarController
@property UIView *bgView;
@property UIView *menu;
@property UIScrollView *bgScrollView;
@property UIImageView *bgImgView;
@property (nonatomic, strong) UIView *customTabbarView;
- (void)share;
- (void)hiddenTabBaeView;
- (void)showTabView;
- (void)displayImg:(UIImage *)img;
@end
