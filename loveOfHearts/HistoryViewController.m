//
//  HistoryViewController.m
//  Runner
//
//  Created by 于恩聪 on 15/6/27.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "HistoryViewController.h"
#import "NewFenceView.h"
#import "Navigation.h"
#import "AccountMessage.h"
#import "Command.h"
#import "NavigationProtocol.h"

@interface HistoryViewController()<NavigationProtocol>
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
    Navigation *navigationView = [Navigation new];
        
    [navigationView setDelegate:self];
    
    [navigationView addRightViewWithName:@"删除"];
    
    [self.view addSubview:navigationView];
}


- (void)clickNavigationRightView{
    NSDictionary *paramater = @{
                                @"wid":[AccountMessage sharedInstance].wid,
                                @"fid":self.fid
                                };
    
    [Command commandWithAddress:@"deletefence" andParamater:paramater block:^(NSInteger type) {
        if (type == 100) {
            [self dismissViewControllerAnimated:YES completion:^{
                ;
            }];
        }
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
