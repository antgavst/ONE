//
//  ONETabBarController.m
//  ONE
//
//  Created by 、雨凡 on 15/3/31.
//  Copyright (c) 2015年 、雨凡. All rights reserved.
//

#import "ONETabBarController.h"
#import "MineViewController.h"
#import "CommonViewController.h"

@interface ONETabBarController ()
@property BOOL isOriginal;
@property CGFloat lastScale;
@property (nonatomic, strong) NSMutableArray *imgNlArray;
@property (nonatomic, strong) NSMutableArray *imgHlArray;
@property CGFloat maxScale;
@property (assign) CGSize itemSize;
@property (strong) UIButton *lastButton;
@end

@implementation ONETabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabBar];
}


- (void)showAD{
    _bgImgView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:_bgImgView];
    __weak ONETabBarController *vf = self;
    DataManager *DM = [DataManager sharedManager];
    [DM dataFromURLString:ADURL success:^(id dicData) {
        NSString *key = dicData[@"str800480Url"];
        UIImage *adIMG = [UIImage imageWithData:[DM.NSUD objectForKey:key]];
        if (adIMG) {
            vf.bgImgView.image = adIMG;
            [UIView animateKeyframesWithDuration:2 delay:3 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
                vf.bgImgView.alpha = 0;
            } completion:^(BOOL finished) {
                if (finished) {
                    [vf.bgImgView removeFromSuperview];
                }
            }];
        }else{
            [_bgImgView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:key]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                vf.bgImgView.image = image;
                [UIView animateKeyframesWithDuration:2 delay:2 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
                    vf.bgImgView.alpha = 0;
                } completion:^(BOOL finished) {
                    if (finished) {
                        [vf.bgImgView removeFromSuperview];
                    }
                }];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
//                NSLog(@"广告加载失败！噢耶！");
                NSLog(@"%@",error);
            }];
        }
    }];
}



- (void)initTabBar{
    [self.tabBar removeFromSuperview];
    _itemSize = CGSizeMake(screenWIDTH / 5.f, 49);
    _customTabbarView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, screenHEIGHT - _itemSize.height, screenWIDTH, _itemSize.height)];
    [self.view addSubview:_customTabbarView];
    _customTabbarView.backgroundColor =[UIColor colorWithRed:234 / 255.0 green:234 / 255.0 blue:234 / 255.0 alpha:1];
    
    [self initImageArray];
    UIImage *img;
    UIButton *barItem;
    for (int i = 0; i < 5; ++i) {
        barItem = [UIButton buttonWithType:UIButtonTypeCustom];
        barItem.frame = CGRectMake(_itemSize.width * i - 1, 0, _itemSize.width, _itemSize.height);
        barItem.tag = i + 1;
        if (i == 0) {
            _lastButton = barItem;
            img = _imgHlArray[i];
        }else{
            img = _imgNlArray[i];
        }
        
        [barItem setBackgroundImage:img forState:UIControlStateNormal];
        [barItem setBackgroundImage:img forState:UIControlStateHighlighted];
        [barItem addTarget:self action:@selector(onClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.customTabbarView addSubview:barItem];
    }
    [self initViewControllers];
}

- (void)onClicked:(UIButton *)barItem{
    if (_lastButton != barItem) {
        [barItem setBackgroundImage:_imgHlArray[barItem.tag - 1] forState:UIControlStateNormal];
        [_lastButton setBackgroundImage:_imgNlArray[_lastButton.tag - 1] forState:UIControlStateNormal];
        _lastButton = barItem;
    }
    self.selectedIndex = barItem.tag - 1;
}

- (void)initViewControllers{
    NSMutableArray *arrayNav = [NSMutableArray array];
    NSMutableArray *arrVC = [NSMutableArray array];
    for (int i = 1; i < 5; ++i) {
        CommonViewController *vc = [[CommonViewController alloc] initWithMark:i];
        [arrVC addObject:vc];
    }
    MineViewController *mine = [[MineViewController alloc] init];
    [arrVC addObject:mine];
    for (int i = 0; i < 5; ++i) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:arrVC[i]];
        [arrayNav addObject:nav];
    }
    self.viewControllers = arrayNav;
}


- (void)initImageArray{
    _imgNlArray = [NSMutableArray array];
    _imgHlArray = [NSMutableArray array];
    NSArray *array;
    //    正常
    array = @[@"home", @"content", @"question", @"things", @"personal"];
    [self initImgArray:_imgNlArray ByArray:array];
    
    //    高亮
    array = @[@"home_hl", @"content_hl", @"question_hl", @"things_hl", @"personal_hl"];
    [self initImgArray:_imgHlArray ByArray:array];
}

- (void)initImgArray:(NSMutableArray *)mutArray ByArray:(NSArray *)array{
    for (int i = 0; i < 5; ++i) {
        [mutArray addObject:[UIImage reSizeImage:[UIImage imageNamed:array[i]] toSize:_itemSize]];
    }
}


