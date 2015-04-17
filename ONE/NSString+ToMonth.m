//
//  NSString+ToMonth.m
//  ONE
//
//  Created by 、雨凡 on 15/3/27.
//  Copyright (c) 2015年 、雨凡. All rights reserved.
//

#import "NSString+ToMonth.h"

@implementation NSString (ToMonth)
- (NSString *)toMonthAllOrNot:(BOOL)allOrNot{
    NSArray *array;
    if (allOrNot) {
        array = @[@"Janurary",@"February",@"March",@"April",@"May",@"June",
                  @"July",@"August",@"September",@"October",@"November",@"December"];
    }else{
        array = @[@"Jan,",@"Feb,",@"Mar,",@"Apr,",@"May,",@"Jun,",
                  @"Jul,",@"Aug,",@"Sep,",@"Oct,",@"Nov,",@"Dec,"];
    }
    return array[[self integerValue]-1];
}

- (NSString *)toDate{
    NSArray *array = [self componentsSeparatedByString:@"-"];
    return [NSString stringWithFormat:@"%@ %@, %@",[array[1] toMonthAllOrNot:YES],array[2],array[0]];
}

@end
