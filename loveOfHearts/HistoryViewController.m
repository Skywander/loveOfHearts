//
//  HistoryViewController.m
//  Runner
//
//  Created by 于恩聪 on 15/6/27.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "HistoryViewController.h"
#import "Fence.h"
#import "Networking.h"
#import "NewFenceView.h"
#import "Navview.h"

@interface HistoryViewController()
{
    double pointX;
    double pointY;
    double radius;
    
    CLLocationCoordinate2D touchPoints[10];
    
    Fence *fence;
    NSString *startTime;
    NSString *endTime;
    
    UILabel *timeLabel;
    UILabel *typeLabel;
    
    NSString *shouhuan_id;
    NSString *user_id;
}

@end

@implementation HistoryViewController
@synthesize mapView,resetButton,deleteButton;
@synthesize deleteAlertView,resetAlertView;
@synthesize fencenameList,dangerFencenames;
@synthesize zoomoutButton,zoominButton;
@synthesize fenceName;
@synthesize myMapview;
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initNavigation];
    [self initMapView];
    [self getAndDrawFence];
//    [self initLabel];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [mapView removeOverlays:mapView.overlays];
    [mapView removeAnnotations:mapView.annotations];
}

- (void)initNavigation{
    Navview *navigationView = [Navview new];
    
    [self.view addSubview:navigationView];
}

- (void)getAndDrawFence {
    int pointCount = 0;
    
    
    
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
    mapView.delegate = self;
    
    [mapView removeOverlays:mapView.overlays];
    [mapView removeAnnotations:mapView.annotations];
    
    [self.view addSubview:myMapview];
    
    [self.view sendSubviewToBack:myMapview];

}

- (void)initLabel{
    CGFloat basicY = 83;
    
    CGFloat basicMove = 20;
    
    NSLog(@"time : %@",fence.time);
    
    timeLabel = [self labelWithTitle:[NSString stringWithFormat:@"监护时间:%@",fence.time] andY:basicY];
    
    NSMutableArray *alarmArray = [NSMutableArray arrayWithObjects:@"进入警报",@"离开警报",@"进出警报", nil];
    
    NSString *tempStr = [alarmArray objectAtIndex:[fence.type intValue] - 1];
    
    typeLabel = [self labelWithTitle:[NSString stringWithFormat:@"警告类型:%@",tempStr] andY:basicY + basicMove];
}

- (UILabel *)labelWithTitle:(NSString *)labeltext andY:(CGFloat)y{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, y, SCREEN_WIDTH - 20, 20)];
    [label setText:labeltext];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setTextColor:DEFAULT_COLOR];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont systemFontOfSize:12]];
    
    [self.view addSubview:label];
    
    return label;
}
- (void)zoomIn {
    mapView.zoomLevel = mapView.zoomLevel * 0.8;
}
- (void)zoomOut {
    mapView.zoomLevel = mapView.zoomLevel * 1.2;
}

//画annotation的回调函数
- (MAAnnotationView *)mapView:(MAMapView *)_mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[_mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
        annotationView.pinColor = MAPinAnnotationColorGreen;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = NO;
        
        annotationView.image = [UIImage imageNamed:@"animationView"];
        
        [annotationView setFrame:CGRectMake(0, 0, 10, 10)];
        [annotationView setClipsToBounds:YES];
        
        return annotationView;
    }
    if ([annotation isKindOfClass:[MAUserLocation class]]) {
        static NSString *userLocationStyleReuseIndentifier = @"userLocationStyleReuseIndentifier";
        MAAnnotationView *annotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[MAAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:userLocationStyleReuseIndentifier];
        }
        return annotationView;
    }
    return nil;
}

//画多边形的回调函数
- (MAOverlayView *)mapView:(MAMapView *)_mapView viewForOverlay:(id <MAOverlay>)overlay
{
    //自定义精度圈
    if (overlay == _mapView.userLocationAccuracyCircle) {
        MACircleView *accuracyCircleView = [[MACircleView alloc]initWithCircle:overlay];
        accuracyCircleView.lineWidth = 2.f;
        accuracyCircleView.strokeColor = [UIColor lightGrayColor];
        accuracyCircleView.fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0];
        return accuracyCircleView;
    }
    //画圆的回调函数
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleView *circleView = [[MACircleView alloc] initWithCircle:overlay];
        
        circleView.lineWidth = 5.f;
        circleView.strokeColor = DEFAULT_COLOR;
        circleView.fillColor = [UIColor colorWithRed:252/255.0 green:92/255.0 blue:64/255.0 alpha:0.5];
        circleView.lineJoinType = kMALineJoinRound;
        circleView.lineDash = YES;
        
        return circleView;
    }
    //画折线的回调函数
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth = 5.f;
        polylineView.strokeColor = DEFAULT_COLOR;
        polylineView.lineJoinType = kMALineJoinRound;//连接类型
        polylineView.lineCapType = kMALineCapRound;//端点类型
        
        return polylineView;
    }
    //多边形的回调函数
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonView *_polygonView = [[MAPolygonView alloc] initWithPolygon:overlay];
        
        _polygonView.lineWidth = 2.f;
        _polygonView.strokeColor = DEFAULT_COLOR;
        _polygonView.fillColor = [UIColor whiteColor];
        _polygonView.lineJoinType = kMALineJoinMiter;//连接类型
        
        return _polygonView;
    }
    
    
    return nil;
}


@end
