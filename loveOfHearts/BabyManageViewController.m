//
//  BabyManageViewController.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/15.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "BabyManageViewController.h"
#import "AccountMessage.h"
#import "Networking.h"
#import "Navview.h"
#import "AddWatchViewController.h"
#import "PersonInforViewController.h"

#define VIEW_HEIGHT 80

@interface BabyManageViewController ()
{    
    Networking *netWorking;
    
    AccountMessage *accountMessage;
    
    NSArray *deviceArray;
    
    float y;
}
@end

@implementation BabyManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self getData];
    
}

- (void)getData{    
    accountMessage = [AccountMessage sharedInstance];
    
    NSString *userId = accountMessage.userId;
    
    NSDictionary *paramater = @{
                                    @"userId":userId
                                    };
    
    [Networking getDevicesMessageWithParamaters:paramater block:^(NSDictionary *dict) {
        deviceArray = [dict objectForKey:@"data"];
        
        [self initView];
    }];
}



- (void)initView{
    y = 70;
    for (NSDictionary *dict in deviceArray) {
        
        NSDictionary *paramater = @{
                               @"wid":[dict objectForKey:@"wid"],
                               @"fileName":accountMessage.head
                               };
        
        [Networking getWatchPortiartWithDict:paramater blockcompletion:^(UIImage *image) {
            NSLog(@" image : %@",image);
            
            UIView *view = [self viewWithWatchImage:image andY:y andWatchId:[dict objectForKey:@"wid"]];
            
            y = y + VIEW_HEIGHT + 10;
            
            [self.view addSubview:view];
        }];
        
    }
}

- (UIView *)viewWithWatchImage:(UIImage *)image andY:(float)getY andWatchId:(NSString *)watchId{
    UIView *view = [UIView new];
    
    [view setFrame:CGRectMake(10, getY, SCREEN_WIDTH - 20, VIEW_HEIGHT)];
    
    [view setBackgroundColor:[UIColor whiteColor]];
    
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    [imageView setFrame:CGRectMake(20, 20, VIEW_HEIGHT - 40, VIEW_HEIGHT - 40)];
    
    [imageView.layer setBorderWidth:0.3f];
    [imageView.layer setCornerRadius:(VIEW_HEIGHT - 40)/2];
    
    [imageView setClipsToBounds:YES];
    
    [view addSubview:imageView];
    
    UILabel *watchIdLabel = [UILabel new];
    
    [watchIdLabel setFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, VIEW_HEIGHT)];
    
    [watchIdLabel setBackgroundColor:[UIColor clearColor]];
    
    [watchIdLabel setText:watchId];
    
    [watchIdLabel setTextAlignment:NSTextAlignmentCenter];
    
    [view addSubview:watchIdLabel];
    
    
    [view.layer setCornerRadius:6.f];
    [view.layer setBorderColor:[UIColor grayColor].CGColor];
    [view.layer setBorderWidth:0.3f];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [view addGestureRecognizer:singleTap];
    
    return view;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender

{
    
    PersonInforViewController *personInforView = [PersonInforViewController new];
    
    [self presentViewController:personInforView animated:YES completion:^{
        ;
    }];
    
}

- (void)initNavigation{
    
    [self.view setBackgroundColor:DEFAULT_COLOR];
  
    //添加
    
    UIButton *expandButton = [UIButton new];
    
    [expandButton setFrame:CGRectMake(SCREEN_WIDTH - NAVIGATION_HEIGHT, 0, NAVIGATION_HEIGHT, NAVIGATION_HEIGHT)];
    
    [expandButton setTitle:@"添加" forState:UIControlStateNormal];
    
    [expandButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [expandButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    [expandButton addTarget:self action:@selector(expand) forControlEvents:UIControlEventTouchUpInside];


    Navview *navigationView = [Navview new];
    
    [navigationView addSubview:expandButton];
    
    [self.view addSubview:navigationView];
}


- (void)expand{
    AddWatchViewController *add = [AddWatchViewController new];
    
    [self presentViewController:add animated:YES completion:^{
        ;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
