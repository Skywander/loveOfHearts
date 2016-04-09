//
//  ChatViewController.m
//  Runner
//
//  Created by 于恩聪 on 15/7/31.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "ChatViewController.h"
#import "Constant.h"
#import "Networking.h"

#import "PRNAmrRecorder.h"
#import "PRNAmrPlayer.h"

#import "AccountMessage.h"

#import "Navigation.h"

#import "CellFactory.h"


#define FILTRATE_WIDTH 100
#define FILTRATE_CELL_HEIGHT 36

@interface ChatViewController()<PRNAmrRecorderDelegate,UIGestureRecognizerDelegate>
{
    PRNAmrRecorder *recorder;
    PRNAmrPlayer *player;
    
    UIImageView *animationView;
    NSMutableArray *messageArrays;
    
    NSString *user_id;
    NSString *shouhuan_id;
    
    AccountMessage *accountMessage;
    
    UIButton *recordButton;
    
    NSString *voiceName;
    NSString *timeString;
    NSInteger getVoiceStartLocation;
    
    //pull refresh
    UIRefreshControl *refreshViewController;
    
    NSString *fileDirectoryPath;
    NSFileManager *fileManager;
    
    NSArray *_voicePlayImages;
    
    UIImageView *_voicePlayView;
}
@end
@implementation ChatViewController
@synthesize leftButton,titleButton,navigationItem;
@synthesize table;
@synthesize cellBgView;
@synthesize unreadTag;
@synthesize readStatus;
@synthesize filtrateView;
@synthesize filtrateArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [player stop];
}

- (void)initUI{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:[Navigation new]];

    [self initrecordButton];

}

- (void)initData{
    recorder = [[PRNAmrRecorder alloc] init];
    
    recorder.delegate = self;
        
    player = [[PRNAmrPlayer alloc] init];

    accountMessage = [AccountMessage sharedInstance];
    
    shouhuan_id = accountMessage.wid;
    
    user_id = accountMessage.userId;
    
    messageArrays = [NSMutableArray new];
    
    
    NSDictionary *dict = @{
                            @"userId":user_id,
                            @"wid":shouhuan_id,
                            @"firstResult":@"0",
                            @"maxResult":@"10"
                           };
    getVoiceStartLocation = 10;
    
    [Networking getallrecordesWithDict:dict block:^(NSDictionary *dict) {
        
        NSLog(@"DICT : %@",dict);
        
        NSArray *dataArray = [dict objectForKey:@"data"];
            
        NSLog(@"DATAARRAY : %@",dataArray);
        
        if (dataArray.count > 1) {
            
            messageArrays = [NSMutableArray arrayWithArray:dataArray];
            
            [self initTable];

        }
    }];
    
    fileDirectoryPath = [NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0],accountMessage.wid];
    
     fileManager = [NSFileManager defaultManager];
    
    bool inter = YES;
    
    if (![fileManager fileExistsAtPath:fileDirectoryPath isDirectory:&inter]) {
        [fileManager createDirectoryAtPath:fileDirectoryPath withIntermediateDirectories:inter attributes:nil error:nil];
    }
    
    _voicePlayImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"voice_right0"],[UIImage imageNamed:@"voice_right1"],[UIImage imageNamed:@"voice_right2"],[UIImage imageNamed:@"voice_right3"],nil];
    
    _voicePlayView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 16, 30, 30)];

}

- (void)initTable {
    if (!table) {
         refreshViewController = [UIRefreshControl new];
        
        [refreshViewController setTintColor:DEFAULT_PINK];
        
        [refreshViewController setAttributedTitle:[[NSAttributedString alloc] initWithString:@"下拉刷新"]];
        [refreshViewController addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
        

        table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        table.backgroundColor = [UIColor whiteColor];
        table.showsVerticalScrollIndicator = NO;
        table.delegate = self;
        table.dataSource = self;
        table.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 104);
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        [self.view addSubview:table];
        [self.view sendSubviewToBack:table];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:messageArrays.count - 1 inSection:0];
        [table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        [table addSubview:refreshViewController];
    }
}

