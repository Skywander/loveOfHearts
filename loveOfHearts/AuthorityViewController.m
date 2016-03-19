//
//  AuthorityViewController.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/19.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "AuthorityViewController.h"
#import "AccountMessage.h"

#import "Navview.h"

#import "Networking.h"

#import <Masonry/Masonry.h>

#define VIEW_HEIGTH 80
@interface AuthorityViewController ()

{
    NSTimer *timer;
    
    Networking *netWorking;
    
    NSArray *usersArray;
}

@end

@implementation AuthorityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigation];
    
    [self getUserData];
}

- (void)initNavigation{
    Navview *naviView = [Navview new];
    
    [self.view addSubview:naviView];
}

- (void)getUserData{
    AccountMessage *accountMessage = [AccountMessage sharedInstance];
    NSDictionary *dict = @{
                           @"wid":accountMessage.wid
                          };
    
    netWorking = [Networking new];
    
    [netWorking getUsersMessageWithParamaters:dict];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getUsersArray) userInfo:nil repeats:YES];
    
}

- (void)getUsersArray{
    if ([netWorking getUsersArray].count > 0) {
        usersArray = [netWorking getUsersArray];
        
        [timer invalidate];
        
        [self initUI];
    }
}

- (void)initUI{
    
    [self.view setBackgroundColor:DEFAULT_COLOR];
    float y = 70;
    
    for (NSDictionary *dict in usersArray) {
        NSLog(@"dict : %@",dict);
        UIView *userView = [self viewWithFirstLabel:[dict objectForKey:@"userId"] secondLabel:[dict objectForKey:@"wid"] relationType:nil Admin:nil andY:y];
        
        y+=70;
        
        [self.view addSubview:userView];
    }
}

- (UIView *)viewWithFirstLabel:(NSString *)textOne secondLabel:(NSString *)textTwo relationType:(NSString *)type Admin:(NSString *)admin andY:(float)y{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, y, SCREEN_WIDTH - 20, VIEW_HEIGTH)];
    
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH / 2 - 10, VIEW_HEIGTH / 2)];
    [firstLabel setText:[NSString stringWithFormat:@"用户  %@",textOne]];
    
    [firstLabel setFont:[UIFont systemFontOfSize:14]];
     
     [firstLabel setTextAlignment:NSTextAlignmentCenter];
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_HEIGTH / 2, SCREEN_WIDTH / 2 - 10, VIEW_HEIGTH /2)];
     
     [secondLabel setTextAlignment:NSTextAlignmentCenter];
     
     [secondLabel setFont:[UIFont systemFontOfSize:14]];
    
    [secondLabel setText:[NSString stringWithFormat:@"手表  %@",textTwo]];
    
    [view addSubview:firstLabel];
    [view addSubview:secondLabel];
    
    
    [view.layer setCornerRadius:6.F];
    [view.layer setBorderColor:[UIColor grayColor].CGColor];
    [view.layer setBorderWidth:0.3F];
    
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
