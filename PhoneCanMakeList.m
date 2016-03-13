//
//  PhoneCanMakeList.m
//  爱之心
//
//  Created by 于恩聪 on 15/9/9.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "PhoneCanMakeList.h"
#import "Constant.h"
#import "Alert.h"
#import "Command.h"
@interface PhoneCanMakeList()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
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
    
    NSString *userAccount;
    NSString *watchID;
}
@end

@implementation PhoneCanMakeList
@synthesize whitelist_1;
@synthesize whitelist_2;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}
-(void)loadView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view = scrollView;
}
- (void)initData {
    listOffset = 0;
    phoneArray = [NSMutableArray new];
    
    phoneNumbersList = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    
    phoneNumbersOne = [NSString new];
    phoneNumbersTwo = [NSString new];
    
    userAccount = [[NSUserDefaults standardUserDefaults] objectForKey:@"userAccount"];
    watchID = [[NSUserDefaults standardUserDefaults] objectForKey:@"watchID"];
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CMainCell = @"CMainCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CMainCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier: CMainCell];

    }
    [cell setBackgroundColor:DEFAULT_COLOR];
    
    if ([indexPath section] == 0) {
        UILabel *_label = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 60, 34)];
        
        [_label setText:[NSString stringWithFormat:@"白名单%ld",(long)[indexPath row] + 1]];
        
        [_label setFont:[UIFont systemFontOfSize:14]];
        
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(60, 1, SCREEN_WIDTH - 74, 34)];
        
        if ([indexPath row] < 5 && [indexPath row] < whitelist_1.count) {
            [textField setText:[whitelist_1 objectAtIndex:[indexPath row]]];
        }
        
        if ([indexPath row] >= 5 && [indexPath row] < whitelist_2.count) {
            [textField setText:[whitelist_2 objectAtIndex:[indexPath row] - 5]];
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
    if ([indexPath section] == 1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, SCREEN_WIDTH - 14, 34)];
        [label setBackgroundColor:[UIColor whiteColor]];
        
        [label.layer setBorderWidth:0.3f];
        [label.layer setBorderColor:[UIColor grayColor].CGColor];
        [label.layer setCornerRadius:6.f];
        [label setClipsToBounds:YES];
        
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:@"确认"];
        [cell addSubview:label];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    phoneNumbersOne = [NSString new];
    phoneNumbersTwo = [NSString new];
    
    if ([indexPath section] == 1) {
        for (int i = 0; i < 5; i ++) {
            NSString *tempStr = textFields[i].text;
            
            if (tempStr.length > 0 && tempStr.length != 11) {
                [self presentViewController:[Alert getAlertWithTitle:@"输入号码错误"] animated:YES completion:^{
                    ;
                }];
                phoneArray = [NSMutableArray new];
                phoneNumbersOne = [NSString new];
                [textFields[i] becomeFirstResponder];
                return;
            }
            [phoneArray addObject:tempStr];
            if (tempStr) {
                phoneNumbersOne = [NSString stringWithFormat:@"%@,%@",phoneNumbersOne,tempStr];
            }
        }
        
        for (int i = 5; i < 10; i++) {
            NSString *tempStr = textFields[i].text;
            
            if (tempStr.length > 0 && tempStr.length != 11) {
                [self presentViewController:[Alert getAlertWithTitle:@"输入号码错误"] animated:YES completion:^{
                    ;
                }];
                
                [textFields[i] becomeFirstResponder];
                phoneArray = [NSMutableArray new];
                phoneNumbersTwo = [NSString new];
                return;
            }
            if (tempStr) {
                phoneNumbersTwo = [NSString stringWithFormat:@"%@,%@",phoneNumbersTwo,tempStr];
            }

            [phoneArray addObject:tempStr];
            
        }
        NSRange range1 = {1,phoneNumbersOne.length - 1};
        NSRange range2 = {1,phoneNumbersTwo.length - 1};

        NSLog(@"one : %@ two : %@",[phoneNumbersOne substringWithRange:range1],[phoneNumbersTwo substringWithRange:range2]);
        
        NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  userAccount,@"userId",
                                  @"1151102004",@"wid",
                                  [phoneNumbersOne substringWithRange:range1],@"whitelist1",
                                  nil
                                  ];
        [Command commandWithAddress:@"whitelist1" andParamater:tempDict];
        
        NSDictionary *tempDict_2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                    userAccount,@"userId",
                                    @"1151102004",@"wid",
                                    [phoneNumbersTwo substringWithRange:range1],@"whitelist2",
                                    nil
                                    ];
        [Command commandWithAddress:@"whitelist2" andParamater:tempDict_2];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 1;
    }
    return 10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 36;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    currentField = textField;
    [backView setHidden:NO];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"text : %@",textField.text);
    [phoneNumbersList replaceObjectAtIndex:textField.tag withObject:textField.text];
    
    NSLog(@"phoneList : %@",phoneNumbersList);
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
