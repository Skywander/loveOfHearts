//
//  CellFactory.h
//  loveOfHearts
//
//  Created by 于恩聪 on 16/4/1.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "RightCellView.h"

#import "LeftCellView.h"

@interface CellFactory : NSObject

+ (UIView *)CellFactoryWithDict:(NSDictionary *)dict;

@end