- (void)initrecordButton {
    
    UIView *_recordBack = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    
    [_recordBack setBackgroundColor:DEFAULT_PINK];
        
    
    [self.view addSubview:_recordBack];
    
    recordButton = [[UIButton alloc] initWithFrame:CGRectMake(6, 10, SCREEN_WIDTH - 12
        , 30)];
    [recordButton setTitle:@"按住说话" forState:UIControlStateNormal];
    [recordButton setTitle:@"松开结束" forState:UIControlStateHighlighted];
    
    [recordButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [recordButton setTitleColor:DEFAULT_PINK forState:UIControlStateHighlighted];
    
    [recordButton setBackgroundColor:[UIColor whiteColor]];
    
    [recordButton.layer setCornerRadius:6.f];
    [recordButton setClipsToBounds:YES];
    
    [_recordBack addSubview:recordButton];
    
    [recordButton addTarget:self action:@selector(stopRecord) forControlEvents:UIControlEventTouchUpInside];
    [recordButton addTarget:self action:@selector(beginRecord) forControlEvents:UIControlEventTouchDown];
}

#pragma action
- (void)beginRecord{
    
    NSDate *date = [NSDate new];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"YYYY_MM_dd_HHmmss"];
    timeString = [formatter stringFromDate:date];
    
    voiceName = [NSString stringWithFormat:@"%@.amr",timeString];
    
    NSLog(@"voiceName : %@",voiceName);
    
    NSString *recordFile = [fileDirectoryPath stringByAppendingPathComponent:voiceName];
    
    [recorder setSpeakMode:NO];
    
    [recorder recordWithURL:[NSURL URLWithString:recordFile]];
}

- (void)stopRecord{
    
    [recorder stop];
}


- (void)refreshTableView{
    NSDictionary *dict = @{
                           @"userId":user_id,
                           @"wid":shouhuan_id,
                           @"firstResult":[NSString stringWithFormat:@"%ld",(long)getVoiceStartLocation],
                           @"maxResult":[NSString stringWithFormat:@"%d",10]
                           };
    [Networking getallrecordesWithDict:dict block:^(NSDictionary *dict) {
        NSArray *dataArray = [dict objectForKey:@"data"];
        
        getVoiceStartLocation += 10;
        
        for (NSDictionary *dict in dataArray) {

            [messageArrays addObject:dict];
        }
        
        if (dataArray.count < 1) {
            NSLog(@"no messages");
        } else{
            
            NSLog(@"messageArray : %@",messageArrays);
            
            [table reloadData];

        }
        [refreshViewController endRefreshing];
    }];

}


#pragma tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return messageArrays.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CMainCell = @"CMainCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CMainCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: CMainCell];
    }
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    UIView *subView = [CellFactory CellFactoryWithDict:[messageArrays objectAtIndex:(messageArrays.count - [indexPath row] - 1)]];
    
    [cell addSubview:subView];
    
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *voiceMessageDict = [messageArrays objectAtIndex:messageArrays.count - [indexPath row] - 1];
    
    NSString *_fileName = [voiceMessageDict objectForKey:@"filename"];
    
    NSString *filePath = [fileDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",_fileName]];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        
        NSData *_date = [NSData dataWithContentsOfFile:filePath];
        
        NSLog(@"get fileName:%@",_date);
        
        [player setSpeakMode:YES];

        [player playWithURL:[NSURL URLWithString:filePath]];
        
    }else{
        NSDictionary *paramater = @{
                                    @"wid":[AccountMessage sharedInstance].wid,
                                    @"fileName":_fileName,
                                    };
        
        [Networking downloadVoiceWithDict:paramater block:^(NSData *data) {

            [data writeToFile:filePath atomically:NO];
            
            [player playWithURL:[NSURL URLWithString:filePath]];
        }];
    }
    
    [[tableView cellForRowAtIndexPath:indexPath] addSubview:_voicePlayView];
    
    _voicePlayView.animationImages = _voicePlayImages;
    
    _voicePlayView.animationDuration = 1;
    
    _voicePlayView.animationRepeatCount = 10;
    
    [_voicePlayView startAnimating];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}



#pragma record over,upload voice
- (void)recorder:(PRNAmrRecorder *)aRecorder didRecordWithFile:(PRNAmrFileInfo *)fileInfo
{
    
    NSString *recordFile = [fileDirectoryPath stringByAppendingPathComponent:voiceName];

    NSDictionary *paramater = @{
                                @"userId":accountMessage.userId,
                                @"wid":accountMessage.wid
                                };
    
    NSDictionary *dict = @{
                           @"createdAt":timeString,
                           @"filename":voiceName,
                           @"fromId":accountMessage.userId,
                           @"isheard":@"0",
                           @"updatedAt":timeString,
                           @"wid":accountMessage.wid
                           };
    [messageArrays addObject:dict];
    
    if (!table) {
        
        NSLog(@"NOT EXISE TABLE");
        
        [self initTable];
    }
    
    [table reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:messageArrays.count - 1 inSection:0];
    [table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    NSData *voiceData = [NSData dataWithContentsOfFile:recordFile];
    
   [Networking uploadVoiceWithDict:paramater andVoiceData:voiceData voiceName:voiceName];
}

@end
