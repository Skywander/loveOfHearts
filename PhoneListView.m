//
//  PhoneListView.m
//  爱之心
//
//  Created by 于恩聪 on 15/9/9.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "PhoneListView.h"
#import "Constant.h"
#import "Alert.h"
#import "Command.h"
#import "AccountMessage.h"
#import "Navigation.h"
#import "Networking.h"

@interface PhoneListView()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,NavigationProtocol>
{
    UITextField *phoneFields[10];
    UITextField *nameFields[10];
    UITextField *currentField;
    
    NSString *pushStringone;
    NSString *pushStringtwo;
    
    UITableView *listView;
    
    UIView *backView;
    
    NSString *userAccount;
    NSString *watchID;
    
    NSArray *phbArray;
}

@end
@implementation PhoneListView
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Networking getWatchMessageWithParamater:[AccountMessage sharedInstance].wid block:^(NSDictionary *dict) {
        NSLog(@"watchMessage: %@",dict);
        
        [[AccountMessage sharedInstance] setWatchInfor:dict];
        
        [self getData];
        [self initUI];
        
    }];
}

- (void)getData {
    AccountMessage *accountMessage = [AccountMessage sharedInstance];
    
    userAccount = accountMessage.userId;
    
    watchID = accountMessage.wid;
    
    phbArray = [accountMessage.phb componentsSeparatedByString:@","];
    
    NSArray *tempArray = [accountMessage.phb2 componentsSeparatedByString:@","];
    
    phbArray = [phbArray arrayByAddingObjectsFromArray:tempArray];
}

- (void)initUI {
    [self.view setBackgroundColor:DEFAULT_COLOR];
    
    listView = [[UITableView alloc] initWithFrame:CGRectMake(6, 64, SCREEN_WIDTH - 12, SCREEN_HEIGHT)];
    [listView setBackgroundColor:DEFAULT_COLOR];
    
    [listView setSeparatorStyle:(UITableViewCellSeparatorStyleNone)];
    [listView setDataSource:self];
    [listView setDelegate:self];
    [self.view addSubview:listView];
    
    Navigation *navigationView = [Navigation new];
    [navigationView setDelegate:self];
    [navigationView addRightViewWithName:@"保存"];
    [self.view addSubview:navigationView];
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [backView setBackgroundColor:[UIColor clearColor]];
    [backView setHidden:YES];
    [self.view addSubview:backView];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CMainCell = @"CMainCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CMainCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier: CMainCell];
        [cell setBackgroundColor:DEFAULT_COLOR];
    }
    if ([indexPath section] == 0) {
        
        UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(1, 1, (SCREEN_WIDTH  - 15)/ 3,(SCREEN_HEIGHT - 100) / 10 - 2)];
        [nameField setDelegate:self];
        [nameField setBackgroundColor:[UIColor whiteColor]];
        [nameField setKeyboardType:UIKeyboardTypeNumberPad];
        
        [nameField.layer setBorderColor:[UIColor grayColor].CGColor];
        [nameField.layer setBorderWidth:0.3f];
        [nameField.layer setCornerRadius:6.f];
        
        [nameField setPlaceholder:@" 请输入姓名"];
        [nameField setKeyboardType:UIKeyboardTypeDefault];
        [nameField setTag:[indexPath row]];
        nameFields[[indexPath row]] = nameField;
        
        [cell addSubview:nameField];
        
        UITextField *phoneField = [[UITextField alloc] initWithFrame:CGRectMake(2 + (SCREEN_WIDTH - 15)/ 3, 1, (SCREEN_WIDTH - 15)/ 3 * 2, (SCREEN_HEIGHT - 100) / 10)];
        [phoneField setDelegate:self];
        [phoneField setBackgroundColor:[UIColor whiteColor]];
        [phoneField setKeyboardType:UIKeyboardTypeNumberPad];
        
        [phoneField.layer setBorderColor:[UIColor grayColor].CGColor];
        [phoneField.layer setBorderWidth:0.3f];
        [phoneField.layer setCornerRadius:6.f];
        
        [phoneField setPlaceholder:@" 请输入电话号码"];
        [phoneField setTag:[indexPath row] + 10];
        phoneFields[[indexPath row]] = phoneField;
        
        if ([indexPath row] * 2 < phbArray.count && [phbArray objectAtIndex:[indexPath row] * 2]) {
            
            if (![[phbArray objectAtIndex:[indexPath row] * 2] isEqualToString:@" "]) {
                [nameField setText:[phbArray objectAtIndex:[indexPath row] * 2]];
            }
        }
        if ([indexPath row] * 2 + 1 < phbArray.count && [phbArray objectAtIndex:[indexPath row] * 2 + 1]) {
            if (![[phbArray objectAtIndex:[indexPath row] * 2 + 1] isEqualToString:@" "]) {
                [phoneField setText:[phbArray objectAtIndex:[indexPath row] * 2 + 1]];
            }
        }
        
        [cell addSubview:phoneField];

        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 10;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (SCREEN_HEIGHT - 100) / 10;
}

- (void)clickNavigationRightView{

    [self.view bringSubviewToFront:backView];
    
    pushStringone = [NSString stringWithFormat:@"%@,%@",nameFields[0].text,phoneFields[0].text];
    
    pushStringtwo = [NSString stringWithFormat:@"%@,%@",nameFields[5].text,phoneFields[5].text];
    
    NSLog(@"pushSting : %@ %@",pushStringone,pushStringtwo);
    
    for (int i = 1; i < 10; i ++) {
        NSString *nametempStr = nameFields[i].text;
        NSString *phonetempStr = phoneFields[i].text;
        
        if (phoneFields[i].text.length > 0 && phoneFields[i].text.length != 11) {
            [self presentViewController:[Alert getAlertWithTitle:@"输入的号码不正确"] animated:YES
                             completion:^{
                                 ;
                             }];
            pushStringone = [NSString new];
            [phoneFields[i] becomeFirstResponder];
            return;
        }
        
        pushStringone = [NSString stringWithFormat:@"%@,%@,%@",pushStringone,nametempStr,phonetempStr];
    }
    
    if (pushStringone.length != 0) {
        NSDictionary *tempDict = @{
                                   @"userId":userAccount,
                                   @"wid":watchID,
                                   @"phones":pushStringone
                                   };
        
        [Command commandWithAddress:@"watch_phb" andParamater:tempDict block:^(NSInteger type) {
            if (type == 100) {
                [AccountMessage sharedInstance].tempphb = pushStringone;
            }
        }];
    
    }

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"begin editing");
    [backView setHidden:NO];
    [self.view bringSubviewToFront:backView];
    
    currentField = textField;

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touch began");
    if (!backView.hidden) {
        [currentField resignFirstResponder];
    }
    [backView setHidden:YES];

}

@end
