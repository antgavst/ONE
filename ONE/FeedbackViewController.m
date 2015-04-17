//
//  FeedbackViewController.m
//  ONE
//
//  Created by 、雨凡 on 15/4/4.
//  Copyright (c) 2015年 、雨凡. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()
@property (weak, nonatomic) IBOutlet UITextView *feedbackContent;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _feedbackContent.layer.borderWidth = 1;
    _feedbackContent.layer.borderColor = [UIColor colorWithRed:194 / 255.0 green:194 / 255.0 blue:194 / 255.0 alpha:0.5].CGColor;
    _feedbackContent.layer.cornerRadius = 10;
    _feedbackContent.textColor = [UIColor redColor];
}
- (IBAction)submit:(id)sender {
    _feedbackContent.text = @"当点击提交反馈按钮后，将会发出请求，内容是： emil（明文）+手机号码（明文）+反馈内容（用百分编码）,隐私就是这样暴露的么？";
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
