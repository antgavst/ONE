//
//  ViewForHome.m
//  ONE_XIB
//
//  Created by 、雨凡 on 15/3/30.
//  Copyright (c) 2015年 、雨凡. All rights reserved.
//

#import "ViewForHome.h"
#import "AppDelegate.h"
#import "ONETabBarController.h"
@implementation ViewForHome

-(instancetype)initWithMark:(NSInteger)mark andLocation:(NSInteger)location BySymbol:(NSString *)symbol{
    if (self = [super init]) {
        self.mark = mark;
        self.location = location;
        self.symbol = symbol;
    }
    return self;
}

- (void)configSucceed:(succeed)block{
    DataManager *DM = [DataManager sharedManager];
    [DM dataFromMark:_mark andLocation:_location BySymbol:_symbol succeed:^(id dicData) {
        dic = dicData[_symbol];
        CGFloat width = screenWIDTH - 30;
        
        //VOL.898--strHpTitle
        UILabel *labNumber = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, width, 15)];
        labNumber.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        labNumber.text = dic[@"strHpTitle"];
        [self addSubview:labNumber];
        
        //horizontalLine
        UIImageView *bgLine = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20 + 15 + 3, width, 1)];//
        bgLine.image = [UIImage imageNamed:@"horizontalLine"];
        [self addSubview:bgLine];
        
        //strThumbnailUrl --workImage
        _workImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 38 + 1 + 10, width, width * 3 / 4.f)];
        
        
        __block NSString *key = self->dic[@"strThumbnailUrl"];
        UIImage *img_back = [UIImage imageWithData:[DM.NSUD objectForKey:[NSString stringWithFormat:@"%@",key]]];
        if (img_back) {
//            NSLog(@"图片来自本地！");
            _workImgView.image = img_back;
        }else{
            __weak ViewForHome *vf = self;
            [_workImgView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:dic[@"strThumbnailUrl"]]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                vf.workImgView.image = image;
                [DM store:UIImageJPEGRepresentation(image, 1) andKey:key];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                NSLog(@"图片加载失败！");
            }];
        }
        _workImgView.userInteractionEnabled = YES;
        [self addSubview:_workImgView];
        
        NSArray *array = [dic[@"strAuthor"] componentsSeparatedByString:@"&"];
        UILabel *label;
        for (int i = 0; i < 2; ++i) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(15, 49 + _workImgView.bounds.size.height + i * 15 + 10, screenWIDTH - 30, 15)];
            label.text = array[i];
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65];
            [self addSubview:label];
        }
        
        //labDay
        NSString *dateString = dic[@"strMarketTime"];
        array = [dateString componentsSeparatedByString:@"-"];
        UILabel *labDay = [[UILabel alloc] initWithFrame:CGRectMake(20, label.frame.origin.y + 25, 68, 68)];
        labDay.text = array.lastObject;
        labDay.textColor = [UIColor colorWithRed:40 / 255.0 green:181 / 255.0 blue:241 / 255.0 alpha:1];
        labDay.font = [UIFont systemFontOfSize:60];
        [self addSubview:labDay];
        
        //month and year
        UILabel *labMonthAndYear = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labDay.frame.size.width, 15)];
        if (array.count>1) {
            labMonthAndYear.text = [@[[array[1] toMonthAllOrNot:NO],array[0]] componentsJoinedByString:@""];
        }
        
        labMonthAndYear.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        labMonthAndYear.center = CGPointMake(labDay.center.x, labDay.center.y + 70 / 2.f + 2);
        labMonthAndYear.font = [UIFont systemFontOfSize:14];
        labMonthAndYear.textAlignment = NSTextAlignmentLeft;
        [self addSubview:labMonthAndYear];
        
        
        //mianContent
        UILabel *labContent= [[UILabel alloc] initWithFrame:CGRectZero];
        labContent.text = dic[@"strContent"];
        labContent.font = [UIFont systemFontOfSize:15];
        labContent.textColor = [UIColor whiteColor];
        CGSize size = [labContent boundingRectWithSize:CGSizeMake(screenWIDTH * .55, 1000)];
        labContent.frame = CGRectMake(labDay.frame.origin.x + labDay.bounds.size.width + 20, labDay.frame.origin.y + 25, size.width, size.height);
        UIImage *img = [UIImage imageNamed:@"contBack"];
        UIImageView *imgContent = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, labContent.frame.size.width + 26, labContent.frame.size.height + 18)];
        imgContent.center = labContent.center;
        imgContent.image = [img stretchableImageWithLeftCapWidth:img.size.width * .5f topCapHeight:img.size.height * .5f];
        [self addSubview:imgContent];
        [self addSubview:labContent];
        
        
        self.labLikeCount = [[UILabel alloc] initWithFrame:CGRectZero];
        self.labLikeCount.text = [NSString stringWithFormat:@"%@   ",dic[@"strPn"]];
        self.labLikeCount.font = [UIFont systemFontOfSize:12];
        
        // mainScrollView--scrollView设置labComentCount.tag
        self.labLikeCount.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        size = [self.labLikeCount boundingRectWithSize:CGSizeMake(50, 50)];
        self.labLikeCount.frame = CGRectMake(screenWIDTH - size.width, imgContent.frame.origin.y + imgContent.bounds.size.height + 20, size.width, size.height);
        
        
        // mainScrollView--scrollView设置btnLike.tag
        self.btnLike = [LikeButton buttonWithType:UIButtonTypeCustom];
        self.btnLike.frame = CGRectMake(0, 0, 26, 24);
        self.btnLike.center = CGPointMake(self.labLikeCount.center.x - self.labLikeCount.frame.size.width - 12, self.labLikeCount.center.y + 1);
        self.btnLike.isLike = NO;
        [self.btnLike setImage:[UIImage imageNamed:@"home_like_iPad"] forState:UIControlStateNormal];
        [self.btnLike addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnLike addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
        
        self.btnLike.center = CGPointMake(self.labLikeCount.frame.origin.x - 10, self.labLikeCount.center.y + 1);
        UIImageView *likeBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.labLikeCount.center.x - self.btnLike.center.x + 5  + (self.labLikeCount.bounds.size.width + self.btnLike.bounds.size.width) / 2.f , self.labLikeCount.frame.size.height + 8)];
        likeBgImgView.image = [[UIImage imageNamed:@"home_likeBg"] stretchableImageWithLeftCapWidth:22 * .5f topCapHeight:24.5f * .5f];
        likeBgImgView.center = CGPointMake(screenWIDTH - likeBgImgView.bounds.size.width / 2.f, self.labLikeCount.center.y);
        
        [self addSubview:likeBgImgView];
        [self addSubview:self.labLikeCount];
        [self addSubview:self.btnLike];
        self.frame = CGRectMake(0, 0, screenWIDTH, self.labLikeCount.frame.origin.y + 49);
        block(self);
    }];
    
}

- (void)like:(LikeButton *)button{
    self.labLikeCount.text = [NSString stringWithFormat:@"%ld",[self.labLikeCount.text integerValue] + (button.isLike ? -1 : 1)];
    [button setImage:[UIImage imageNamed:(button.isLike ? @"home_like_iPad" : @"home_like_hl_iPad")]
            forState:UIControlStateNormal];
    button.isLike = !button.isLike;
}










/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
