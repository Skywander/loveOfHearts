//
//  HistoryViewController.m
//  Runner
//
//  Created by 于恩聪 on 15/6/27.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "HistoryViewController.h"
#import "NewFenceView.h"
#import "Navview.h"
#import "AccountMessage.h"
#import "Command.h"

@interface HistoryViewController()
{
    double pointX;
    double pointY;
    
    CLLocationCoordinate2D touchPoints[10];
    
    MAMapView *mapView;
}

@end

@implementation HistoryViewController
@synthesize myMapview;
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initNavigation];
    [self initMapView];
    [self getAndDrawFence];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [mapView removeOverlays:mapView.overlays];
    [mapView removeAnnotations:mapView.annotations];
}

- (void)initNavigation{
    //添加
    
    UIButton *expandButton = [UIButton new];
    
    [expandButton setFrame:CGRectMake(SCREEN_WIDTH - NAVIGATION_HEIGHT, 0, NAVIGATION_HEIGHT, NAVIGATION_HEIGHT)];
    
    [expandButton setTitle:@"删除" forState:UIControlStateNormal];
    
    [expandButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [expandButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    [expandButton addTarget:self action:@selector(expand) forControlEvents:UIControlEventTouchUpInside];
    Navview *navigationView = [Navview new];
    
    [navigationView addSubview:expandButton];
    
    [self.view addSubview:navigationView];
}

- (void)expand{
    NSDictionary *paramater = @{
                                @"wid":[AccountMessage sharedInstance].wid,
                                @"fid":self.fid
                                };
    
    [Command commandWithAddress:@"deletefence" andParamater:paramater];
    
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

- (void)getAndDrawFence {
    int pointCount = 0;
    
    NSLog(@"data : %@",self.fencesDataArray);
    
    NSArray *fencesArray = [self.fencesDataArray componentsSeparatedByString:@";"];
    
    for (NSString *tempString in fencesArray) {
        NSArray *pointArray = [tempString componentsSeparatedByString:@","];
        
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([[pointArray objectAtIndex:1] doubleValue], [[pointArray objectAtIndex:0] doubleValue]);
        
        touchPoints[pointCount] = location;
        points[pointCount] = MAMapPointMake(pointY, pointX);
        pointCount ++;
        
        MAPointAnnotation *tempAnimation = [MAPointAnnotation new];
        tempAnimation.coordinate = location;
        [mapView addAnnotation:tempAnimation];
        
    }
    
    MAPolygon *polygon =[MAPolygon polygonWithCoordinates:touchPoints count:pointCount];
    [mapView setCenterCoordinate:touchPoints[0]];
    [mapView addOverlay:polygon];
}

- (void)initMapView{
    [self.view setBackgroundColor:DEFAULT_COLOR];
    myMapview = [Mymapview sharedInstance];
    [myMapview setFrame:CGRectMake(0, 64,SCREEN_WIDTH,SCREEN_HEIGHT - 84)];
    
    mapView = myMapview.mapView;
    
    
    [self.view addSubview:myMapview];
    
    [self.view sendSubviewToBack:myMapview];
}


@end
