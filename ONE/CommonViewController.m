//
//  OneToThreeViewController.m
//  ONE
//
//  Created by 、雨凡 on 15/4/6.
//  Copyright (c) 2015年 、雨凡. All rights reserved.
//

#import "CommonViewController.h"
#import "ViewForHome.h"
#import "ViewForArticle.h"
#import "ViewForQuestion.h"
#import "ViewForThings.h"
#import "ONETabBarController.h"
@interface CommonViewController ()
@property (nonatomic, strong) NSDictionary *dicData;
@property UIActivityIndicatorView *load;
@property NSInteger dataMark;
@property NSArray *arrSymbol;
@property NSMutableArray *urlArrForWorkImg;
@end

@implementation CommonViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavgationBar];//需要修改
    [self configMainScrollView];
}

- (id)initWithMark:(NSInteger)mark{
    // 首页mark为1
    if (self = [super init]) {
        self.dataMark = mark;
        _urlArrForWorkImg = [NSMutableArray array];
        self.arrSymbol = @[@"hpEntity", @"contentEntity", @"questionAdEntity", @"entTg"];
    }
    return self;
}

- (void)configMainScrollView{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screenWIDTH, screenHEIGHT - 64 - 49)];
    _mainScrollView.contentSize = CGSizeMake(screenWIDTH * 10, screenHEIGHT - 64 - 49);
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_mainScrollView];
    [self configSubScroll];
}

- (void)configSubScroll{
    for (int i = 0; i < 10; ++i) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(screenWIDTH * i, 0, screenWIDTH, screenHEIGHT - 64 - 49)];
        [_mainScrollView addSubview:scrollView];
        switch (_dataMark) {
                
            case 1:{
                [[[ViewForHome alloc] initWithMark:_dataMark andLocation:i BySymbol:_arrSymbol[0]] configSucceed:^(UIView *view){
                    scrollView.contentSize = CGSizeMake(screenWIDTH, view.frame.size.height);
                    [scrollView addSubview:view];
                    [_mainScrollView addSubview:scrollView];
                    
                    ViewForHome *VFH = (ViewForHome *)view;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
                    [VFH.workImgView addGestureRecognizer:tap];
                }];
            }
                break;
                
            case 2:{
                [[[ViewForArticle alloc] initWithMark:_dataMark andLocation:i BySymbol:_arrSymbol[1]] configSucceed:^(UIView *view) {
                    scrollView.contentSize = CGSizeMake(screenWIDTH, view.frame.size.height);
                    [scrollView addSubview:view];
                    [_mainScrollView addSubview:scrollView];
                }];
            }
                break;
                
            case 3:{
                [[[ViewForQuestion alloc] initWithMark:_dataMark andLocation:i BySymbol:_arrSymbol[2]] configSucceed:^(UIView *view) {
                    scrollView.contentSize = CGSizeMake(screenWIDTH, view.frame.size.height);
                    [scrollView addSubview:view];
                    [_mainScrollView addSubview:scrollView];
                }];
            }
                break;
                
            case 4:{
                [[[ViewForThings alloc] initWithMark:_dataMark andLocation:i BySymbol:_arrSymbol[3]] configSucceed:^(UIView *view) {
                    scrollView.contentSize = CGSizeMake(screenWIDTH, view.frame.size.height);
                    [scrollView addSubview:view];
                    [_mainScrollView addSubview:scrollView];
                }];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap{
    ONETabBarController *one = (ONETabBarController *)self.tabBarController;
    [one displayImg:((UIImageView *)tap.view).image];
}

- (void)loadTip{
    _load = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _load.color = [UIColor colorWithRed:11 / 255.0 green:96 / 255.0 blue:254 / 255.0 alpha:1];//RGB,11,96,254
    [_load startAnimating];
    _load.center = CGPointMake(screenWIDTH / 2.f, screenHEIGHT / 2.f);
    [self.view addSubview:_load];
}
- (void)stopTip{
    [_load removeFromSuperview];
}

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
    [button addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:button];
}

- (void)Login:(UIButton *)button{
    ONETabBarController *oneTabBarVC = (ONETabBarController *)self.tabBarController;
    [oneTabBarVC share];
    
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
