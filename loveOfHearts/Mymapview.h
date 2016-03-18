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
#import <MAMapKit/MAMapServices.h>

@interface Mymapview : UIView<MAAnnotation,MAMapViewDelegate>

@property (strong,nonatomic) MAMapView *mapView;

+ (instancetype)sharedInstance;

@end
