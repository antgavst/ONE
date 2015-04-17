//
//  CustomURLCache.h
//  ONE
//
//  Created by 、雨凡 on 15/4/14.
//  Copyright (c) 2015年 、雨凡. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomURLCache : NSURLCache
+ (instancetype)standardURLCache;
- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request ;
- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse
                 forRequest:(NSURLRequest *)request;
@end
