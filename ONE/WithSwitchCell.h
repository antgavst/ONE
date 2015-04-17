//
//  WithSwitchCell.h
//  ONE
//
//  Created by 、雨凡 on 15/4/2.
//  Copyright (c) 2015年 、雨凡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WithSwitchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *onOrOff;
@property (weak, nonatomic) IBOutlet UILabel *tittle;
@property (copy) void (^configEvent)(BOOL switchState);
- (void)initite:(NSString *)tittle;
@end
