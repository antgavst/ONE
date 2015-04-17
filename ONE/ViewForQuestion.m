//
//  ViewForQuestion.m
//  ONE
//
//  Created by 、雨凡 on 15/4/1.
//  Copyright (c) 2015年 、雨凡. All rights reserved.
//

#import "ViewForQuestion.h"

@implementation ViewForQuestion

- (void)configSucceed:(succeed)block{
    DataManager *DM = [DataManager sharedManager];
    [DM dataFromMark:self.mark andLocation:self.location BySymbol:self.symbol succeed:^(id dicData){
        self->dic = dicData[self.symbol];
        
        UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, screenWIDTH - 30, 15)];
        dateLabel.text = [((NSString *)dic[@"strQuestionMarketTime"]) toDate];
        dateLabel.font = [UIFont systemFontOfSize:13];
        dateLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65];
        [self addSubview:dateLabel];
        
        UIImageView *imgBgLine = [[UIImageView alloc] initWithFrame:CGRectMake(15, dateLabel.frame.origin.y + 15.f + 8.f, screenWIDTH - 30, 1)];
        imgBgLine.image = [UIImage imageNamed:@"horizontalLine"];
        [self addSubview:imgBgLine];
        
        UIImageView *questionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, imgBgLine.frame.origin.y + 20, 50, 50)];
        questionImageView.image = [UIImage imageNamed:@"que_img_iPad"];
        [self addSubview:questionImageView];
        
        UILabel *questionTittle = [[UILabel alloc] init];
        questionTittle.text = dic[@"strQuestionTitle"];
        questionTittle.font = [UIFont systemFontOfSize:19];
        CGSize size = [questionTittle boundingRectWithSize:CGSizeMake(screenWIDTH - 115, 400)];
        questionTittle.frame = CGRectMake(30 + 50 + 20, questionImageView.frame.origin.y + 5, size.width, size.height);
        [self addSubview:questionTittle];
        
        UILabel *questionContent = [[UILabel alloc] init];
        questionContent.text = [NSString stringWithFormat:@"\t%@",dic[@"strQuestionContent"]];
        questionContent.font = [UIFont systemFontOfSize:15];
        size = [questionContent boundingRectWithSize:CGSizeMake(screenWIDTH - 30, 500)];
        questionContent.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        questionContent.frame = CGRectMake(15, questionImageView.frame.origin.y + 50 + 15, size.width, size.height);
        [self addSubview:questionContent];
        
        UIImageView *oimgBgLine = [[UIImageView alloc] initWithFrame:CGRectMake(15, questionContent.frame.origin.y + size.height + 20, screenWIDTH - 30, 1)];
        oimgBgLine.image = [UIImage imageNamed:@"horizontalLine"];
        [self addSubview:oimgBgLine];
        
        UIImageView *anwserImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, oimgBgLine.frame.origin.y + 20, 50, 50)];
        anwserImageView.image = [UIImage imageNamed:@"ans_img_iPad"];
        [self addSubview:anwserImageView];
        
        UILabel *anwserTittle = [[UILabel alloc] init];
        anwserTittle.text = dic[@"strAnswerTitle"];
        anwserTittle.font = [UIFont systemFontOfSize:19];
        size = [anwserTittle boundingRectWithSize:CGSizeMake(screenWIDTH - 115, 400)];
        anwserTittle.frame = CGRectMake(30 + 50 + 20, anwserImageView.frame.origin.y + 5, size.width, size.height);
        [self addSubview:anwserTittle];
        
        UILabel *anwserContent = [[UILabel alloc] init];
        NSMutableString *mutString = [NSMutableString stringWithString:dic[@"strAnswerContent"]];
        [mutString replaceCharactersInRange:NSMakeRange(mutString.length - @"</i>".length - 1, @"</i>".length) withString:@""];
        anwserContent.text = [[[[mutString componentsSeparatedByString:@"<br>"] componentsJoinedByString:@"\n\t"] componentsSeparatedByString:@"<i>"] componentsJoinedByString:@"\n"];
        anwserContent.font = [UIFont systemFontOfSize:15];
        anwserContent.text = [NSString stringWithFormat:@"\t%@",anwserContent.text];
        anwserContent.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.78];
        size = [anwserContent boundingRectWithSize:CGSizeMake(screenWIDTH - 30, 8192)];
        anwserContent.frame = CGRectMake(15, anwserTittle.frame.origin.y + 50 + 15, size.width, size.height);
        [self addSubview:anwserContent];
        
        self.labLikeCount = [[UILabel alloc] init];
        self.labLikeCount.text = [NSString stringWithFormat:@"%@",dic[@"strPraiseNumber"]];
        self.labLikeCount.font = [UIFont systemFontOfSize:12];
        size = [self.labLikeCount boundingRectWithSize:CGSizeMake(100, 20)];
        self.labLikeCount.frame = CGRectMake(0, 0, size.width, size.height);
        self.labLikeCount.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.labLikeCount.center = CGPointMake(screenWIDTH - 15 - size.width / 2.f, anwserContent.frame.origin.y + anwserContent.bounds.size.height + 20 + size.height / 2.f);
        
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
        
        self.frame = CGRectMake(0, 0, screenWIDTH, 49 + likeBgImgView.frame.origin.y + size.height);
        
        block(self);
    }];
}

- (void)like:(LikeButton *)button{
    self.labLikeCount.text = [NSString stringWithFormat:@"%ld",[self.labLikeCount.text integerValue] + (button.isLike ? -1 : 1)];
    [button setImage:[UIImage imageNamed:(button.isLike ? @"home_like_iPad" : @"home_like_hl_iPad")]
            forState:UIControlStateNormal];
    button.isLike = !button.isLike;
}



@end
