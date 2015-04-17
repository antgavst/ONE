//
//  DataManager.h
//  ONE
//
//  Created by 、雨凡 on 15/4/6.
//  Copyright (c) 2015年 、雨凡. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^GoOn)(id dicData);
@interface DataManager : NSObject
@property NSUserDefaults *NSUD;
+ (id)sharedManager;
- (void)store:(id)something andKey:(NSString *)key;
- (void)dataFromURLString:(NSString *)URLString success:(GoOn)success;
- (void)dataFromMark:(NSInteger)mark andLocation:(NSInteger)location BySymbol:(NSString *)symbol succeed:(GoOn)block;
@end
