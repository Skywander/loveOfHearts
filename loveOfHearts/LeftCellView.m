//
//  LeftCellView.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/4/1.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "LeftCellView.h"
#import "AccountMessage.h"

@implementation LeftCellView

+ (UIView *)initWithDict:(NSDictionary *)dict{
    
    NSLog(@"create left view");
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 6, 62)];
    
    NSString *createData = [dict objectForKey:@"createdAt"];
    
    NSString *_createDate = [createData stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    //date
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 6, 8)];
    
    [dateLabel setText:_createDate];
    [dateLabel setTextAlignment:NSTextAlignmentCenter];
    [dateLabel setFont:[UIFont systemFontOfSize:10]];
    [dateLabel setBackgroundColor:DEFAULT_COLOR];
    
    //portrait
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[AccountMessage sharedInstance].image];
    
    [imageView setFrame:CGRectMake(6, 14, 42, 42)];
    
    [leftView addSubview:imageView];
    
    [leftView addSubview:dateLabel];
    
    [leftView setBackgroundColor:[UIColor yellowColor]];
    
    return leftView;
}

@end
