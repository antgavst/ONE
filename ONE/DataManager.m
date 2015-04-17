//
//  DataManager.m
//  ONE
//
//  Created by 、雨凡 on 15/4/6.
//  Copyright (c) 2015年 、雨凡. All rights reserved.
//

#import "DataManager.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "AppDelegate.h"
#define DBPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/dataBase.db"]
@interface DataManager()
@property (strong) NSMutableDictionary *dicURL;
@property AFHTTPRequestOperationManager *manager;
@end

@implementation DataManager
+ (id)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        self.NSUD = [NSUserDefaults standardUserDefaults];
        [self initDicURL];
        [self setAFManegaer];
    }
    return self;
}

- (void)setAFManegaer{
    self.manager = [AFHTTPRequestOperationManager manager];
    //由于有些json数据AFNetworking 需要转码，故直接用JSONKit解析json数据，发送和接受的HTTP请求全部设置为序列
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self reach];
}

- (void)dataFromMark:(NSInteger)mark andLocation:(NSInteger)location BySymbol:(NSString *)symbol succeed:(GoOn)block{
    
    NSString *key = _dicURL[[NSString stringWithFormat:@"%ld",mark]][location];
    __block NSDictionary *dic = [self.NSUD objectForKey:key];
    if (dic.count > 0){
//        NSLog(@"数据来自本地。");
        block(dic);
    }else{
        [_manager GET:key parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dic = [responseObject objectFromJSONData];
//            NSLog(@"数据来自网络。");
            [self store:dic andKey:key];
            block(dic);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"\n你的请求已消失在异次元空间~~~\nerror is--->%@",error);
        }];
    }
}

- (void)store:(id)something andKey:(NSString *)key{
    NSMutableArray *arrDataKey = [NSMutableArray arrayWithArray:[self.NSUD objectForKey:@"arrDataKey"]];
    [arrDataKey addObject:key];
    [self.NSUD setObject:arrDataKey forKey:@"arrDataKey"];
    [self.NSUD setObject:something forKey:key];
    [self.NSUD synchronize];
}

- (void)dataFromURLString:(NSString *)URLString success:(GoOn)success{
    NSString *key = URLString;
    __block NSDictionary *dic = [self.NSUD objectForKey:key];
    if (dic.count > 0) {
//        NSLog(@"数据来自本地。");
        success(dic);
    }else{
        [_manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dic = [responseObject objectFromJSONData];
//            NSLog(@"数据来自网络。");
            [self store:dic andKey:key];
            success(dic);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"\n你的请求已消失在异次元空间~~~\nerror is--->%@",error);
        }];
    }
}

//监测网络环境
- (void)reach{
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    [reachability startMonitoring];
    
    //网络变化回调
    [reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [self performSelectorOnMainThread:@selector(note:) withObject:[self switchNetStatus:status] waitUntilDone:NO];
    }];
}
// 网络提示！
- (void)note:(NSString *)message{
    
    NSLog(@"%@",message);
    
}

//筛选网络状态
- (NSString *)switchNetStatus:(AFNetworkReachabilityStatus)status{
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            return @"未知网络！你此刻难道身处神秘星球？";
            break;
        case AFNetworkReachabilityStatusNotReachable:
            return @"Oh,my God,世界上最痛苦的事情莫过于---没网了！";
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return @"当前网络为手机移动网络！流量需要精打细算哟。";
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return @"当前网络为WiFi，流量神马的都是浮云！";
            break;
        default:
            return nil;
            break;
    }
}

- (void)initDicURL{
    self.dicURL = [NSMutableDictionary dictionary];
    NSArray *temp = @[welcomeURLString,homepageURLString, articleURLString, QandAURLString, goodsURLString];
    // 首页mark为1
    for (int i = 1; i < temp.count; ++i) {
        [_dicURL setObject:[self createURL:temp[i]]
                    forKey:[NSString stringWithFormat:@"%d",i]];
    }
}

- (NSArray *)createURL:(NSString *)URLString{
    NSDateFormatter *dateFat = [[NSDateFormatter alloc] init];
    [dateFat setDateFormat:@"yyyy-MM-dd"];
    NSDate *date;
    NSString *dateString;
    NSArray *temp = [URLString componentsSeparatedByString:@"2015-03-24"];
    NSMutableArray *arrayTarget = [NSMutableArray array];
    for (int i = 0; i < 10; ++i) {
        date = [NSDate dateWithTimeIntervalSinceNow:-24 * 60 * 60 * i];
        dateString = [dateFat stringFromDate:date];
        dateString = [NSString stringWithFormat:@"%@%@%@",temp[0],dateString,temp[1]];
        [arrayTarget addObject:dateString];
    }
    return arrayTarget;
}




@end
