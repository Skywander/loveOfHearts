//
//  ViewController.m
//  爱之心
//
//  Created by 于恩聪 on 16/3/9.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "ViewController.h"
#import "Mymapview.h"
#import "HomeMenuView.h"

#define START_X 0
#define START_Y 0
#define TOP_HEIGHT 44

@interface ViewController ()
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
    [self.view addSubview:topView];
    
    [topView setAddress:@"哈工大"];
    
    [topView.expandButton addTarget:self action:@selector(clickExpandButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initMapView{
    mapView = [Mymapview sharedInstance];
    
    [mapView setFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    
    [self.view addSubview:mapView];
    
    [self.view sendSubviewToBack:mapView];
}

- (void)initHomeMenuView{
    menuView = [[HomeMenuView alloc] initWithFrame:CGRectMake(10, 74, 40, 280)];
    
    [self.view addSubview:menuView];
    
}

- (void)clickExpandButton{
    NSLog(@"click");
    
    [self.viewDeckController toggleRightViewAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