- (void)share{
    //暗色蒙版
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWIDTH, screenHEIGHT)];
    _bgView.backgroundColor = [UIColor clearColor];
    _bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(exit)];
    [_bgView addGestureRecognizer:gesture];
    [self.view addSubview:_bgView];
    [UIView animateWithDuration:1 animations:^{
        _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }];
    
    
    //分享模板的载体UIView
    _menu = [[UIView alloc] initWithFrame:CGRectMake(0, screenHEIGHT, screenWIDTH, screenHEIGHT / 2.f - 20)];
    _menu.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    [self.view addSubview:_menu];
    
    //分享到标题
    UILabel *shareTittle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, screenWIDTH, 20)];
    shareTittle.text = @"分享到";
    shareTittle.textAlignment = NSTextAlignmentCenter;
    shareTittle.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    [_menu addSubview:shareTittle];
    
    NSArray *arrimg = @[@"share_sina",@"share_wc",@"share_timeline"];
    NSArray *arrTittle = @[@"新浪微博",@"微信好友",@"微信朋友圈"];
    CGSize size;
    for (int i = 0; i < 3; ++i) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(screenWIDTH / 2.f - 53 / 2.f - 20 - 53 + (53 + 20) * i, shareTittle.center.y + shareTittle.bounds.size.height / 2.f + 20, 53, 53);
        [button setImage:[UIImage imageNamed:arrimg[i]] forState:UIControlStateNormal];
        button.tag = i + 1;
        [button addTarget:self action:@selector(shareDo:) forControlEvents:UIControlEventTouchUpInside];
        [_menu addSubview:button];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = arrTittle[i];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        size = [label boundingRectWithSize:CGSizeMake(100, 100)];
        label.frame = CGRectMake(0, 0, size.width, size.height);
        label.center = CGPointMake(button.center.x, button.center.y + 53 / 2.f + 15);
        [_menu addSubview:label];
    }
    
    //分隔线
    UIImageView *lineUp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"horizontalLine"]];
    lineUp.frame = CGRectMake(20, shareTittle.frame.origin.y + shareTittle.bounds.size.height + 20 + 53 + 15 + size.height + 10, screenWIDTH - 40, 1);
    [_menu addSubview:lineUp];
    
    arrimg = @[@"share_col", @"share_night", @"share_disc", @"share_save"];
    arrTittle = @[@"加入收藏", @"夜间模式", @"论坛讨论", @"保存图片"];
    //53 * 4 + 20 * 3
    //
    //保存图片
    for (int i = 0; i < 4; ++i) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(73 * i + (screenWIDTH - 73 * 3 - 53) / 2.f, lineUp.frame.origin.y + 1 + 20, 53, 53);
        [button setImage:[UIImage imageNamed:arrimg[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(shareDo:) forControlEvents:UIControlEventTouchUpInside];
        [_menu addSubview:button];
        button.tag = i + 10;
        
        UILabel *label = [[UILabel alloc]init];
        label.text = arrTittle[i];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        size = [label boundingRectWithSize:CGSizeMake(100, 100)];
        label.frame = CGRectMake(0, 0, size.width, size.height);
        label.center = CGPointMake(button.center.x, button.center.y + 53 / 2.f + 15);
        [_menu addSubview:label];
    }
    
    //分隔线
    UIImageView *lineDown = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"horizontalLine"]];
    lineDown.frame = CGRectMake(20, lineUp.frame.origin.y + 1 + 20 + 53 + 15 + size.height + 10, screenWIDTH - 40, 1);
    [_menu addSubview:lineDown];
    
    //取消
    UIButton *btnExit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnExit.tag = 119;
    [btnExit addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    [btnExit setTitle:@"取消" forState:UIControlStateNormal];
    btnExit.frame = CGRectMake(0, 0, 50, 50);
    btnExit.titleLabel.font = [UIFont systemFontOfSize:20];
    [btnExit setTitleColor:[UIColor colorWithRed:40 / 255.0 green:181 / 255.0 blue:241 / 255.0 alpha:1] forState:UIControlStateNormal];
    btnExit.center = CGPointMake(screenWIDTH / 2.f, lineDown.frame.origin.y + 1 + (_menu.bounds.size.height - (lineDown.frame.origin.y + 1)) / 2.f);
    [_menu addSubview:btnExit];
    
    [UIView animateWithDuration:0.618 animations:^{
        _menu.center = CGPointMake(_menu.center.x, _menu.center.y - _menu.bounds.size.height);
    } completion:^(BOOL finished) {
        [self hiddenTabBaeView];
    }];
}

- (void)exit{
    [UIView animateWithDuration:0.618 animations:^{
        _menu.center = CGPointMake(_menu.center.x, _menu.center.y + _menu.bounds.size.height);
        _bgView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        if (finished) {
            [_menu removeFromSuperview];
            [_bgView removeFromSuperview];
        }
        [self showTabView];
    }];
}

