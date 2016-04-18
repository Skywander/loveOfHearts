//
//  AuthorityViewController.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/19.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "AuthorityViewController.h"
#import "AccountMessage.h"

#import "Navigation.h"

#import "Networking.h"

#import "Command.h"

#import <Masonry/Masonry.h>

#define VIEW_HEIGTH 80
@interface AuthorityViewController ()

{
    NSArray *usersArray;
    NSInteger viewTag;
    
    NSMutableDictionary *_viewDict;
}

@end

@implementation AuthorityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initNavigation];
    
    [self getUserData];

}


- (void)initNavigation{
    Navigation *naviView = [Navigation new];
    
    [self.view addSubview:naviView];
}

- (void)getUserData{
    viewTag = 0;
    
    if ([AccountMessage sharedInstance].wid != NULL) {
        AccountMessage *accountMessage = [AccountMessage sharedInstance];
        NSDictionary *dict = @{
                               @"wid":accountMessage.wid
                               };
        [Networking getUsersMessageWithParamaters:dict block:^(NSDictionary *dict) {
            usersArray = [dict objectForKey:@"data"];
            
            [self initUI];
            
        }];
        
    }else{
        [self initUI];
    }
    _viewDict = [NSMutableDictionary new];
}



- (void)initUI{
    
    [self.view setBackgroundColor:DEFAULT_COLOR];
    float y = 70;
    
    for (NSDictionary *dict in usersArray) {
        NSLog(@"dict : %@",dict);
        
        if ([[dict objectForKey:@"ispowered"] integerValue] != 0 || [AccountMessage sharedInstance].isAdmin == 1) {
            UIView *userView = [self viewWithFirstLabel:[dict objectForKey:@"userId"] secondLabel:[dict objectForKey:@"wid"] relationType:[dict objectForKey:@"relationship"] Admin:[dict objectForKey:@"admin"] andY:y power:[[dict objectForKey:@"ispowered"] integerValue]];
            
            
            [_viewDict setObject:userView forKey:[dict objectForKey:@"wid"]];
            
            y+=90;
            
            [self.view addSubview:userView];

        }
    }
}

- (UIView *)viewWithFirstLabel:(NSString *)textOne secondLabel:(NSString *)textTwo relationType:(NSString *)type Admin:(NSString *)admin andY:(float)y power:(NSInteger)power{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, y, SCREEN_WIDTH - 20, VIEW_HEIGTH)];
    
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,0,SCREEN_WIDTH / 2 - 15, VIEW_HEIGTH / 2)];
    [accountLabel setText:[NSString stringWithFormat:@"用户 : %@",textOne]];
    
    [accountLabel setFont:[UIFont systemFontOfSize:14]];
     
    [accountLabel setTextAlignment:NSTextAlignmentLeft];
    
    [accountLabel setTextColor:[UIColor grayColor]];
    
    UILabel *widLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, VIEW_HEIGTH / 2, SCREEN_WIDTH / 2 - 15, VIEW_HEIGTH /2)];
     
    [widLabel setTextAlignment:NSTextAlignmentLeft];
     
    [widLabel setFont:[UIFont systemFontOfSize:14]];
    
    [widLabel setTextColor:[UIColor grayColor]];
    
    [widLabel setText:[NSString stringWithFormat:@"手表 : %@",textTwo]];
    
    [view addSubview:accountLabel];
    [view addSubview:widLabel];
    //管理员
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20) / 3, 0, (SCREEN_WIDTH - 20) / 3 * 2, VIEW_HEIGTH)];
    
    [label setBackgroundColor:[UIColor clearColor]];
    
    NSString *authorityStr = [NSString new];
    
    if ([admin integerValue] == 1) {
        authorityStr = @"管理员";
    }else{
        authorityStr = @"普通用户";
    }
    
    [label setText:authorityStr];
    
    [label setFont:[UIFont systemFontOfSize:15.f]];
    
    [label setTextAlignment:NSTextAlignmentCenter];
    
    [label setTextColor:[UIColor grayColor]];
    
    [view addSubview:label];
    
    //删除按钮
    
    if (power == 1) {
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20) - VIEW_HEIGTH * 0.75, VIEW_HEIGTH * 0.25, VIEW_HEIGTH / 2, VIEW_HEIGTH / 2)];
        
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        
        [deleteButton setUserInteractionEnabled:YES];
        
        [deleteButton addTarget:self action:@selector(deleteUser:) forControlEvents:UIControlEventTouchUpInside];
        
        deleteButton.tag = viewTag;
        
        [view addSubview:deleteButton];
    }else{
        
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20) - VIEW_HEIGTH, VIEW_HEIGTH * 0.1, VIEW_HEIGTH * 0.8, VIEW_HEIGTH*0.35)];
        [deleteButton setBackgroundColor:[UIColor blueColor]];
        
        [deleteButton setTitle:@"拒绝" forState:UIControlStateNormal];
        
        [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [deleteButton setUserInteractionEnabled:YES];
        
        [deleteButton addTarget:self action:@selector(deleteUser:) forControlEvents:UIControlEventTouchUpInside];
        
        deleteButton.tag = viewTag;
        
        [deleteButton.layer setCornerRadius:3.f];
        [deleteButton.layer setBorderWidth:0.5f];
        
        [view addSubview:deleteButton];
        
        //
        UIButton *agreeButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20) - VIEW_HEIGTH, VIEW_HEIGTH * 0.55, VIEW_HEIGTH * 0.8, VIEW_HEIGTH*0.35)];
        
        [agreeButton setBackgroundColor:[UIColor blueColor]];
        
        [agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        
        [agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [agreeButton setUserInteractionEnabled:YES];
        
        [agreeButton addTarget:self action:@selector(addUser:) forControlEvents:UIControlEventTouchUpInside];
        
        agreeButton.tag = viewTag;
        
        [agreeButton.layer setCornerRadius:3.f];
        
        [agreeButton.layer setBorderWidth:0.5f];
        
        [view addSubview:agreeButton];
    }
    
    [view.layer setCornerRadius:6.F];
    [view.layer setBorderColor:[UIColor grayColor].CGColor];
    [view.layer setBorderWidth:0.3F];
    
    viewTag ++ ;
    
    return view;
}

