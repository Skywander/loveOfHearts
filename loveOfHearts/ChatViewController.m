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
    NSString *createTime;
    NSInteger getVoiceStartLocation;
    
    //pull refresh
    UIRefreshControl *refreshViewController;
    
    NSString *fileDirectoryPath;
    NSFileManager *fileManager;
    NSArray *_voicePlayLeftImages;
    UIImageView *_voicePlayLeftView;
    
    NSArray *_voicePlayRightImages;
    UIImageView *_voicePlayRightView;
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
    [self.view setBackgroundColor:DEFAULT_COLOR];
    
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
        
        NSArray *dataArray;
        
        if ([[dict objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
            
            dataArray = [dict objectForKey:@"data"];
            
            messageArrays = [NSMutableArray arrayWithArray:dataArray];
            
            [self initTable];


        }
        
        if ([[dict objectForKey:@"data"] isKindOfClass:[NSString class]]) {
             ;
        }
    }];
    
    NSLog(@"after");
    
    fileDirectoryPath = [NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0],accountMessage.wid];
    
     fileManager = [NSFileManager defaultManager];
    
    bool inter = YES;
    
    if (![fileManager fileExistsAtPath:fileDirectoryPath isDirectory:&inter]) {
        [fileManager createDirectoryAtPath:fileDirectoryPath withIntermediateDirectories:inter attributes:nil error:nil];
    }
    
    _voicePlayLeftImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"voice_right0"],[UIImage imageNamed:@"voice_right1"],[UIImage imageNamed:@"voice_right2"],[UIImage imageNamed:@"voice_right3"],nil];
    
    _voicePlayRightImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"voice_left0"],[UIImage imageNamed:@"voice_left1"],[UIImage imageNamed:@"voice_left2"],[UIImage imageNamed:@"voice_left3"],nil];
    
    _voicePlayLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(87, 18, 30, 30)];
    
    _voicePlayRightView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 111, 18, 30, 30)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable:) name:@"receiveVoice" object:nil];

}

- (void)initTable {
    if (!table) {
         refreshViewController = [UIRefreshControl new];
        
        [refreshViewController setTintColor:DEFAULT_PINK];
        
        [refreshViewController setAttributedTitle:[[NSAttributedString alloc] initWithString:@"下拉刷新"]];
        [refreshViewController addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
        

        table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        table.backgroundColor = DEFAULT_COLOR;
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

- (void)updateTable:(NSNotification *)sender{
    NSDictionary *dict = (NSDictionary *)sender.object;
    
    [messageArrays insertObject:dict atIndex:0];
    
    [table reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:messageArrays.count - 1 inSection:0];
    
    [table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    NSLog(@"receive voice");
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
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    createTime = [formatter stringFromDate:date];
    
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
        
        if ([[dict objectForKey:@"data"] isKindOfClass:[NSString class]]) {
            
            [refreshViewController endRefreshing];
            

            return ;
        }
        
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
    
    [cell setBackgroundColor:DEFAULT_COLOR];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *voiceMessageDict = [messageArrays objectAtIndex:messageArrays.count - [indexPath row] - 1];
    
    NSString *_fileName = [voiceMessageDict objectForKey:@"filename"];
    
    NSString *filePath = [fileDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",_fileName]];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        
        NSLog(@"file");
        
        NSLog(@"filename:%@",_fileName);
        
        [player setSpeakMode:YES];
        
        [player playWithURL:[NSURL URLWithString:filePath] finished:^{
            _voicePlayLeftView.animationDuration = 0;
            
            _voicePlayRightView.animationDuration = 0;
        }];
        
    }else{
        
        NSLog(@"net");
        
        NSDictionary *paramater = @{
                                    @"wid":[AccountMessage sharedInstance].wid,
                                    @"fileName":_fileName,
                                    };
        
        [Networking downloadVoiceWithDict:paramater block:^(NSData *data) {

            [data writeToFile:filePath atomically:NO];
            
            [player playWithURL:[NSURL URLWithString:filePath] finished:^{
                _voicePlayLeftView.animationDuration = 0;
                
                _voicePlayRightView.animationDuration = 0;
            }];

        }];
    }
    
    if ([[[messageArrays objectAtIndex:messageArrays.count - [indexPath row] - 1] objectForKey:@"fromId"] isEqualToString:accountMessage.wid]) {

        [[tableView cellForRowAtIndexPath:indexPath] addSubview:_voicePlayLeftView];
        
        _voicePlayLeftView.animationImages = _voicePlayLeftImages;
        
        _voicePlayLeftView.animationDuration = 1;
        
        _voicePlayLeftView.animationRepeatCount = 10;
        
        [_voicePlayLeftView startAnimating];
    }else{
        
        [[tableView cellForRowAtIndexPath:indexPath] addSubview:_voicePlayRightView];
        
        _voicePlayRightView.animationImages = _voicePlayRightImages;
        
        _voicePlayRightView.animationDuration = 1;
        
        _voicePlayRightView.animationRepeatCount = 10;
        
        [_voicePlayRightView startAnimating];

    }
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
                           @"createdAt":createTime,
                           @"filename":voiceName,
                           @"fromId":accountMessage.userId,
                           @"isheard":@"0",
                           @"updatedAt":createTime,
                           @"wid":accountMessage.wid
                           };
    [messageArrays insertObject:dict atIndex:0];
    
    NSLog(@"%ld",messageArrays.count);
    
    if (!table) {
        
        [self initTable];
    }
    
    [table reloadData];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:messageArrays.count - 1 inSection:0];
    
    [table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    NSData *voiceData = [NSData dataWithContentsOfFile:recordFile];
    
   [Networking uploadVoiceWithDict:paramater andVoiceData:voiceData voiceName:voiceName];
}

@end
