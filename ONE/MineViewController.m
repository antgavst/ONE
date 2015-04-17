//
//  MineViewController.m
//  ONE
//
//  Created by 、雨凡 on 15/3/31.
//  Copyright (c) 2015年 、雨凡. All rights reserved.
//

#import "MineViewController.h"
#import "MineCell.h"
#import "ADCell.h"
#import "UIImageView+AFNetworking.h"
#import "SettingViewController.h"
#import "ONETabBarController.h"
#import "AppDelegate.h"
@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>
@property UITableView *table;
@property NSArray *imgData;
@property NSArray *tittleData;
@property BOOL isOauth;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavgationbar];
    [self initTable];
}

- (void)initNavgationbar{
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    UIImageView *aImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80 / 117.f * 36)];
    aImgView.center = CGPointMake(screenWIDTH / 2.0, 20);
    aImgView.image = [UIImage imageNamed:@"logo_iPad"];
    [self.navigationController.navigationBar addSubview:aImgView];
}

- (void)initTable{
    _tittleData = @[@"欢迎加入", @"设置", @"关于"];
    _imgData = @[@"p_notLogin", @"setting", @"copyright"];
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWIDTH, screenHEIGHT) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    [_table registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:@"Mine"];
    [_table registerNib:[UINib nibWithNibName:@"ADCell" bundle:nil] forCellReuseIdentifier:@"AD"];
    _table.separatorInset = UIEdgeInsetsZero;
    _table.layoutMargins = UIEdgeInsetsZero;
    [self.view addSubview:_table];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        //跳转到Appstore
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://appsto.re/cn/7ZM4O.i"]];
        //在真机此处连接的https应改为itms-apps或者itms
        return;
    }
    if (indexPath.row == 0) {
        if (!_isOauth) {
//            [self callOauthFromShareSDKWith:indexPath];
            
            //UMeng不知道在哪儿修改appkey，appscrect
            [self callOauth:indexPath];
        }else{
            
        }
    }else{
        //隐藏tabbarView
        [self hiddenTabBaeView];
        if (indexPath.row == 1) {
            //跳转到设置页面
            SettingViewController *settingVC = [[SettingViewController alloc] init];
            [self.navigationController pushViewController:settingVC animated:YES];
            
        }
        if (indexPath.row == 2) {
            //跳转到制作团队
            UIViewController *aboutVC = [[UIViewController alloc] init];
            UIImageView *aboutImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, screenWIDTH, screenHEIGHT-64)];
            [aboutImgView setImageWithURL:[NSURL URLWithString:@"http://pic.yupoo.com/hanapp/EtrTKRtz/tyMuI.png"]];
            [aboutVC.view addSubview:aboutImgView];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
    }
    
}

- (void)callOauthFromShareSDKWith:(NSIndexPath *)indexPath{
//    AGAppDelegate *appDelegate = (AGAppDelegate *)[UIApplication sharedApplication].delegate;
//    NSDictionary *item = @{@"type":[ShareSDK connectedPlatformTypes][0]};
//    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
//                                                         allowCallback:YES
//                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
//                                                          viewDelegate:nil
//                                               authManagerViewDelegate:appDelegate.viewDelegate];
//    
//    //在授权页面中添加关注官方微博
//    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                    SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                    nil]];
//    
//    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
//                      authOptions:authOptions
//                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
//                               if (result)
//                               {
//                                   
//                                   NSLog(@"userInfo%@",userInfo);
//                                   
//                                   [item setObject:[userInfo nickname] forKey:@"username"];
//                                   [_shareTypeArray writeToFile:[NSString stringWithFormat:@"%@/authListCache.plist",NSTemporaryDirectory()] atomically:YES];
//                               }
//                               NSLog(@"%ld:%@",(long)[error errorCode], [error errorDescription]);
//                           }];
//}
//
//    //取消授权
//    [ShareSDK cancelAuthWithType:(ShareType)[[item objectForKey:@"type"] integerValue]];
//    [_tableView reloadData];
//
//
//

}

- (void)callOauth:(NSIndexPath *)indexPath{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"使用新浪微博一键登录体验更多功能，现在就去？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        //跳转到微博授权
        [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
        
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                NSLog(@"%@",snsAccount);
                NSLog(@"username is %@, uid is %@, token is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken);
                MineCell *cell = (MineCell *)[_table cellForRowAtIndexPath:indexPath];
                cell.tittle.text = snsAccount.userName;
                [cell.img setImageWithURL:[NSURL URLWithString:snsAccount.iconURL]];
                cell.img.layer.cornerRadius = cell.img.frame.size.width / 2.f;
                cell.img.clipsToBounds = YES;
                _isOauth = YES;
            }
        });
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)hiddenTabBaeView{
    ONETabBarController *one = (ONETabBarController *)self.tabBarController;
    [one hiddenTabBaeView];
}

- (void)viewWillAppear:(BOOL)animated{
    ONETabBarController *one = (ONETabBarController *)self.tabBarController;
    [one showTabView];
}

//如果没有授权，提示授权
//如果已授权显示我的收藏


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 2.f;
    }
    return 20.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }
    return 1;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }
    return 79;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MineCell *cell = [_table dequeueReusableCellWithIdentifier:@"Mine"];
        cell.img.image = [UIImage imageNamed:_imgData[indexPath.row]];
        cell.tittle.text = _tittleData[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    ADCell *cell = [_table dequeueReusableCellWithIdentifier:@"AD"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"  推荐应用";
    }
    return nil;
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
