//
//  ModeChoiceViewController.m
//  爱之心
//
//  Created by 于恩聪 on 15/9/7.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "ModeChoiceViewController.h"
#import "IQActionSheetPickerView.h"
#import "Navigation.h"
#import "AccountMessage.h"
#import "Command.h"

@interface ModeChoiceViewController()<UITableViewDataSource,UITableViewDelegate,IQActionSheetPickerViewDelegate>

{
    UITableView *listView;
    NSArray *dataSource;
    
    NSString *userId;
    NSString *wid;
    
    NSString *modeChoice;
    
    UIImageView *selectedView;
    
    AccountMessage *accountMessage;
    
    int mode;
}

@end


@implementation ModeChoiceViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initView];
    
    
    Navigation *navigation = [Navigation new];
    [self.view addSubview:navigation];
    
}

- (void)initData{
    accountMessage = [AccountMessage sharedInstance];
    
    userId = accountMessage.userId;
    
    wid = accountMessage.wid;
    
    modeChoice = accountMessage.mode;
    
    if ([modeChoice intValue] == 60) {
        mode = 0;
    }
    
    if ([modeChoice intValue] == 600){
        mode = 1;
    }
    
    if ([modeChoice intValue] == 1800) {
        mode = 2;
    }
}


- (void)initView{
    [self.view setBackgroundColor:DEFAULT_COLOR];
    
    dataSource = [NSArray arrayWithObjects:@"跟随模式",@"标准模式",@"省电模式",nil];

    
    listView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [listView setFrame:CGRectMake(6, 44, SCREEN_WIDTH - 12, SCREEN_HEIGHT - 30)];
    
    [listView setBackgroundColor:[UIColor blackColor]];
    
    listView.delegate = self;
    listView.dataSource = self;
    
    listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    listView.scrollEnabled = NO;
    listView.showsVerticalScrollIndicator = NO;
    listView.backgroundColor = DEFAULT_COLOR;
    listView.delaysContentTouches = NO;

    [self.view addSubview:listView];
    
    selectedView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 10, 30, 30)];
    selectedView.image = [UIImage imageNamed:@"yes"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CMainCell = @"CMainCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CMainCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: CMainCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }

    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, SCREEN_WIDTH - 10, 44)];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setText:[dataSource objectAtIndex:[indexPath row]]];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:15.f]];
    
    [cell addSubview:label];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    [cell.layer setBorderColor:[UIColor grayColor].CGColor];
    [cell.layer setBorderWidth:0.3f];
    
    NSLog(@"%d %ld",mode,[indexPath row]);
    
    if (mode == [indexPath row]) {
        [cell addSubview:selectedView];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[tableView.visibleCells objectAtIndex:[indexPath row]] addSubview:selectedView];
    
    NSString *space = [NSString new];
    
    if ([indexPath row] == 0) {
        space = @"60";
    }
    if ([indexPath row] == 1) {
        space = @"600";
    }
    if ([indexPath row] == 2){
        space = @"1800";
    }
    
    NSDictionary *dict = @{
                           @"userId":userId,
                           @"wid":wid,
                           @"space":space
                           };
    
    [Command commandWithAddress:@"uploadspacetime" andParamater:dict block:^(NSInteger type) {
        if (type == 100){
            accountMessage.tempmode = space;
            
            [self dismissViewControllerAnimated:YES completion:^{
                ;
            }];
        }
    }];
}



@end
