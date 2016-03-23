//
//  ModeChoiceViewController.m
//  爱之心
//
//  Created by 于恩聪 on 15/9/7.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "ModeChoiceViewController.h"
#import "Constant.h"
#import "IQActionSheetPickerView.h"
#import "Navview.h"
#import "AccountMessage.h"

@interface ModeChoiceViewController()<UITableViewDataSource,UITableViewDelegate,IQActionSheetPickerViewDelegate>

{
    UITableView *listView;
    NSArray *dataSource;
    
    NSString *userId;
    NSString *wid;
}

@end


@implementation ModeChoiceViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    Navview *navigation = [Navview new];
    [self.view addSubview:navigation];
    
    [self initTableView];
    
}

- (void)initData{
    AccountMessage *accountMessage = [AccountMessage new];
    
    userId = accountMessage.userId;
    
    wid = accountMessage.wid;
}


- (void)initTableView{
    [self.view setBackgroundColor:DEFAULT_COLOR];
    
    dataSource = [NSArray arrayWithObjects:@"跟随模式",@"标准模式",@"省电模式",nil];

    
    listView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [listView setFrame:CGRectMake(6, 10, SCREEN_WIDTH - 12, SCREEN_HEIGHT - 30)];
    
    [listView setBackgroundColor:[UIColor blackColor]];
    
    listView.delegate = self;
    listView.dataSource = self;
    
    listView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    listView.showsVerticalScrollIndicator = NO;
    listView.backgroundColor = DEFAULT_COLOR;
    listView.delaysContentTouches = NO;

    [self.view addSubview:listView];
    
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

    
    UILabel *label = [[UILabel alloc] initWithFrame:cell.frame];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:[dataSource objectAtIndex:[indexPath row]]];
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:15.f]];
    
    [cell addSubview:label];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    [cell.layer setBorderColor:[UIColor grayColor].CGColor];
    [cell.layer setBorderWidth:0.3f];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



@end
