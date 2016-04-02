//
//  ViewController.m
//  爱之心
//
//  Created by 于恩聪 on 16/3/9.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "ViewController.h"
#import "MapProtocolDelegate.h"
#import "Mymapview.h"
#import "HomeMenuView.h"
#import "ChatViewController.h"
#import "Networking.h"
#import "TopviewProltocol.h"
#import "PersonInforViewController.h"

#define START_X 0
#define START_Y 0
#define TOP_HEIGHT 44

@interface ViewController ()<MapProtocolDelegate,TopviewProltocol>
{
    Mymapview *mapView;
    HomeMenuView *menuView;
}

@end

@implementation ViewController
@synthesize topView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:DEFAULT_COLOR];
        
    [self initTopView];
        
    [self initHomeMenuView];    
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
    [self initMapView];
}

- (void)initTopView{
    topView = [[TopView alloc] initWithFrame:CGRectMake(START_X, START_Y, SCREEN_WIDTH, TOP_HEIGHT)];
    
    topView.topViewDelegat = self;
    
    [self.view addSubview:topView];
    
    [topView.expandButton addTarget:self action:@selector(clickExpandButton) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    AccountMessage *accountMessage = [AccountMessage sharedInstance];
    
    NSString *wid = accountMessage.wid;
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    
    NSString *imagePath = [NSString stringWithFormat:@"%@%@.png",documentPath,[AccountMessage sharedInstance].head];
    
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    
    [imageData writeToFile:imagePath atomically:NO];
    
    UIImage *image = [UIImage imageWithData:imageData];
    
    if (image) {
        NSLog(@"exist image");
        [topView setImage:image];
        
        accountMessage.image = image;
        
    }else{
        NSDictionary *paramater = @{
                                    @"wid":wid,
                                    @"fileName":accountMessage.head
                                    };
        [Networking getWatchPortiartWithDict:paramater blockcompletion:^(UIImage *image) {
            [topView setImage:image];
            accountMessage.image = image;
        }];
        
    }
}

- (void)initMapView{
    mapView = [Mymapview sharedInstance];
    
    [mapView setFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    
    mapView.mydelegate = self;
    
    [self.view addSubview:mapView];
    
    [self.view sendSubviewToBack:mapView];
    
    [mapView searchPointWithLat:39.989631 andLon:116.481018];
    

}

- (void)initHomeMenuView{
    menuView = [[HomeMenuView alloc] initWithFrame:CGRectMake(10, 74, 40, 280)];
        
    [self.view addSubview:menuView];
    
}


- (void)clickExpandButton{
    
    [self.viewDeckController toggleRightViewAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)passValue:(NSString *)string{
    [topView setAddress:string];
}

- (void)presentPersonInfoView{
    PersonInforViewController *personInfoView = [PersonInforViewController new];
    
    [self presentViewController:personInfoView animated:YES completion:^{
        ;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(menuView.frame, point)) {
        NSLog(@"click menu");
        
        ChatViewController *chatView = [ChatViewController new];
        
        [self presentViewController:chatView animated:YES completion:^{
            ;
        }];
    }

}

@end
