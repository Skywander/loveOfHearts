//
//  Mymapview.h
//  爱之心
//
//  Created by 于恩聪 on 15/9/21.
//  Copyright (c) 2015年 于恩聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapServices.h>
#import "MapProtocolDelegate.h"

@interface Mymapview : UIView<MAAnnotation,MAMapViewDelegate,AMapSearchDelegate>

@property (strong,nonatomic) MAMapView *mapView;


@property (weak,nonatomic) id <MapProtocolDelegate>mydelegate;

+ (instancetype)sharedInstance;

- (NSString *)searchPointWithLat:(double)lat andLon:(double)lon;

@end