- (void)shareDo:(UIButton *)button{
    switch (button.tag) {
        case 1:{
            //跳转到新浪微博APP
            
        }
            break;
        case 2:{
            //跳转到微信APP向好友发送分享
            
        }
            break;
        case 3:{
            //跳转到微信APP发表到好友圈
            
        }
            break;
        case 10:{
            //加入收藏
            
        }
            break;
        case 11:{
            //夜间或者白日模式
            
        }
            break;
        case 12:{
            //跳转到网页论坛  http://wufazhuce.org/
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://wufazhuce.org/"]];
        }
            break;
        case 13:{
            //显示设置：保存图片或者改变字体大小和屏幕亮度
            
        }
            break;
        default:
            [self exit];
            break;
    }
}

- (void)displayImg:(UIImage *)img{
    _isOriginal = YES;
    _lastScale = 1.f;
    _maxScale = screenHEIGHT * .8f / (screenWIDTH * .75f);
    [self.view addSubview:[[UIView alloc] init]];
    
    _bgScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _bgImgView.center = CGPointMake(screenWIDTH / 2.f, screenHEIGHT / 2.f);
    [self.view addSubview:_bgScrollView];
    [_bgScrollView addSubview:_bgImgView];
    
    _bgScrollView.userInteractionEnabled = YES;
    _bgScrollView.contentMode = UIViewContentModeCenter;
    _bgScrollView.backgroundColor = [UIColor clearColor];
    [_bgImgView setImage:img];
    
    
    [UIView animateWithDuration:0.382f animations:^{
        _bgScrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.618];
        _bgImgView.frame = CGRectMake(0, 0, screenWIDTH, screenWIDTH * .75f);
        _bgImgView.center = CGPointMake(screenWIDTH / 2.f, screenHEIGHT / 2.f);
    }];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
    tap.numberOfTapsRequired = 1;
    [_bgScrollView addGestureRecognizer:tap];
    
    //双击
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
    doubleTap.numberOfTapsRequired = 2;
    [_bgScrollView addGestureRecognizer:doubleTap];
    [tap requireGestureRecognizerToFail:doubleTap];//优先响应双击
    
    //缩放
    _bgScrollView.delaysContentTouches = NO;
    _bgScrollView.multipleTouchEnabled = YES;
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchEvent:)];
    [_bgScrollView addGestureRecognizer:pinchGesture];
}

- (void)pinchEvent:(UIPinchGestureRecognizer *)pich{
    _lastScale *= pich.scale;
    _bgImgView.transform = CGAffineTransformScale(_bgImgView.transform, pich.scale, pich.scale);
    pich.scale = 1;
    if (pich.state == UIGestureRecognizerStateEnded) {
        if (_lastScale > _maxScale) {
            _isOriginal = YES;
            [self doubleTap];
            _lastScale = _maxScale;
        }else if (_lastScale < 1){
            _isOriginal = NO;
            [self doubleTap];
        }
    }
}

- (void)singleTap{
    [UIView animateWithDuration:0.382f animations:^{
        _bgScrollView.alpha = 0;
        _bgImgView.frame = CGRectMake(0, 0, 0, 0);
        _bgImgView.center = CGPointMake(_bgScrollView.contentOffset.x + screenWIDTH / 2.f, _bgScrollView.contentOffset.y + screenHEIGHT / 2.f);
    }completion:^(BOOL finished) {
        if (finished) {
            [_bgScrollView removeFromSuperview];
        }
    }];
}

- (void)doubleTap{
    if (_isOriginal) {
        [UIView animateWithDuration:0.382 animations:^{
            _bgScrollView.contentSize = CGSizeMake(screenWIDTH * _maxScale, screenHEIGHT * 1.2f);
            _bgScrollView.contentOffset = CGPointMake((_bgScrollView.contentSize.width - screenWIDTH) / 2.f, (_bgScrollView.contentSize.height - screenHEIGHT) / 2.f);
            _bgImgView.frame = CGRectMake(0, 0, screenWIDTH * _maxScale, screenWIDTH * _maxScale  * .75f);
            _bgImgView.center = CGPointMake(_bgScrollView.contentSize.width / 2.f, _bgScrollView.contentSize.height / 2.f);
            
        }];
    }else{
        [UIView animateWithDuration:0.382f animations:^{
            _bgScrollView.contentSize = [UIScreen mainScreen].bounds.size;
            _bgImgView.frame = CGRectMake(0, 0, screenWIDTH, screenWIDTH * .75f);
            _bgImgView.center = CGPointMake(screenWIDTH / 2.f, screenHEIGHT / 2.f);
        }];
    }
    _isOriginal = !_isOriginal;
}


- (void)hiddenTabBaeView{
    _customTabbarView.frame =CGRectMake(self.view.bounds.origin.x, screenHEIGHT, screenWIDTH, _itemSize.height);
}

- (void)showTabView{
    [UIView animateWithDuration:0.5 animations:^{
        self.customTabbarView.frame = CGRectMake(self.view.bounds.origin.x, screenHEIGHT - _itemSize.height, screenWIDTH, _itemSize.height);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
