//
//  PhoneCanMakeList.m
//  爱之心
//
//  Created by 于恩聪 on 15/9/9.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "PhoneCanMakeList.h"
#import "Constant.h"
#import "Command.h"
#import "Navigation.h"
#import "AccountMessage.h"
#import "Networking.h"
@interface PhoneCanMakeList()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NavigationProtocol>
{
    UITableView *phoneListView;
    NSMutableArray *phoneArray;
    UITextField *textFields[10];
    UITextField *currentField;
    
    UIView *backView;
    
    NSMutableArray *phoneNumbersList;
    NSString *phoneNumbersOne;
    NSString *phoneNumbersTwo;
    CGFloat listOffset;
    
    AccountMessage *accountMessage;
}
@end

@implementation PhoneCanMakeList
@synthesize whitelist_1;
@synthesize whitelist_2;
@synthesize userAccount,watchID;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self.view setBackgroundColor:DEFAULT_COLOR];
    
    [Networking getWatchMessageWithParamater:[AccountMessage sharedInstance].wid block:^(NSDictionary *dict) {
        NSLog(@"watchMessage: %@",dict);
        
        [[AccountMessage sharedInstance] setWatchInfor:dict];
        
        [self initData];
        [self initUI];

    }];
}
-(void)loadView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scrollView;
}
- (void)initData {
    accountMessage = [AccountMessage sharedInstance];
    
    whitelist_1 = [accountMessage.whitelist1 componentsSeparatedByString:@","];
    
    whitelist_2 = [accountMessage.whitelist2 componentsSeparatedByString:@","];
    
    watchID = accountMessage.wid;

    NSLog(@"%@ %@",whitelist_2,whitelist_1);
    
    listOffset = 0;
    phoneArray = [NSMutableArray new];
    
    if (whitelist_1.count != 0 && whitelist_2.count != 0) {
        phoneNumbersList = [NSMutableArray arrayWithArray:[whitelist_1 arrayByAddingObjectsFromArray:whitelist_2]];
    }else{
        phoneNumbersList = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];

    }
    
    phoneNumbersOne = [NSString new];
    phoneNumbersTwo = [NSString new];
    
    userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:@"userAccount"];
}


- (void)initUI {
    [self.view setBackgroundColor:DEFAULT_COLOR];
    
    backView = [[UIView alloc ] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [backView setBackgroundColor:[UIColor clearColor]];
    [backView setHidden:YES];
    [self.view addSubview:backView];
    
    phoneListView = [[UITableView alloc] initWithFrame:CGRectMake(6, 64, SCREEN_WIDTH - 12, SCREEN_HEIGHT - 60)];
    [phoneListView setDataSource:self];
    [phoneListView setDelegate:self];
    [phoneListView setBackgroundColor:DEFAULT_COLOR];
    [phoneListView setShowsVerticalScrollIndicator:NO];
    [phoneListView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    [phoneListView setSectionHeaderHeight:4];

    [self.view addSubview:phoneListView];
    
    [self.view sendSubviewToBack:phoneListView];
}
- (void)initNavigation{
    
    Navigation *navigationView = [[Navigation alloc] init];
    
    [navigationView addRightViewWithName:@"确定"];
    
    [navigationView setDelegate:self];
    
    [self.view addSubview:navigationView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CMainCell = @"CMainCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CMainCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier: CMainCell];

    }
    [cell setBackgroundColor:DEFAULT_COLOR];
    
    if ([indexPath section] == 0) {
        UILabel *_label = [[UILabel alloc] initWithFrame:CGRectMake(1, 2, 65,(SCREEN_HEIGHT - 150)/10 - 4)];
        
        [_label setText:[NSString stringWithFormat:@"白名单%ld",(long)[indexPath row] + 1]];
                
        [_label setFont:[UIFont systemFontOfSize:15]];
        
        [_label setTextAlignment:NSTextAlignmentCenter];
        
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(65, 2, SCREEN_WIDTH - 74, (SCREEN_HEIGHT - 150) / 10 - 4)];
        
        if (phoneNumbersList.count > [indexPath row]) {
            
            NSString *cellString = [phoneNumbersList objectAtIndex:[indexPath row]];
            
            if (cellString.length == 11) {
                [textField setText:[phoneNumbersList objectAtIndex:[indexPath row]]];
            }else{
                [textField setPlaceholder:@"请输入手机号码"];
            }
        }
        else{
            [textField setPlaceholder:@"请输入手机号码"];
        }
        
        [textField setDelegate:self];
        [textField setBackgroundColor:[UIColor whiteColor]];
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        [textField setReturnKeyType:UIReturnKeyDone];
        
        [textField.layer setBorderColor:[UIColor grayColor].CGColor];
        [textField.layer setBorderWidth:0.3f];
        [textField.layer setCornerRadius:6.f];
        
        [textField setPlaceholder:@" 请输入手机号码"];
        textField.tag = [indexPath row];
        textFields[[indexPath row]] = textField;
        
        [cell addSubview:textField];
        
        [cell addSubview:_label];

    }

    
    return cell;
}

- (void)clickNavigationRightView{
    
    NSLog(@"click");
    
    if ([AccountMessage sharedInstance].isAdmin != 1) {
        [JKAlert showMessage:@"您不是管理员"];
        
        return;
    }

    
    phoneNumbersOne = textFields[0].text;
    
    for (int i = 1; i < 10; i ++) {
        NSString *tempStr = textFields[i].text;
        
        phoneNumbersOne = [phoneNumbersOne stringByAppendingString:[NSString stringWithFormat:@",%@",tempStr]];
    }
    
    NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              userAccount,@"userId",
                              watchID,@"wid",
                              phoneNumbersOne,@"whitelist",
                              nil
                              ];
    [Command commandWithAddress:@"watch_whitelist" andParamater:tempDict block:^(NSInteger type) {
        if (type == 100) {
            NSLog(@"set success");
        }
    }];


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (SCREEN_HEIGHT - 150) / 10;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    currentField = textField;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    if (!backView.hidden) {
        NSLog(@"%ld",(long)currentField.tag);
        [phoneNumbersList replaceObjectAtIndex:currentField.tag withObject:currentField.text];
        if (currentField) {
            [currentField resignFirstResponder];
        }
    }
}
@end
