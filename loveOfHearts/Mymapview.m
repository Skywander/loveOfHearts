//
//  Mymapview.m
//  爱之心
//
//  Created by 于恩聪 on 15/9/21.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import "Mymapview.h"
#import "Constant.h"
#import <Masonry/Masonry.h>

#define ZOOMINVALUE 0.3

#define ZOOMOUTVALUE 0.3

static Mymapview *mymapview;

@interface Mymapview()
{
    AMapSearchAPI *_searchAPI;
    
    NSString *detailAddress;
}

@end

@implementation Mymapview
@synthesize mapView;
@synthesize coordinate;
//@synthesize _search;
+ (instancetype) sharedInstance {
    if (mymapview) {
        return mymapview;
    }else {
        mymapview = [[self alloc] init];
    }
    return mymapview;
}

- (instancetype)init{
    self = [super init];
    [MAMapServices sharedServices].apiKey = APIKey;
    [AMapSearchServices sharedServices].apiKey = APIKey;
    _searchAPI = [[AMapSearchAPI alloc] init];
    _searchAPI.delegate = self;

    mapView = [[MAMapView alloc]init];
    mapView.delegate = self;
    mapView.customizeUserLocationAccuracyCircleRepresentation = YES;//允许定义精度圈的样式
    mapView.showsCompass = NO;
    mapView.showsScale = NO;
    mapView.showsUserLocation = YES;
    mapView.centerCoordinate = CLLocationCoordinate2DMake(38.931694, 116.381060);
    mapView.frame = CGRectMake(0,0, self.frame.size.width,self.frame.size.height);
    mapView.layer.cornerRadius = 5.f;
    
    mapView.zoomLevel = 15;
    
    mapView.touchPOIEnabled = YES;
    
    [self addSubview:mapView];
    
    [self initZoomView];
    
    [self searchPointWithLat:39.989631 andLon:116.481018];

    
    return self;
}

- (void)initZoomView{
    //放大
    UIButton *zoominButton = [UIButton new];
    [zoominButton setBackgroundImage:[UIImage imageNamed:@"zoomin"] forState:UIControlStateNormal];
    [zoominButton addTarget:self action:@selector(zoomIn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:zoominButton];
    //缩小
    UIButton *zoomoutButton = [UIButton new];
    [zoomoutButton setBackgroundImage:[UIImage imageNamed:@"zoomout"] forState:UIControlStateNormal];
    [zoomoutButton addTarget:self action:@selector(zoomOut) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:zoomoutButton];
    
    [zoominButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-10);
        make.bottom.equalTo(self).with.offset(-10);
        make.width.equalTo(@(31));
        make.height.equalTo(@(43));
    }];
    
    [zoomoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(zoominButton);
        make.left.equalTo(zoominButton);
        make.height.equalTo(zoominButton);
        make.bottom.equalTo(zoominButton).with.offset(-43);
    }];
    
    
}

- (void)zoomIn{
    mapView.zoomLevel = mapView.zoomLevel + ZOOMINVALUE;
}

- (void)zoomOut{
    mapView.zoomLevel = mapView.zoomLevel - ZOOMOUTVALUE;
}
//地图的回调

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
        circleView.strokeColor = DEFAULT_PINK;
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
        polylineView.strokeColor = DEFAULT_PINK;
        polylineView.lineJoinType = kMALineJoinRound;//连接类型
        polylineView.lineCapType = kMALineCapRound;//端点类型
        
        return polylineView;
    }
    //多边形的回调函数
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonView *_polygonView = [[MAPolygonView alloc] initWithPolygon:overlay];
        
        _polygonView.lineWidth = 2.f;
        _polygonView.strokeColor = DEFAULT_PINK;
        _polygonView.fillColor = [UIColor whiteColor];
        _polygonView.lineJoinType = kMALineJoinMiter;//连接类型
        
        return _polygonView;
    }
    return nil;
}

//SEARCH DELEGATE
//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        NSLog(@"ReGeo: %@", result);
        
        AMapAddressComponent *component = response.regeocode.addressComponent;
        
        NSLog(@"Mapresponse : city : %@ district : %@  neighborhoood : %@ description : %@",component.city,component.district,component.neighborhood,component.province);
        
        detailAddress = [NSString stringWithFormat:@"%@%@-%@%@",component.province,component.city,component.district,component.neighborhood];
        
        if([_mydelegate respondsToSelector:@selector(passValue:)]){
            [_mydelegate passValue:detailAddress];
        }
    }
}

- (NSString *)searchPointWithLat:(double)lat andLon:(double)lon{
    //构造AMapReGeocodeSearchRequest对象
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:lat longitude:lon];
    regeo.radius = 10000;
    regeo.requireExtension = YES;
    
    //发起逆地理编码
    [_searchAPI AMapReGoecodeSearch: regeo];
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);
    pointAnnotation.title = @"方恒国际";
    pointAnnotation.subtitle = @"阜通东大街6号";
    
    [mapView addAnnotation:pointAnnotation];
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(39.989631, 116.481018)];
    
    return detailAddress;

}

@end
