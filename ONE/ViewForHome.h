//
//  ViewForHome.h
//  ONE_XIB
//
//  Created by 、雨凡 on 15/3/30.
//  Copyright (c) 2015年 、雨凡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LikeButton.h"
typedef void (^succeed)(UIView *view);
@interface ViewForHome : UIView{
@public
    NSDictionary *dic;
}
@property (strong) LikeButton *btnLike;
@property (strong) UILabel *labLikeCount;
@property (nonatomic) NSString * symbol;
@property NSInteger mark;
@property NSInteger location;
-(instancetype)initWithMark:(NSInteger)mark andLocation:(NSInteger)location BySymbol:(NSString *)symbol;
- (void)configSucceed:(succeed)block;
@property UIImageView * workImgView;
@end
