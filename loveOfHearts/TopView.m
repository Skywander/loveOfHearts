//
//  TopView.m
//  爱之心
//
//  Created by 于恩聪 on 16/3/9.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "TopView.h"

#define SELF_HEIGHT self.frame.size.height

#define EXPAND_BUTTON_WIDTH 30
@interface TopView()
{
    UILabel *nameLabel;
    UILabel *timeLabel;
    UILabel *addressLabel;
    
    UIView *photoView;
    
    NSTimer *timer;
    }

@end

@implementation TopView
@synthesize expandButton;
- (id)init{
    self = [self init];
    return self;
}

- (id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + 20, frame.size.width, frame.size.height)];
    
    if (self) {
        [self setBackgroundColor:DEFAULT_PINK];
        
        [self initLabel];
        
        [self beginTimer];

    }
    return self;
}

- (void)beginTimer{
    timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];
}

- (void)initLabel{
    nameLabel = [UILabel new];
    timeLabel = [UILabel new];
    addressLabel = [UILabel new];
    
    //时间标签
    
    [timeLabel setFrame:CGRectMake(self.frame.size.height, 0, 200, self.frame.size.height / 2)];
    [timeLabel setText:[self getNowTime]];
    [timeLabel setTextAlignment:NSTextAlignmentLeft];
    [timeLabel setTextColor:[UIColor blackColor]];
    [timeLabel setFont:[UIFont systemFontOfSize:14]];
    [timeLabel setBackgroundColor:[UIColor whiteColor]];
    
    [self addSubview:timeLabel];
    //地址标签
    
    [addressLabel setFrame:CGRectMake(SELF_HEIGHT, SELF_HEIGHT / 2, timeLabel.frame.size.width, SELF_HEIGHT / 2)];
    [addressLabel setBackgroundColor:[UIColor greenColor]];
    [addressLabel setTextAlignment:NSTextAlignmentLeft];
    [addressLabel setTextColor:[UIColor blackColor]];
    [addressLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:addressLabel];
                                      
    
    //photoView
    
    photoView = [UIView new];
    [photoView setBackgroundColor:[UIColor yellowColor]];
    [photoView setFrame:CGRectMake(0, 0, self.frame.size.height, self.frame.size.height)];
    
    [self addSubview:photoView];
    
    //addView
    expandButton = [UIButton new];
    
    [expandButton setBackgroundImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];
    [expandButton setFrame:CGRectMake(SCREEN_WIDTH - self.frame.size.height,(SELF_HEIGHT - EXPAND_BUTTON_WIDTH) / 2,EXPAND_BUTTON_WIDTH, EXPAND_BUTTON_WIDTH)];
    [self addSubview:expandButton];
    
}

- (void)setAddress:(NSString *)address{
    [addressLabel setText:address];
}

- (NSString *)getNowTime{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
   
    return dateString;
}

- (void)updateTimeLabel{
    [timeLabel setText:[self getNowTime]];
    
    NSLog(@"%@",[self getNowTime]);
}






@end
