//
//  ViewController.m
//  爱之心
//
//  Created by 于恩聪 on 16/3/9.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewController+delegate.h"
#import "DB.h"

#define START_X 0
#define START_Y 0
#define TOP_HEIGHT 44

@interface HomeViewController ()
{
    Mymapview *mapView;
    HomeMenuView *menuView;
}

@end

@implementation HomeViewController
@synthesize topView;
- (void)viewDidLoad {
    
    NSLog(@"view did load");
    [super viewDidLoad];
    
    [self.view setBackgroundColor:DEFAULT_COLOR];
        
    [self initTopView];
        
    [self initHomeMenuView];
    
    [self initNotification];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
    [self initMapView];
}

- (void)initTopView{
    topView = [[HomeTopView alloc] initWithFrame:CGRectMake(START_X, START_Y, SCREEN_WIDTH, TOP_HEIGHT)];
    
    topView.topViewDelegat = self;
    
    [self.view addSubview:topView];
    
    [topView.expandButton addTarget:self action:@selector(clickExpandButton) forControlEvents:UIControlEventTouchUpInside];
    
    AccountMessage *accountMessage = [AccountMessage sharedInstance];
    
    [DB getImageWithWatchId:accountMessage.wid filename:accountMessage.head block:^(UIImage *image) {
        [topView setImage:image];
    }];

}

- (void)initMapView{
    mapView = [Mymapview sharedInstance];
        
    [mapView setFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    
    mapView.mydelegate = self;
    
    [self.view addSubview:mapView];
    
    [self.view sendSubviewToBack:mapView];
    
    [mapView searchPointWithLat:39.5427 andLon:116.2317];
}

- (void)initHomeMenuView{
    menuView = [[HomeMenuView alloc] initWithFrame:CGRectMake(4, 74, 36, 180)];
    
    menuView.homeDelegat = self;
        
    [self.view addSubview:menuView];
}


- (void)clickExpandButton{
    [self.viewDeckController toggleRightViewAnimated:YES];
}

- (void)initNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage:) name:@"HomeviewUpdateImage" object:nil];
}

- (void)updateImage:(NSNotification *)sender{
    UIImage *image = (UIImage *)sender.object;
    
    [topView setImage:image];
    
    NSLog(@"updateImge");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
