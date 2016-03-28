//
//  ChangePassword.m
//  爱之心
//
//  Created by 于恩聪 on 15/9/7.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "ChangePassword.h"
#import "Constant.h"
#import "Networking.h"
#import "Navview.h"
#import "AccountMessage.h"
#import "Command.h"

#define ICON_WIDTH 36

@interface ChangePassword()
{
    CGFloat basicY;
    CGFloat basicMove;
    
    UILabel *passwordLabel;
    UILabel *passwordAgainLabel;
    
    UITextField *oldTextField;
    UITextField *newTextField;
    UITextField *newAgainTextField;
    
    UIButton *sureButton;
    
    NSString *oldPassword;
    NSString *newPassword;
    
    AccountMessage *accountMessage;
}
@end

@implementation ChangePassword
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
}

- (void)initData{
    accountMessage = [AccountMessage sharedInstance];
}

- (void)initUI {
    [self.view setBackgroundColor:DEFAULT_COLOR];
    
    Navview *navigation = [Navview new];
    [self.view addSubview:navigation];
    
    basicY = 70.f;
    
    basicMove = 40;
    
    oldTextField = [self textFieldWithPlaceholder:@"输入原秘密" andPointY:basicY];
    
    newTextField = [self textFieldWithPlaceholder:@"输入新密码" andPointY:basicY + basicMove];
    
    newAgainTextField = [self textFieldWithPlaceholder:@"重新输入新密码" andPointY:basicY + basicMove * 2];
    
    sureButton = [[UIButton alloc] initWithFrame:CGRectMake(6, basicMove * 3 + basicY, SCREEN_WIDTH - 12, 36)];
    [sureButton setBackgroundColor:[UIColor whiteColor]];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [sureButton setTitleColor:DEFAULT_COLOR forState:UIControlStateHighlighted];
    
    [sureButton.layer setCornerRadius:6.f];
    
    [sureButton addTarget:self action:@selector(makeSure) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sureButton];
}

- (UILabel *)labelWithTitle:(NSString *)title andPointY:(CGFloat)pointY {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(6, pointY, SCREEN_WIDTH - 12, 36)];
    [label setBackgroundColor:[UIColor whiteColor]];
    
    [label setText:title];
    [label setTextColor:[UIColor blackColor]];
    [label setTextAlignment:NSTextAlignmentLeft];
    
    [self.view addSubview:label];
    
    return label;
}

- (UITextField *)textFieldWithPlaceholder:(NSString *)text andPointY:(CGFloat)pointY {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(6.f, pointY, SCREEN_WIDTH - 12, 36)];
    [textField setBackgroundColor:[UIColor whiteColor]];
    
    [textField.layer setCornerRadius:6.f];
    
    [textField setPlaceholder:text];
    
    UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginPassword.png"]];
    [leftView setFrame:CGRectMake(6, 6, 24, 24)];
    [leftView setClipsToBounds:YES];
    [textField setLeftViewMode:UITextFieldViewModeAlways];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ICON_WIDTH, ICON_WIDTH)];
    [textField setLeftView:backView];
    [textField addSubview:leftView];
    
    [textField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [textField setClearsOnBeginEditing:YES];
    
    [self.view addSubview:textField];
    
    return  textField;
}

- (void)makeSure {
    
    NSDictionary *paramater = @{
                                @"userId":accountMessage.userId,
                                @"userPw":oldTextField.text,
                                @"confirm":newTextField.text
                                };
    
    
    [Command commandWithAddress:@"passwordreset" andParamater:paramater];
    
    [self.view endEditing:YES];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
