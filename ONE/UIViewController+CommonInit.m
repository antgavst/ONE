//
//  UIViewController+ConfigNavgation.m
//  ONE
//
//  Created by 、雨凡 on 15/3/28.
//  Copyright (c) 2015年 、雨凡. All rights reserved.
//

#import "UIViewController+CommonInit.h"
#import "ONETabBarController.h"
@implementation UIViewController (CommonInit)
- (void)configNavgationBar{
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    UIImageView *aImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80 / 117.f * 36)];
    aImgView.center = CGPointMake(screenWIDTH / 2.0, 20);
    aImgView.image = [UIImage imageNamed:@"logo_iPad"];
    [self.navigationController.navigationBar addSubview:aImgView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 61, 16);
    button.center = CGPointMake(screenWIDTH - 30, 22);
    [button setImage:[UIImage imageNamed:@"shareBtn"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shareManaer:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:button];
}


- (void)shareManaer:(UIButton *)button{
// 分享
    ONETabBarController *one = (ONETabBarController *)self.tabBarController;
    [one share];
}











@end
