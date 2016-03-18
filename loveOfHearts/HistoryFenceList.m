//
//  HistoryFenceList.m
//  Runner
//
//  Created by 于恩聪 on 15/7/9.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "HistoryFenceList.h"
#import "HistoryViewController.h"
#import "NewFenceView.h"
#import "Networking.h"
#import "Fence.h"
#import "Navview.h"
#import "AccountMessage.h"
#import "Command.h"
@interface HistoryFenceList ()
{
    //
    NSMutableArray *fencesArray;
    NSString *fenceName;
    
    NSString *user_id;
    NSString *shouhuan_id;
    
}
@end

@implementation HistoryFenceList

@synthesize sections,section0,section1,fencenameList;
@synthesize table;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self initData];
    [self initSection];
    [self initTable];
    [self initNavigation];
}

- (void)initData{
    user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    shouhuan_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"shouhuan_id"];
}
- (void)initNavigation {
    Navview *navigationView = [Navview new];
    [self.view addSubview:navigationView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getWatchMessage];
    [self initSection];
    [self initTable];
}
- (void)initSection {
    fencenameList = [[NSUserDefaults standardUserDefaults] objectForKey:@"fencenameList"];
    fencesArray = [NSMutableArray new];
    if (!fencenameList) {
        fencenameList = [NSMutableArray new];
    } else{
        fencenameList = [NSMutableArray arrayWithArray:fencenameList];
    }
    section1 = fencenameList;
    
    section0 = [NSMutableArray arrayWithObject:@" 创建围栏"];
    sections = [NSMutableArray arrayWithObjects:section0,fencesArray, nil];
    
}
- (void)initTable {
    table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.backgroundColor = [UIColor whiteColor];
    table.showsVerticalScrollIndicator = NO;
    table.delegate = self;
    table.dataSource = self;
    table.frame = CGRectMake(10, 40, [UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height - 100);
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    [self.view addSubview:table];
    
}

- (void)getWatchMessage {
    NSDictionary *paramater = @{
                                    [AccountMessage sharedInstance].wid:@"wid"
                                };
    [Command commandWithAddress:@"getfences" andParamater:paramater];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section ==1) {
        return [[sections objectAtIndex:section] count] + 1;
    }
    return [[sections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CMainCell = @"CMainCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CMainCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: CMainCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([indexPath section] == 0) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"createFenceBackView.jpg"]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if ([indexPath row] == 0 &&[indexPath section] == 1) {
        cell.textLabel.text = @"围栏列表";
        cell.textLabel.textColor = DEFAULT_COLOR;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellCorner"]];
        [cell setBackgroundView:imageView];
        [cell setUserInteractionEnabled:NO];
    }
    if ([indexPath row] > 0) {
        cell.textLabel.text = [[sections objectAtIndex:[indexPath section]]objectAtIndex:[indexPath row] - 1];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellnoCorner"]];
        [imageView.layer setBorderColor:[UIColor grayColor].CGColor];
        [imageView.layer setBorderWidth:0.3f];
        [imageView.layer setCornerRadius:3.f];
        [cell setBackgroundView:imageView];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0) {
        NewFenceView *createFence = [NewFenceView new];
        createFence.hidesBottomBarWhenPushed = YES;
        createFence.fencesArray = fencesArray;
        [self.navigationController pushViewController:createFence animated:YES];
        return;
    }
    NSString *selectedFenceName = [[sections objectAtIndex:[indexPath section]]objectAtIndex:[indexPath row] - 1];
    HistoryViewController *history = [HistoryViewController new];
    history.fenceName = selectedFenceName;
    history.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:history animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 0) {
        return 50;
    }
    return 40;
}

@end