- (void)deleteUser:(UIButton *)sender{
    
    NSDictionary *currentDict = [usersArray objectAtIndex:sender.tag];
    
    NSLog(@"%@",currentDict);
    
    NSDictionary *paramater = @{
                                @"userId":[currentDict objectForKey:@"userId"],
                                @"wid":[currentDict objectForKey:@"wid"],
                                @"isAdmin":[currentDict objectForKey:@"admin"]
                                };
    
    if ([[currentDict objectForKey:@"userId"] isEqualToString:[AccountMessage sharedInstance].userId] || [AccountMessage sharedInstance].isAdmin == 1){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                 message:@"删除该用户？"
                                                                          preferredStyle:UIAlertControllerStyleAlert
                                              ];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [Networking deleteWatchWithDict:paramater block:^(NSDictionary *dict) {
                NSInteger type = [[dict objectForKey:@"type"] integerValue];
                
                if (type == 100) {
                    
                    if ([[currentDict objectForKey:@"wid"] isEqualToString:[AccountMessage sharedInstance].wid]) {
                        [AccountMessage sharedInstance].wid = NULL;
                    }
                    
                    [_viewDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        if ([key isEqualToString:[currentDict objectForKey:@"wid"]]) {
                            [(UIView *)obj removeFromSuperview];
                        }
                    }];
                }
            }];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 
                                                             }];
        [alertController addAction:sureAction];
        [alertController addAction:cancelAction];
        
        
        [self presentViewController:alertController animated:YES completion:^{
            
        }];

    }else{
        [JKAlert showMessage:@"你没有权限删除该用户"];
    }
    
    return;
}

- (void)addUser:(UIButton *)sender{
    NSDictionary *currentDict = [usersArray objectAtIndex:sender.tag];
    
    NSLog(@"%@",currentDict);
    
    NSDictionary *paramater = @{
                                @"userId":[currentDict objectForKey:@"userId"],
                                @"wid":[currentDict objectForKey:@"wid"],
                                };
    [Command commandWithAddress:@"user_authortyUser" andParamater:paramater block:^(NSInteger type) {
        if (type == 100) {
            
            [_viewDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isEqualToString:[currentDict objectForKey:@"wid"]]) {
                    UIView *view = (UIView *)obj;
                    
                    for (UIView *subview in view.subviews) {
                        if ([subview isMemberOfClass:[UIButton class]]) {
                            [subview removeFromSuperview];
                        }
                        
                        
                        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 20) - VIEW_HEIGTH * 0.75, VIEW_HEIGTH * 0.25, VIEW_HEIGTH / 2, VIEW_HEIGTH / 2)];
                        
                        [deleteButton setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                        
                        [deleteButton setUserInteractionEnabled:YES];
                        
                        [deleteButton addTarget:self action:@selector(deleteUser:) forControlEvents:UIControlEventTouchUpInside];
                                                
                        [view addSubview:deleteButton];
                    }
                }
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
