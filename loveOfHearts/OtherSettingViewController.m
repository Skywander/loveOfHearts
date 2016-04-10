//
//  OtherSettingViewController.m
//  爱之心
//
//  Created by 于恩聪 on 15/9/4.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "OtherSettingViewController.h"
#import "Constant.h"
#import "Navigation.h"
#import "OtherSettingFactory.h"
#import "Command.h"

@interface OtherSettingViewController ()
{
    UITableView *listView;
    
    CGFloat heightForView;
    CGFloat widthForView;
    
    UIView *clickCellView;
}
@end
@implementation OtherSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void) initUI {
    [self.view setBackgroundColor:DEFAULT_COLOR];
    
    //列表
    listView = [[UITableView alloc] initWithFrame:CGRectMake(3, 34, SCREEN_WIDTH - 6, SCREEN_HEIGHT - 30) style:UITableViewStyleGrouped];
    listView.scrollEnabled = NO;
    [listView setBackgroundColor:DEFAULT_COLOR];
    listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listView.showsHorizontalScrollIndicator = NO;
    listView.showsVerticalScrollIndicator = NO;
    listView.dataSource = self;
    listView.delegate = self;
    [self.view addSubview:listView];
    
    Navigation *navigatioinView = [Navigation new];
    [self.view addSubview:navigatioinView];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath row] == 6) {
        [Command commandWithName:@"watch_poweroff" block:^(NSInteger type) {
            if (type == 100) {
                [self dismissViewControllerAnimated:YES completion:^{
                    ;
                }];
            }else{
                NSLog(@"error");
            }
        }];
        
        return;
    }
    
    if ([indexPath row] == 5) {
        [Command commandWithName:@"watch_monitor" block:^(NSInteger type) {
            if (type == 100) {
                NSLog(@"success");
            }
        }];
        
        return;
    }
    
    UIViewController *viewController = [OtherSettingFactory factoryWithTag:(int)[indexPath row]];
    
    [self presentViewController:viewController animated:YES completion:^{
        ;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (SCREEN_HEIGHT - 100) / 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CMainCell = @"CMainCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CMainCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: CMainCell];
    }
    NSString *imageString = [NSString stringWithFormat:@"otherSetting%ld",[indexPath row] + 1];
    
    NSString *selectedImageString = [NSString stringWithFormat:@"otherSelected%ld",[indexPath row] + 1];
    
    [cell setBackgroundColor:DEFAULT_COLOR];
    
    [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:selectedImageString]]];
    
    [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageString]]];
    
    return cell;
}


@end
