//
//  SettingViewController.m
//  ONE
//
//  Created by 、雨凡 on 15/4/2.
//  Copyright (c) 2015年 、雨凡. All rights reserved.
//

#import "SettingViewController.h"
#import "WithSwitchCell.h"
#import "AboutMoreCell.h"
#import "FeedbackViewController.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>
@property UITableView *table;
@property NSDictionary *dicTableData;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTable];
}

- (void)initTable{
    [self initTableData];
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWIDTH, screenHEIGHT) style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.dataSource = self;
    [_table registerNib:[UINib nibWithNibName:@"AboutMoreCell" bundle:nil] forCellReuseIdentifier:@"AboutMoreCell"];
    [_table registerNib:[UINib nibWithNibName:@"WithSwitchCell" bundle:nil] forCellReuseIdentifier:@"WithSwitchCell"];
    [self.view addSubview:_table];

}

- (void)initTableData{
    _dicTableData = @{@"section0":@[@"夜间模式切换"], @"section1":@[@"下次启动清除缓存列表",@"下次启动清除图片缓存"], @"section2":@[@"重新验证新浪微博"],@"section3":@[@"去评分", @"关注我们", @"反馈", @"版本号"], @"sectionTittle":@[@"浏览设置", @"缓存设置", @"账号设置", @"更多"]};
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section >2) {
        AboutMoreCell *cell = [_table dequeueReusableCellWithIdentifier:@"AboutMoreCell"];
        cell.tittle.text = _dicTableData[@"section3"][indexPath.row];
        if (indexPath.row > 2) {
            //设置版本号
            cell.version.text = @"2.3.1";
            return cell;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }else{
        WithSwitchCell *cell = [_table dequeueReusableCellWithIdentifier:@"WithSwitchCell"];
        [cell initite:[NSString stringWithFormat:@" %@",_dicTableData[[NSString stringWithFormat:@"section%ld",indexPath.section]][indexPath.row]]];
        cell.configEvent = ^(BOOL switchState){
            [self configCellEvent:indexPath];
        };
        return cell;
    }
}

- (void)configCellEvent:(NSIndexPath *)index{
// 四个开关的事件！
    NSLog(@"四个开关的事件！");
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section > 2) {
        switch (indexPath.row) {
            case 0:
                //去评分，连接到AppStore（ONE所在页面）
                
                break;
            case 1:
                //关注我们
                
                break;
            case 2:
                //反馈
                [self feedBack];
                break;
            default:
                //do nothing
                break;
        }
    }
}

- (void)feedBack{
    FeedbackViewController *feedback = [[FeedbackViewController alloc]initWithNibName:@"FeedbackViewController" bundle:nil];
    [self.navigationController pushViewController:feedback animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 2;
        case 2:
            return 1;
        default:
            return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _dicTableData[@"sectionTittle"][section];
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
