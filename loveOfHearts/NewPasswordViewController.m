//
//  NewPasswordViewController.m
//  喔喔农机
//
//  Created by 于恩聪 on 15/12/23.
//  Copyright © 2015年 于恩聪. All rights reserved.
//

#import "NewPasswordViewController.h"
#import <Masonry/Masonry.h>
#import "Command.h"

#define LABEL_COLOR [UIColor grayColor]

#define HIGH_COLOR [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1]



@interface NewPasswordViewController ()
{
    UITextField *password;
    UITextField *newPassword;
    
    UIButton *sureButton;
}

@end

@implementation NewPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    [self makeConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)initUI{
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    
    [self initNavigation];
    
    password = [self textFieldWithImageName:@"userpassword" andPlaceholder:@" 输入新密码"];
    newPassword = [self textFieldWithImageName:@"userpassword" andPlaceholder:@" 确认新密码"];
    
    sureButton = [UIButton new];
    [sureButton setBackgroundColor:[UIColor whiteColor]];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [sureButton setTitleColor:DEFAULT_COLOR forState:UIControlStateHighlighted];
    
    [sureButton.layer setCornerRadius:CORNER_RIDUS];
    
    [sureButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    [sureButton addTarget:self action:@selector(touchInsideButton:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:sureButton];
    
}
- (void)initNavigation{
    CGFloat statusBarHeight=0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight=20;
        UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        [self.view addSubview:statusView];
        
        [statusView setBackgroundColor:NAVI_COLOR];
    }
    
    //创建一个导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0+statusBarHeight, self.view.frame.size.width, 44)];
    
    [navigationBar setBarTintColor:NAVI_COLOR];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(clickLeftButton)];
    [leftButton setTintColor:NAVI_FONT_COLOR];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [navigationItem setLeftBarButtonItem:leftButton];
    
    [self.view addSubview:navigationBar];
    
}
- (UITextField *)textFieldWithImageName:(NSString *)imageName andPlaceholder:(NSString *)placeholder{
    UITextField *textField = [UITextField new];
    [textField setBackgroundColor:[UIColor whiteColor]];
    
    [textField.layer setBorderWidth:0.3f];
    [textField.layer setBorderColor:[UIColor whiteColor].CGColor];
    [textField.layer setCornerRadius:6.f];
    
    [textField setPlaceholder:placeholder];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [imageView setFrame:CGRectMake(0, 0, CELL_HEIGHT, CELL_HEIGHT)];
    
    [textField setLeftView:imageView];
    
    [textField setLeftViewMode:UITextFieldViewModeAlways];
    
    [self.view addSubview:textField];
    
    
    return textField;
}

- (void)makeConstraints{
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(OFFSET);
        make.right.equalTo(self.view).with.offset(OFFSET);
        make.top.equalTo(self.view).with.equalTo(@80);
        make.height.equalTo(@(CELL_HEIGHT));
    }];
    [newPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(password);
        make.right.equalTo(password);
        make.top.equalTo(password).with.offset(CELL_HEIGHT + OFFSET);
        make.height.equalTo(@(CELL_HEIGHT));
    }];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(password);
        make.right.equalTo(password);
        make.top.equalTo(newPassword).with.offset(CELL_HEIGHT + OFFSET);
        make.height.equalTo(@(CELL_HEIGHT));

    }];
}

- (void)clickLeftButton{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)clickSureButton{
    [sureButton setBackgroundColor:[UIColor whiteColor]];
    

    
    
    
}
- (void)touchInsideButton:(UIButton *)sender{
    [sender setBackgroundColor:HIGH_COLOR];
}



@end
