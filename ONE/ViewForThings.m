//
//  ViewForThings.m
//  ONE
//
//  Created by 、雨凡 on 15/4/1.
//  Copyright (c) 2015年 、雨凡. All rights reserved.
//

#import "ViewForThings.h"
#import "UIButton+AFNetworking.h"
@implementation ViewForThings
- (void)configSucceed:(succeed)block{
    DataManager *DM = [DataManager sharedManager];
    [DM dataFromMark:self.mark andLocation:self.location BySymbol:self.symbol succeed:^(id dicData){
        self->dic = dicData[self.symbol];
        CGFloat width = screenWIDTH - 30;
        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, width, 15)];
        dateLabel.text = [((NSString *)dic[@"strTm"]) toDate];
        dateLabel.font = [UIFont systemFontOfSize:13];
        dateLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65];
        [self addSubview:dateLabel];
        
        UIImageView *imgBgLine = [[UIImageView alloc] initWithFrame:CGRectMake(15, dateLabel.frame.origin.y + 15.f + 8.f, width, 1)];
        imgBgLine.image = [UIImage imageNamed:@"horizontalLine"];
        [self addSubview:imgBgLine];
        
        
        UIButton *btnAD = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAD.frame = CGRectMake(15, imgBgLine.frame.origin.y + 1 + 20, width, width);
        [btnAD setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:dic[@"strBu"]]];
        [btnAD addTarget:self action:@selector(goToNet) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnAD];
        
        UILabel *tittle = [[UILabel alloc] init];
        tittle.text = dic[@"strTt"];
        CGSize size = [tittle boundingRectWithSize:CGSizeMake(width, 200)];
        tittle.frame = CGRectMake(16, 20 + btnAD.frame.origin.y + btnAD.bounds.size.height, size.width, size.height);
        [self addSubview:tittle];
        
        UILabel *detail = [[UILabel alloc] init];
        detail.text = [dic[@"strTc"] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        size = [detail boundingRectWithSize:CGSizeMake(width, 8192)];
        detail.frame = CGRectMake(16, tittle.frame.origin.y + tittle.bounds.size.height + 15, size.width, size.height);
        detail.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [self addSubview:detail];
        
        self.frame = CGRectMake(0, 0, width, 64 + detail.frame.origin.y + size.height);
        block(self);
    }];
}


//用浏览器打开一个目标网址
//1、需要调用代理方法完成
- (void)goToNet{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"跳转到相关页面" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:dic[@"strWu"]]];
    }
}




//2、需要用到block传参数URL到viewcontroller
//- (void)goToNet{
//    if (self.alert) {
//        self.alert([NSURL URLWithString:self.dic[@"strWu"]]);
//    }
//}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
