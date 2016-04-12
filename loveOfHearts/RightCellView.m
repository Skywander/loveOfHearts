//
//  RightCellView.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/4/1.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "RightCellView.h"
#import "AccountMessage.h"

@implementation RightCellView

+ (UIView *)initWithDict:(NSDictionary *)dict{
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(3, 0, SCREEN_WIDTH - 6, 62)];
    
    [rightView.layer setCornerRadius:6.f];
    
    [rightView setClipsToBounds:YES];
    
    NSString *createData = [dict objectForKey:@"createdAt"];
    
    NSString *_createDate = [createData stringByReplacingOccurrencesOfString:@"T" withString:@" "];

    
  //  NSString *isheard = [dict objectForKey:@"isheard"];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 6, 8)];
    //date
    [dateLabel setText:_createDate];
    [dateLabel setTextAlignment:NSTextAlignmentCenter];
    [dateLabel setFont:[UIFont systemFontOfSize:10]];
    [dateLabel setBackgroundColor:DEFAULT_COLOR];
    
    [rightView addSubview:dateLabel];
    
    [rightView setBackgroundColor:DEFAULT_COLOR];
    
    //头像
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[AccountMessage sharedInstance].image];
    
    [imageView setFrame:CGRectMake(SCREEN_WIDTH - 48, 0, 42, 42)];
    
    [imageView.layer setCornerRadius:21];
    
    [imageView setClipsToBounds:YES];
    
    [rightView addSubview:imageView];
    
    //play
    UIImageView *playView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice_left0"]];
    
    [playView setFrame:CGRectMake(42 * 300 / 90.0 - 34 - 30 , 6, 30, 30)];
    
    [playView setClipsToBounds:YES];
    
    [rightView addSubview:playView];
    

    UIImageView *backView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Right_cellBack"]];
    [backView setFrame:CGRectMake(SCREEN_WIDTH - 50 - 42 * 300 / 90.0, 12, 42 * 300 / 90.0, 42)];
    
    [backView addSubview:playView];
    
    [rightView addSubview:backView];

    return rightView;
}

@end
