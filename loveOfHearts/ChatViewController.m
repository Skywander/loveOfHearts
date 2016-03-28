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

#import "Navview.h"


#define FILTRATE_WIDTH 100
#define FILTRATE_CELL_HEIGHT 36

#define PATH_OF_DOCUMENT  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


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
    
    [self.view addSubview:[Navview new]];
    
    [self initTable];
    
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

}

- (void)initTable {
    
    if (!table) {
        table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        table.backgroundColor = DEFAULT_COLOR;
        table.showsVerticalScrollIndicator = NO;
        table.delegate = self;
        table.dataSource = self;
        table.frame = CGRectMake(3, 64, [UIScreen mainScreen].bounds.size.width - 6, [UIScreen mainScreen].bounds.size.height - 104);
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
        [self.view addSubview:table];
        [self.view sendSubviewToBack:table];

    }
}

- (void)initrecordButton {
    recordButton = [[UIButton alloc] initWithFrame:CGRectMake(6, SCREEN_HEIGHT - 85, SCREEN_WIDTH - 12
        , 30)];
    [recordButton setTitle:@"按住说话" forState:UIControlStateNormal];
    [recordButton setTitle:@"松开结束" forState:UIControlStateHighlighted];
    
    [recordButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [recordButton setBackgroundImage:[UIImage imageNamed:@"voiceBtn"] forState:UIControlStateNormal];
    [recordButton setBackgroundImage:[UIImage imageNamed:@"voiceBtnPress"] forState:UIControlStateHighlighted];
    
    [self.view addSubview:recordButton];
    
    [recordButton addTarget:self action:@selector(stopRecord) forControlEvents:UIControlEventTouchUpInside];
    [recordButton addTarget:self action:@selector(beginRecord) forControlEvents:UIControlEventTouchDown];
}

//点击事件
- (void)beginRecord{
    
    NSLog(@"begin record");
    
    NSString *recordFile = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"test.amr"];
    
    [recorder setSpeakMode:NO];
    
    [recorder recordWithURL:[NSURL URLWithString:recordFile]];
}

- (void)stopRecord{
    
    [recorder stop];
    
    NSString *recordFile = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"test.amr"];

    
    [player playWithURL:[NSURL URLWithString:recordFile]];
}

- (void)playRecord:(UIButton *)sender {
    [player stop];
    NSMutableArray *singleMessage = [messageArrays objectAtIndex:(messageArrays.count - 1 - sender.tag)];
    NSString *recordFile = [PATH_OF_DOCUMENT stringByAppendingPathComponent:[singleMessage objectAtIndex:0]];
    
    NSLog(@"%@",recordFile);
    
//    [player setSpeakMode:outputMode];
    [player playWithURL:[NSURL URLWithString:recordFile]];
}

//上传语音消息



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
    cellBgView = [[UIView alloc] initWithFrame:CGRectMake(6, 7, SCREEN_WIDTH - 32, 36)];
    NSMutableArray *singleMessage = [messageArrays objectAtIndex:(messageArrays.count - 1 - [indexPath row])];
    if ([[singleMessage objectAtIndex:2] intValue] == 0) {
        UIImageView *portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 30, 30)];
        
        [portraitView setImage:accountMessage.image];
        
        [portraitView.layer setCornerRadius:15.f];
        [portraitView.layer setCornerRadius:6.f];
        [portraitView setClipsToBounds:YES];
        
        [cellBgView addSubview:portraitView];
        //消息体
        UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(36, 5, 150, 36) ];
        [playButton setTag:[indexPath row]];
        [playButton setBackgroundImage:[UIImage imageNamed:@"chatCell"] forState:UIControlStateNormal];
        [playButton addTarget:self action:@selector(playRecord:) forControlEvents:UIControlEventTouchUpInside];
        [playButton setClipsToBounds:YES];
        [playButton setTag:[indexPath row]];
        //静态时图标
        readStatus = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"readStatus"]];
        readStatus.frame = CGRectMake(35, 8, 10, 20);
        [playButton addSubview:readStatus];
        [cellBgView addSubview:playButton];
        
        UILabel *sendTimelabel = [UILabel new];
        
        
        sendTimelabel.text = [singleMessage objectAtIndex:1];
        sendTimelabel.textAlignment = NSTextAlignmentCenter;
        sendTimelabel.font = [UIFont systemFontOfSize:10];
        sendTimelabel.frame = CGRectMake(0, 0, SCREEN_WIDTH - 20, 10);
        
        [cell addSubview:sendTimelabel];
        [cell addSubview:cellBgView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([[singleMessage objectAtIndex:2] intValue] == 1) {
        UIImageView *portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 56, 3, 30, 30)];
        [portraitView.layer setCornerRadius:15.f];
        NSData *imageData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@.protrait",shouhuan_id]];
        
        if (imageData) {
            UIImage *portraitImage = [UIImage imageWithData:imageData];
            [portraitView setImage:portraitImage];
        }
        [portraitView.layer setCornerRadius:6.f];
        [portraitView setClipsToBounds:YES];
        
        [cellBgView addSubview:portraitView];
        //消息体
        UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 209, 5, 150, 36) ];
        [playButton setTag:[indexPath row]];
        [playButton setBackgroundImage:[UIImage imageNamed:@"chatCellright"] forState:UIControlStateNormal];
        [playButton addTarget:self action:@selector(playRecord:) forControlEvents:UIControlEventTouchUpInside];
        [playButton setClipsToBounds:YES];
        [playButton setTag:[indexPath row]];
        //静态时图标
        readStatus = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"readStatus"]];
        readStatus.frame = CGRectMake(35, 8, 10, 20);
        [playButton addSubview:readStatus];
        [cellBgView addSubview:playButton];
        
        UILabel *sendTimelabel = [UILabel new];
        
        
        sendTimelabel.text = [singleMessage objectAtIndex:1];
        sendTimelabel.textAlignment = NSTextAlignmentCenter;
        sendTimelabel.font = [UIFont systemFontOfSize:10];
        sendTimelabel.frame = CGRectMake(0, 0, SCREEN_WIDTH - 20, 10);
        
        [cell addSubview:sendTimelabel];
        [cell addSubview:cellBgView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }

    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}
- (void)recorder:(PRNAmrRecorder *)aRecorder didRecordWithFile:(PRNAmrFileInfo *)fileInfo
{
    NSLog(@"==================================================================");
    NSLog(@"record with file : %@", fileInfo.fileUrl);
    NSLog(@"file size: %llu", fileInfo.fileSize);
    NSLog(@"file duration : %f", fileInfo.duration);
    NSLog(@"==================================================================");
}

@end
