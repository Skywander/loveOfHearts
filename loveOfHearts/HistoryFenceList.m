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
#import "Navview.h"
#import "AccountMessage.h"
#import "Command.h"

static HistoryFenceList *historyFenceList;
@interface HistoryFenceList ()
{
    //
    NSMutableArray *fencesArray;
    NSMutableArray *fencesDataArray;
    NSMutableArray *fencesIDArray;
    NSString *fenceName;
    
    NSString *user_id;
    NSString *shouhuan_id;
    AccountMessage *accountMessage;
    
    NSTimer *timer;
    
}
@end

@implementation HistoryFenceList

@synthesize sections,section0,section1,fencenameList;
@synthesize table;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:DEFAULT_COLOR];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initData];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(initView) userInfo:nil repeats:YES];
}

- (void)initView{
    if (fencesArray.count <= 0) {
        return;
    }
    
    [timer invalidate];
    
    [self initSection];
    [self initTable];
    [self initNavigation];
}

- (void)initData{
    user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"userAccount"];
    
    [self getWatchMessage];
}
- (void)initNavigation {
    Navview *navigationView = [Navview new];
    [self.view addSubview:navigationView];
}

- (void)initSection {
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
    table.backgroundColor = DEFAULT_COLOR;
    table.showsVerticalScrollIndicator = NO;
    table.delegate = self;
    table.dataSource = self;
    table.frame = CGRectMake(10, 64, [UIScreen mainScreen].bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height - 100);
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    [self.view addSubview:table];
    
}

- (void)getWatchMessage {
    fencesArray = [NSMutableArray new];
    
    fencesDataArray = [NSMutableArray new];
    
    fencesIDArray = [NSMutableArray new];

    
    accountMessage = [AccountMessage sharedInstance];
    
    shouhuan_id = accountMessage.wid;
    
    NSDictionary *paramater = @{
                                @"wid":accountMessage.wid
                                };
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager new];
    
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", @"text/plain",nil];
    
    [sessionManager POST:[NSString stringWithFormat:@"%@%@",HTTP,@"getfences"] parameters:paramater constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        ;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArray = [responseObject objectForKey:@"data"];
        
        for (NSDictionary *dict in dataArray) {
            NSLog(@"%@",dict);
            [fencesArray addObject:[dict objectForKey:@"fencename"]];
            [fencesDataArray addObject:[dict objectForKey:@"fencearea"]];
            
            [fencesIDArray addObject:[dict objectForKey:@"fid"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure : %@",error);
    }];
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
        cell.textLabel.textColor = DEFAULT_FONT_COLOR;
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
        [self presentViewController:createFence animated:YES completion:^{
            ;
        }];
        return;
    }
    if ([indexPath section] == 1 && [indexPath row] > 0) {
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
    if ([indexPath section] == 0) {
        return 50;
    }
    return 40;
}

@end
