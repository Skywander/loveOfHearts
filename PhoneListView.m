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
#import "Navview.h"

@interface PhoneListView()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
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
    
    [self getData];
    
    [self initUI];
}

- (void)getData {
    pushStringtwo = [NSString new];
    pushStringone = [NSString new];
    
    phbArray = [[AccountMessage sharedInstance].phb componentsSeparatedByString:@","];
    
    NSArray *tempArray = [[AccountMessage sharedInstance].phb2 componentsSeparatedByString:@","];
    
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
    
    Navview *navigationView = [Navview new];
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
        
        UITextField *nameField = [[UITextField alloc] initWithFrame:CGRectMake(1, 1, (SCREEN_WIDTH  - 15)/ 3, 34)];
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
        
        UITextField *phoneField = [[UITextField alloc] initWithFrame:CGRectMake(2 + (SCREEN_WIDTH - 15)/ 3, 1, (SCREEN_WIDTH - 15)/ 3 * 2, 34)];
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
            [nameField setText:[phbArray objectAtIndex:[indexPath row] * 2]];
        }
        if ([indexPath row] * 2 + 1 < phbArray.count && [phbArray objectAtIndex:[indexPath row] * 2 + 1]) {
            [phoneField setText:[phbArray objectAtIndex:[indexPath row] * 2 + 1]];
        }
        
        [cell addSubview:phoneField];

        
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath section] == 1) {
        NSLog(@"确认");
        [backView setHidden:NO];
        [self.view bringSubviewToFront:backView];
        
        for (int i = 0; i < 5; i ++) {
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
            if (phoneFields[i].text.length != 0 ) {
                pushStringone = [NSString stringWithFormat:@"%@,%@,%@",pushStringone,nametempStr,phonetempStr];
            }
        }
        
        for (int i = 5; i < 10; i ++) {
            NSString *nametempStr = nameFields[i].text;
            NSString *phonetempStr = phoneFields[i].text;
            
            if (phoneFields[i].text.length > 0 && phoneFields[i].text.length != 11) {
                [self presentViewController:[Alert getAlertWithTitle:@"输入的号码不正确"] animated:YES completion:^{
                    ;
                }];
                pushStringtwo = [NSString new];
                [phoneFields[i] becomeFirstResponder];
                return;
            }
            if (phoneFields[i].text.length != 0) {
                pushStringtwo = [NSString stringWithFormat:@"%@,%@,%@",pushStringtwo,nametempStr,phonetempStr];
            }
        }
        
        NSRange range1 = {1,pushStringone.length - 1};
        
        NSRange range2 = {1,pushStringtwo.length - 1};
        
        NSLog(@"PHB %@ %@",[pushStringone substringWithRange:range1],[pushStringtwo substringWithRange:range2]);
        
        NSLog(@"pushStringone : %@ pushStringTwo: %@",pushStringone,pushStringtwo);
        
        if (pushStringone.length != 0) {
            NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      userAccount,@"userId",
                                      watchID,@"wid",
                                      [pushStringone substringWithRange:range1],@"PHB",
                                      nil
                                      ];
            [Command commandWithAddress:@"phones" andParamater:tempDict];
        }
        if (pushStringtwo.length != 0) {
            NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      userAccount,@"userId",
                                      watchID,@"wid",
                                      [pushStringone substringWithRange:range1],@"PHB2",
                                      nil
                                      ];
            [Command commandWithAddress:@"phones" andParamater:tempDict];

        }
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
