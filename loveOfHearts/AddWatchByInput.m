

//
//  AddWatchByInput.m
//  爱之心
//
//  Created by 于恩聪 on 15/10/7.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "AddWatchByInput.h"
#import "Constant.h"
#import "Networking.h"
@interface AddWatchByInput()
{
    CGFloat basicY;
    CGFloat basicMove;
    
    UITextField *relationField;
    UITextField *idField;
    
    NSString *user_id;
        
    NSString *relation;
}

@end

@implementation AddWatchByInput
@synthesize shouhuan_id;
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initData];

    
    [self initUI];
}
- (void)initData{
    basicMove = 40;
    
    basicY = 70;
    
    user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
}

- (void)initUI{
    [self.view setBackgroundColor:DEFAULT_COLOR];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(6, basicY + basicMove * 2, SCREEN_WIDTH - 12, 36)];
    
    [label setText:@"输入关系"];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setTextColor:[UIColor blackColor]];
    
    [self.view addSubview:label];
    
    relationField = [[UITextField alloc] initWithFrame:CGRectMake(6, basicY + basicMove * 3, SCREEN_WIDTH - 12, 36)];
    [relationField setBackgroundColor:[UIColor whiteColor]];
    [relationField.layer setBorderColor:[UIColor grayColor].CGColor];
    [relationField.layer setBorderWidth:0.3f];
    [relationField.layer setCornerRadius:6.f];
    
    [self.view addSubview:relationField];
    
    UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, basicY , SCREEN_WIDTH - 12, 36)];
    
    [idLabel setTextColor:[UIColor blackColor]];
    [idLabel setTextAlignment:NSTextAlignmentLeft];
    [idLabel setText:@"输入手环ID"];
    
    [self.view addSubview:idLabel];
    
    idField = [[UITextField alloc] initWithFrame:CGRectMake(6, basicY + basicMove, SCREEN_WIDTH - 12, 36)];
    [idField setBackgroundColor:[UIColor whiteColor]];
    [idField.layer setBorderWidth:0.3f];
    [idField.layer setBorderColor:[UIColor grayColor].CGColor];
    [idField.layer setCornerRadius:6.f];
    [idField setKeyboardType:UIKeyboardTypeNumberPad];
    
    if (shouhuan_id) {
        [idField setText:shouhuan_id];
    }
    
    [self.view addSubview:idField];
    
    
    UIButton *sureButton = [[UIButton alloc] initWithFrame:CGRectMake(6, basicMove * 5 + basicY, SCREEN_WIDTH - 12, 36)];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureButton setTitleColor:DEFAULT_COLOR forState:UIControlStateHighlighted];
    [sureButton setBackgroundColor:[UIColor whiteColor]];
    
    [sureButton.layer setBorderColor:[UIColor grayColor].CGColor];
    [sureButton.layer setBorderWidth:0.3f];
    [sureButton.layer setCornerRadius:6.f];
    [sureButton addTarget:self action:@selector(clickSureButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sureButton];
}

- (void)clickSureButton {
    if (relationField.text.length <= 0 || idField.text.length <= 0 ) {
    }
    
    shouhuan_id = idField.text;
    
    relation = relationField.text;
    
    [self addShouhuan];

}

- (void)addShouhuan{

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
