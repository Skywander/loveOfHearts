

//
//  AddWatchByInput.m
//  爱之心
//
//  Created by 于恩聪 on 15/10/7.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "AddWatchByInput.h"
#import "AddWatchByInput+delegate.h"
#import "Networking.h"
#import "Navigation.h"
#import "AccountMessage.h"

@interface AddWatchByInput()
{
    CGFloat basicY;
    CGFloat basicMove;
    
    UITextField *widTextField;
        
    NSString *relation;
    
    AccountMessage *accountMessage;
}

@end

@implementation AddWatchByInput
@synthesize listView;
- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self initData];

    [self initUI];
}
- (void)initData{
    basicMove = 45;
    
    basicY = 70;
    
    self.relationArray = [NSArray arrayWithObjects:@"爸爸",@"妈妈",@"爷爷",@"奶奶",@"外公",@"外婆",@"叔叔",@"阿姨",@"其它",nil];
    
    accountMessage = [AccountMessage sharedInstance];
    
}

- (void)initUI{
    [self.view setBackgroundColor:DEFAULT_COLOR];
    
    Navigation *navigation = [[Navigation alloc] init];
    
    [navigation addRightViewWithName:@"确定"];
    
    [navigation setDelegate:self];
    
    [self.view addSubview:navigation];
    
    widTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, basicY, SCREEN_WIDTH - 10,40)];
    
    [widTextField.layer setCornerRadius:CORNER_RIDUS];
    [widTextField setKeyboardType:UIKeyboardTypeDefault];
    
    UIImageView *userLeftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"username"]];
    [userLeftView setFrame:CGRectMake(0, 0, 50, 50)];
    [widTextField setLeftView:userLeftView];
    [widTextField setLeftViewMode:UITextFieldViewModeAlways];
    [widTextField setBackgroundColor:[UIColor whiteColor]];
    
    if (self.wid) {
        [widTextField setText:self.wid];
    }
    
    [self.view addSubview:widTextField];
    
    //下拉列表
    self.relationButton = [[UIButton alloc] initWithFrame:CGRectMake(5, basicY + basicMove, SCREEN_WIDTH - 10, 40)];
    
    [self.relationButton setBackgroundColor:[UIColor whiteColor]];
    
    [self.relationButton setTitle:@"选择关系" forState:UIControlStateNormal];
    
    [self.relationButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self.relationButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    [self.relationButton.layer setCornerRadius:3.f];
    
    [self.relationButton addTarget:self action:@selector(showListView) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.relationButton];
    
    listView = [[UITableView alloc] initWithFrame:CGRectMake(5, basicMove * 2 + basicY, SCREEN_WIDTH - 10, 360)];
    listView.dataSource = self;
    listView.delegate = self;
    listView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [listView setHidden:YES];
    
    [self.view addSubview:listView];
}

- (void)showListView{
    
    if (listView.hidden) {
        [listView setHidden:NO];
    }else{
        [listView setHidden:YES];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
    if (!listView.hidden) {
        listView.hidden = YES;
    }
}

- (void)clickNavigationRightView{
    
    NSInteger type = [self.relationArray indexOfObject:self.relationButton.titleLabel.text];
    
    NSString *typeString = [NSString stringWithFormat:@"%ld",type];
    
    NSDictionary *dict = @{
                            @"userId":accountMessage.userId,
                            @"wid":widTextField.text,
                            @"relations":self.relationButton.titleLabel.text,
                            @"type":typeString,
                           };
    [Networking uploalDataWithAddress:@"bind" dict:dict block:^(int i) {
        ;
    }];
}


@end
