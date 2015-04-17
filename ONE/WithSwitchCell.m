//
//  WithSwitchCell.m
//  ONE
//
//  Created by 、雨凡 on 15/4/2.
//  Copyright (c) 2015年 、雨凡. All rights reserved.
//

#import "WithSwitchCell.h"

@implementation WithSwitchCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)initite:(NSString *)tittle{
// 待续
//    _onOrOff setOn:<#(BOOL)#> animated:<#(BOOL)#>
    _tittle.text = tittle;
}

- (IBAction)valueChangeToDo:(UISwitch *)sender {
    if (_configEvent) {
        _configEvent(sender.isOn);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
