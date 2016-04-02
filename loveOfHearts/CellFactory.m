//
//  CellFactory.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/4/1.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "CellFactory.h"
#import "AccountMessage.h"

@implementation CellFactory

+ (UIView *)CellFactoryWithDict:(NSDictionary *)dict{
    
    NSString *fromId = [dict objectForKey:@"fromId"];
    
    UIView *view;
    
    if ([fromId isEqualToString:[AccountMessage sharedInstance].userId]) {
        view = [LeftCellView initWithDict:dict];
    } else{
        view = [RightCellView initWithDict:dict];
    }
    
    return view;
}

@end
