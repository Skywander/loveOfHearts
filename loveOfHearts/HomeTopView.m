//
//  TopView.m
//  爱之心
//
//  Created by 于恩聪 on 16/3/9.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "HomeTopView.h"
#import "DB.h"
#import "AccountMessage.h"
#import "Command.h"
#import <Masonry/Masonry.h>

#define SELF_HEIGHT self.frame.size.height

#define BUTTON_WIDTH 45
@interface HomeTopView()
{
    UILabel *nameLabel;
    UILabel *timeLabel;
    UILabel *addressLabel;
    
    UIImageView *photoView;
    
    UIImageView *powerView;
    
    NSTimer *timer;
}

@end

@implementation HomeTopView
@synthesize expandButton;
- (id)init{
    self = [self init];
    return self;
}

- (id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y + 20, frame.size.width, frame.size.height)];
    
    if (self) {
        [self setBackgroundColor:DEFAULT_PINK];
        
        if ([AccountMessage sharedInstance].wid != NULL) {
            NSDictionary *paramater = @{
                                        @"wid":[AccountMessage sharedInstance].wid
                                        };
            
            [Command commandWithAddress:@"user_getBabyInfo" andParamater:paramater dictBlock:^(NSDictionary *dict) {
                if (dict) {
                    AccountMessage *accountMessage = [AccountMessage sharedInstance];
                    
                    [accountMessage setBabyMessage:dict];
                    
                    [self initLabel];
                    
                    [self beginTimer];
                    
                }else{
                    [self initLabel];
                    
                    [self beginTimer];
                }
            }];
        }else{
            [self initLabel];
            
            [self beginTimer];
        }
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
    
    [timeLabel setFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height / 2)];

    [timeLabel setText:[self getNowTime]];
    [timeLabel setTextAlignment:NSTextAlignmentCenter];
    [timeLabel setTextColor:[UIColor blackColor]];
    [timeLabel setFont:[UIFont systemFontOfSize:14]];
    
    [self addSubview:timeLabel];
    //地址标签
    
    [addressLabel setFrame:CGRectMake(0, SELF_HEIGHT / 2, SCREEN_WIDTH, SELF_HEIGHT / 2)];
    [addressLabel setTextAlignment:NSTextAlignmentCenter];
    [addressLabel setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:addressLabel];
    
    //photoView
    
    photoView = [UIImageView new];
    [photoView setBackgroundColor:[UIColor whiteColor]];
    [photoView setFrame:CGRectMake(4, 4, BUTTON_WIDTH, BUTTON_WIDTH)];
    
    [photoView setClipsToBounds:YES];
    [photoView.layer setBorderWidth:0.3F];
    [photoView.layer setCornerRadius:photoView.frame.size.width / 2];
    
    
    [self addSubview:photoView];
    
    //addView
    expandButton = [UIButton new];

    [expandButton setBackgroundImage:[UIImage imageNamed:@"read_more"] forState:UIControlStateNormal];
    
    [expandButton setBackgroundImage:[UIImage imageNamed:@"read_more_click"] forState:UIControlStateHighlighted];
    
    [expandButton setClipsToBounds:YES];
        
    [expandButton addTarget:self action:@selector(expand) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:expandButton];
    
    [expandButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-10);
        
        make.top.equalTo(self).with.offset(15);
        
        make.bottom.equalTo(self).with.offset(-15);
        
        make.width.equalTo(@(SELF_HEIGHT - 30));
    }];
    
    //powerView
    powerView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4 + BUTTON_WIDTH, BUTTON_WIDTH, self.frame.size.height - 4 - BUTTON_WIDTH)];
    
    [powerView setImage:[UIImage imageNamed:@"power100"]];
    
    [self addSubview:powerView];
    
    [self getImage];
    
}

- (void)setAddress:(NSString *)address{
    [addressLabel setText:address];
}

- (void)setUpdatePower:(NSInteger)paramater{
    NSInteger power = (paramater / 10 + 1) * 10;
    
    if (power == 110) {
        power = 100;
    }
    
    NSLog(@"power %ld",power);
    
    [powerView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"power%ld",power]]];
}

- (void)setImage:(UIImage *)image{
    [photoView setImage:image];
}

- (NSString *)getNowTime{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    if (![[AccountMessage sharedInstance].babyname isEqualToString:@""] && [AccountMessage sharedInstance].babyname != NULL) {
        dateString = [NSString stringWithFormat:@"%@|%@",[AccountMessage sharedInstance].babyname,dateString];
    }
   
    return dateString;
}

- (void)updateTimeLabel{
    [timeLabel setText:[self getNowTime]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    if (CGRectContainsPoint(photoView.frame, point)) {
        [self.topViewDelegat presentPersonInfoView];
    }
    
}

- (void)expand{
    [self.topViewDelegat showRightView];
}

- (void)getImage{
    
    if (![[AccountMessage sharedInstance].wid isKindOfClass:[NSString class]]) {
        [DB getImageWithWatchId:@" " filename:@" " block:^(UIImage *image) {
            [photoView setImage:image];
        }];
        
        return;
    }
    
    NSDictionary *paramater = @{
                                @"wid":[AccountMessage sharedInstance].wid
                                };
    
    [Command commandWithAddress:@"user_getBabyInfo" andParamater:paramater dictBlock:^(NSDictionary *dict) {
        if (![dict isEqual:[NSNull null]] && [dict isKindOfClass:[NSDictionary class]]) {
            
            AccountMessage *accountMessage = [AccountMessage sharedInstance];
            
            [accountMessage setBabyMessage:dict];
            
        }else{
            [[AccountMessage sharedInstance] initBabyMesssage];
        }
        
        [DB getImageWithWatchId:[AccountMessage sharedInstance].wid filename:[AccountMessage sharedInstance].head block:^(UIImage *image) {
            [photoView setImage:image];
        }];
    }];

}


@end
