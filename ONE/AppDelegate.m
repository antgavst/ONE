//
//  AppDelegate.m
//  ONE
//
//  Created by 、雨凡 on 15/4/7.
//  Copyright (c) 2015年 、雨凡. All rights reserved.
//



#import "AppDelegate.h"
#import "ONETabBarController.h"
#define UMKey @"55221413fd98c51975000935"
#define shareSDKKey @"5f074b37e660"
#define AppKEY @"26338863"
#define AppSecret @"396c76427965a71ca7ce8d28efce6fe3"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [[ONETabBarController alloc] init];
    [self showAD];
    [self shareByUM];
    
    
    //        [self cachePolicy];
    //        [self shareByShareSDK];
    
    return YES;
}

//判断是否是第一次运行，并数据记录持久化
- (BOOL)isFirstRunning{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstRunning"]) {
        return NO;
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:@"😄" forKey:@"isFirstRunning"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSMutableArray array] forKey:@"arrDataKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
}



- (void)shareByShareSDK{
    [ShareSDK registerApp:shareSDKKey];
    [ShareSDK connectSinaWeiboWithAppKey:AppKEY appSecret:AppSecret redirectUri:@"http://my.oschina.net/zdiovo"];
//    [NSUserDefaults standardUserDefaults]
}

- (void)shareByUM{
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UMKey];
    
    //打开调试log的开关
    //    [UMSocialData openLog:YES];
    
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
}

- (void)cachePolicy{
    [NSURLCache setSharedURLCache:[[NSURLCache alloc]initWithMemoryCapacity:10 * 1024 * 1024 diskCapacity:100 * 1024 * 1024 diskPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/"]]]];
}


- (void)showAD{
    DataManager *DM = [DataManager sharedManager];
    if ([self isFirstRunning]) {
        [DM dataFromURLString:ADURL success:^(id dicData) {
            NSString *key = dicData[@"str800480Url"];
            [[[UIImageView alloc] init] setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:key]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                [DM store:UIImageJPEGRepresentation(image, 1) andKey:key];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                NSLog(@"%@",error);
            }];
        }];
    }else{
        UIImageView *imgViewAD = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.window addSubview:imgViewAD];
        __weak UIImageView *AD = imgViewAD;
        
        [DM dataFromURLString:ADURL success:^(id dicData) {
            NSString *key = dicData[@"str800480Url"];
            UIImage *adIMG = [UIImage imageWithData:[DM.NSUD objectForKey:key]];
            if (adIMG) {
                AD.image = adIMG;
                [UIView animateKeyframesWithDuration:2 delay:3 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
                    AD.alpha = 0;
                } completion:^(BOOL finished) {
                    if (finished) {
                        [AD removeFromSuperview];
                    }
                }];
            }else{
                [AD setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:key]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    AD.image = image;
                    [UIView animateKeyframesWithDuration:2 delay:2 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
                        AD.alpha = 0;
                    } completion:^(BOOL finished) {
                        if (finished) {
                            [AD removeFromSuperview];
                        }
                    }];
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                    //                NSLog(@"广告加载失败！噢耶！");
                    NSLog(@"%@",error);
                }];
            }
        }];
    }
}




/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
//}

/**
 这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //    [UMSocialSnsService  applicationDidBecomeActive];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
//
//- (void)applicationDidBecomeActive:(UIApplication *)application {
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
