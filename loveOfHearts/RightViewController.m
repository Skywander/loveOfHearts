//
//  RightViewController.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/14.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "RightViewController.h"
#import "RightVieFactory.h"
#import "Command.h"

#define RIGHT_CELL_WIDTH 465/2.0

#define RIGHT_BUTTON_HEIGHT 95/2.0

@interface RightViewController ()
{
    NSArray *cellNames;
    
}
@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
}

- (void)initData{
    cellNames = [NSArray arrayWithObjects:@"babyManage",@"authority",@"relativeNumber",@"phoneText",@"whitelist",@"fences",@"historyTrack",@"findWatch",@"otherSetting",@"exit", nil];
}

- (void) initUI {
    [self.view setBackgroundColor:DEFAULT_COLOR];
    
    //列表
    UITableView *listView = [[UITableView alloc] initWithFrame:CGRectMake(10, 34, RIGHT_CELL_WIDTH, SCREEN_HEIGHT - 20) style:UITableViewStylePlain];
    listView.scrollEnabled = NO;
    [listView setBackgroundColor:DEFAULT_COLOR];
    listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    listView.showsHorizontalScrollIndicator = NO;
    listView.showsVerticalScrollIndicator = NO;
    listView.dataSource = self;
    listView.delegate = self;
    [self.view addSubview:listView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initButton{
    NSArray *buttonNames = [NSArray arrayWithObjects:@"babyManage",@"authority",@"relativeNumber",@"phoneText",@"whitelist",@"fences",@"historyTrack",@"findWatch",@"otherSetting",@"exit", nil];
    
    float y = 64;
    
    for (NSString *buttonName in buttonNames) {
        [self initButtonWithTitle:buttonName andY:y];
        
        y = y + RIGHT_BUTTON_HEIGHT + 1;
    }
}


- (void)initButtonWithTitle:(NSString *)title andY:(float)y{
    UIButton *button = [UIButton new];
    
//    [button setFrame:CGRectMake(10, y, RIGHT_BUTTON_WIDTH, RIGHT_BUTTON_HEIGHT)];
    
    [button setBackgroundImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
    
    [self.view addSubview:button];
    
    [button setTag:(int)(y - 64) / (RIGHT_BUTTON_HEIGHT) + 1];
    
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([RightVieFactory factoryWithTag:(int)[indexPath row]]) {
        [self presentViewController:[RightVieFactory factoryWithTag:(int)[indexPath row]] animated:YES completion:^{
            ;
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CMainCell = @"CMainCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CMainCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: CMainCell];
    }
    [cell setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:[cellNames objectAtIndex:[indexPath row]]]]];
    [cell setBackgroundColor:DEFAULT_COLOR];
    [cell setSelectedBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"S%@",[cellNames objectAtIndex:[indexPath row]]]]]];
                             
    return cell;
    
}

- (void)clickButton:(UIButton *)button{
    if (button.tag == 8) {
        NSLog(@"找手表");
        
        [self findWatch];
    }
    
    if ([RightVieFactory factoryWithTag:(int)button.tag]) {
        [self presentViewController:[RightVieFactory factoryWithTag:(int)button.tag] animated:YES completion:^{
            ;
        }];
    }

}

- (void)findWatch{
    [Command commandWithName:@"findwatch"];
}

@end
