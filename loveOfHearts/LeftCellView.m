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
        
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(6, 0, SCREEN_WIDTH - 12, 62)];
    
    [leftView setBackgroundColor:DEFAULT_COLOR];
    
    [leftView.layer setCornerRadius:6.f];
    
    [leftView setClipsToBounds:YES];
    //date
    NSString *createData = [dict objectForKey:@"createdAt"];
    
    NSString *_createDate = [createData stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 6, 8)];
    
    [dateLabel setText:_createDate];
    [dateLabel setTextAlignment:NSTextAlignmentCenter];
    [dateLabel setFont:[UIFont systemFontOfSize:10]];
    [dateLabel setBackgroundColor:DEFAULT_COLOR];
        
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[AccountMessage sharedInstance].image];
    
    [imageView setFrame:CGRectMake(6, 14, 42, 42)];
    
    [imageView.layer setCornerRadius:21];
    
    [imageView setClipsToBounds:YES];
    
    [leftView addSubview:imageView];
    
    [leftView addSubview:dateLabel];
    
    //play
    
    UIImageView *playView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice_right0"]];
    
    [playView setFrame:CGRectMake(54, 16, 30, 30)];
    
    [playView setClipsToBounds:YES];
    
    [leftView addSubview:playView];
    
    return leftView;
}

@end
