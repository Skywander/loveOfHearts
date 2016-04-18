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
#import "Navigation.h"
#import "AccountMessage.h"
#import "Command.h"

static HistoryFenceList *historyFenceList;
@interface HistoryFenceList ()<NavigationProtocol>
{
    NSMutableArray *fencesDataArray;
    NSMutableArray *fencesIDArray;
    NSString *fenceName;
    
    NSString *user_id;
    NSString *shouhuan_id;
    
    AccountMessage *accountMessage;
}
@end

@implementation HistoryFenceList

@synthesize fencenameList;
@synthesize table;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:DEFAULT_COLOR];
    
    [self initNavigation];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self initData];
}


- (void)initData{
    user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"userAccount"];
    
    [self getWatchMessage];
}
- (void)initNavigation {
    Navigation *navigationView = [Navigation new];
    [navigationView addRightViewWithName:@"新建"];
    [navigationView setDelegate:self];
    [self.view addSubview:navigationView];
}


- (void)initTable {
    
    table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.backgroundColor = DEFAULT_COLOR;
    table.showsVerticalScrollIndicator = NO;
    table.delegate = self;
    table.dataSource = self;
    table.frame = CGRectMake(10, 64, [UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height - 100);
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    [self.view addSubview:table];
    
}

- (void)getWatchMessage {
    
    fencesDataArray = [NSMutableArray new];
    
    fencesIDArray = [NSMutableArray new];
    
    fencenameList = [NSMutableArray new];
    
    accountMessage = [AccountMessage sharedInstance];
    
    shouhuan_id = accountMessage.wid;
    
    NSDictionary *paramater = @{
                                @"wid":accountMessage.wid
                                };
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager new];
    
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    
    [sessionManager POST:[NSString stringWithFormat:@"%@%@",HTTP,@"fence_getFence"] parameters:paramater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArray = [responseObject objectForKey:@"data"];
        
        for (NSDictionary *dict in dataArray) {
            NSLog(@"%@",dict);
            [fencenameList addObject:[dict objectForKey:@"fencename"]];
            
            [fencesDataArray addObject:[dict objectForKey:@"fencearea"]];
            
            [fencesIDArray addObject:[dict objectForKey:@"fid"]];
            
            NSLog(@"fencenamelist : %@",fencenameList);
        }
        
        if (!table) {
            [self initTable];
        }else{
            [table reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return fencenameList.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CMainCell = @"CMainCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CMainCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: CMainCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([indexPath row] == 0) {
        cell.textLabel.text = @"围栏列表";
        cell.textLabel.textColor = DEFAULT_FONT_COLOR;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellCorner"]];
        [cell setBackgroundView:imageView];
        [cell setUserInteractionEnabled:NO];
    }
    if ([indexPath row] > 0) {
        cell.textLabel.text = [fencenameList objectAtIndex:[indexPath row] - 1];
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
    if ([indexPath row] > 0) {
        HistoryViewController *history = [HistoryViewController new];
        
        NSLog(@"%ld %ld",[indexPath row],[indexPath section]);
        
        history.fencesDataArray = [fencesDataArray objectAtIndex:[indexPath row] - 1];
        
        history.fid = [fencesIDArray objectAtIndex:[indexPath row] - 1];
        [self presentViewController:history animated:YES completion:^{
            ;
        }];
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == 0) {
        return 50;
    }
    return 40;
}


- (void)clickNavigationRightView{
    NewFenceView *createFence = [NewFenceView new];

    [self presentViewController:createFence animated:YES completion:^{
        ;
    }];

}
@end
