//
//  ViewForArticle.m
//  ONE
//
//  Created by 、雨凡 on 15/3/31.
//  Copyright (c) 2015年 、雨凡. All rights reserved.
//

#import "ViewForArticle.h"

@implementation ViewForArticle

- (void)configSucceed:(succeed)block{
    DataManager *DM = [DataManager sharedManager];
    [DM dataFromMark:self.mark andLocation:self.location BySymbol:self.symbol succeed:^(id dicData) {
        self->dic = dicData[self.symbol];
        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, screenWIDTH - 30, 15)];
        dateLabel.text = [((NSString *)dic[@"strContMarketTime"]) toDate];
        dateLabel.font = [UIFont systemFontOfSize:13];
        dateLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65];
        [self addSubview:dateLabel];
        
        
        UIImageView *readImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pageViewImg"]];
        UILabel *sRdNumLab = [[UILabel alloc] initWithFrame:CGRectZero];
        sRdNumLab.text = dic[@"sRdNum"];
        CGSize size = [sRdNumLab boundingRectWithSize:CGSizeMake(screenWIDTH * .5f, 15)];
        sRdNumLab.frame = CGRectMake(screenWIDTH - 15 - size.width, 15, size.width, size.height);
        sRdNumLab.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.45];
        sRdNumLab.textAlignment = NSTextAlignmentRight;
        sRdNumLab.font = [UIFont systemFontOfSize:13.f];
        readImg.center = CGPointMake(screenWIDTH - readImg.frame.size.width / 2.f - size.width - 10, sRdNumLab.center.y + 2);
        [self addSubview:sRdNumLab];
        [self addSubview:readImg];
        
        
        UIImageView *imgBgLine = [[UIImageView alloc] initWithFrame:CGRectMake(15, dateLabel.frame.origin.y + 15.f + 8.f, screenWIDTH - 30, 1)];
        imgBgLine.image = [UIImage imageNamed:@"horizontalLine"];
        [self addSubview:imgBgLine];
        
        
        //UILabel *articleTittle = [[UILabel alloc] initWithFrame:CGRectZero];与下面这个方法有什么区别？
        UILabel *articleTittle = [[UILabel alloc] init];
        articleTittle.text = dic[@"strContTitle"];
        size = [articleTittle boundingRectWithSize:CGSizeMake(screenWIDTH - 30, INTMAX_MAX)];
        articleTittle.frame = CGRectMake(15, 39 + 15, size.width, size.height);
        articleTittle.font = [UIFont systemFontOfSize:17];
        [self addSubview:articleTittle];
        
        UILabel *authorName = [[UILabel alloc] initWithFrame:CGRectMake(15, articleTittle.frame.origin.y + articleTittle.frame.size.height + 5, screenWIDTH, 12)];
        authorName.text = dic[@"strContAuthor"];
        authorName.font = [UIFont systemFontOfSize:14];
        authorName.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        [self addSubview:authorName];
        
        
        
        
        NSString *articleString = [[[dic[@"strContent"] componentsSeparatedByString:@"<br>"] componentsJoinedByString:@"\n\t"] stringByAppendingString:[NSString stringWithFormat:@"\n\n%@",dic[@"strContAuthorIntroduce"]]];
        articleString = [NSString stringWithFormat:@"\t%@",articleString];
        UILabel *articleLabel = [[UILabel alloc] init];
        articleLabel.text = articleString;
        articleLabel.font = [UIFont systemFontOfSize:14];
        articleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.78];
        size = [articleLabel boundingRectWithSize:CGSizeMake(screenWIDTH - 30, CGFLOAT_MAX)];
        CGPoint origination = CGPointMake(15, authorName.frame.origin.y + authorName.bounds.size.height + 25);
        if(size.height > 8100){
            NSString *preString = [articleString substringToIndex:articleString.length / 2];
            NSString *aftString = [articleString substringFromIndex:articleString.length / 2];
            NSRange range = [aftString rangeOfString:@"\n"];
            preString = [preString stringByAppendingString:[aftString substringToIndex:range.location]];
            aftString = [aftString substringFromIndex:range.location];
            NSArray *array = @[preString,aftString];
            
            for (int i = 0; i < 2; ++i) {
                UILabel *labArticle = [[UILabel alloc] init];
                labArticle.text = array[i];
                labArticle.font = [UIFont systemFontOfSize:14];
                labArticle.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.78];
                size = [labArticle boundingRectWithSize:CGSizeMake(screenWIDTH - 20, CGFLOAT_MAX)];
                labArticle.frame = CGRectMake(origination.x, origination.y, size.width, size.height);
                origination.y += size.height;
                [self addSubview:labArticle];
            }
        }else{
            articleLabel.frame = CGRectMake(origination.x, origination.y, size.width, size.height);
            origination.y += size.height;
            [self addSubview:articleLabel];
        }
        
        self.labLikeCount = [[UILabel alloc] init];
        self.labLikeCount.text = [NSString stringWithFormat:@"%@",dic[@"strPraiseNumber"]];
        self.labLikeCount.font = [UIFont systemFontOfSize:12];
        size = [self.labLikeCount boundingRectWithSize:CGSizeMake(100, 20)];
        self.labLikeCount.frame = CGRectMake(0, 0, size.width, size.height);
        self.labLikeCount.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.labLikeCount.center = CGPointMake(screenWIDTH - 15 - size.width / 2.f, origination.y + size.height + 20 + self.labLikeCount.frame.size.height / 2.f);
        
        // mainScrollView--scrollView设置btnLike.tag
        self.btnLike = [LikeButton buttonWithType:UIButtonTypeCustom];
        self.btnLike.frame = CGRectMake(0, 0, 26, 24);
        self.btnLike.center = CGPointMake(self.labLikeCount.center.x - self.labLikeCount.frame.size.width - 12, self.labLikeCount.center.y + 1);
        self.btnLike.isLike = NO;
        [self.btnLike setImage:[UIImage imageNamed:@"home_like_iPad"] forState:UIControlStateNormal];
        [self.btnLike addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnLike addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
        
        self.btnLike.center = CGPointMake(self.labLikeCount.frame.origin.x - 12, self.labLikeCount.center.y + 1);
        UIImageView *likeBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.labLikeCount.center.x - self.btnLike.center.x + 20  + (self.labLikeCount.bounds.size.width + self.btnLike.bounds.size.width) / 2.f , self.labLikeCount.frame.size.height + 8)];
        likeBgImgView.image = [[UIImage imageNamed:@"home_likeBg"] stretchableImageWithLeftCapWidth:22 * .5f topCapHeight:24.5f * .5f];
        likeBgImgView.center = CGPointMake(screenWIDTH - likeBgImgView.bounds.size.width / 2.f, self.labLikeCount.center.y);
        
        [self addSubview:likeBgImgView];
        [self addSubview:self.labLikeCount];
        [self addSubview:self.btnLike];
        
        UIImageView *down = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.btnLike.center.y + 15.f + 8.f, screenWIDTH - 30, 1)];
        down.image = [UIImage imageNamed:@"horizontalLine"];
        [self addSubview:down];
        
        UILabel *name = [[UILabel alloc] init];
        name.text = authorName.text;
        name.font = [UIFont systemFontOfSize:18];
        name.textColor = [UIColor blackColor];
        size = [name boundingRectWithSize:CGSizeMake(100, 20)];
        name.frame = CGRectMake(15, down.center.y + 10, size.width, size.height);
        [self addSubview:name];
        
        UILabel *authorNetName = [[UILabel alloc] init];
        authorNetName.font = [UIFont systemFontOfSize:13];
        authorNetName.text = dic[@"sWbN"];
        authorNetName.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        size = [authorNetName boundingRectWithSize:CGSizeMake(100, 20)];
        authorNetName.frame = CGRectMake(15 + name.bounds.size.width + 2, name.bounds.size.height - size.height + name.frame.origin.y, size.width, size.height);
        [self addSubview:authorNetName];
        
        
        UILabel *author = [[UILabel alloc] init];
        author.text = dic[@"sAuth"];
        author.font = [UIFont systemFontOfSize:14];
        size = [author boundingRectWithSize:CGSizeMake(screenWIDTH - 30, 200)];
        author.frame = CGRectMake(15, authorNetName.frame.origin.y + 20 + authorNetName.bounds.size.height, size.width, size.height);
        [self addSubview:author];
        self.frame = CGRectMake(0, 0, screenWIDTH, author.center.y + author.bounds.size.height + 40);
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
