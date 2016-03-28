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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] == 9) {
        [self dismissViewControllerAnimated:YES completion:^{
            ;
        }];
        
        NSLog(@"click 9");
        
        return;
    }
    
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


- (void)findWatch{
    [Command commandWithName:@"findwatch"];
}

@end
