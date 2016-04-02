//
//  HomeMenuView.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/11.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "HomeMenuView.h"
#import "CommentAnimation.h"
#import <Masonry/Masonry.h>


#define BUTTON_BACKCOLOR [UIColor clearColor]

#define kDegreesToRadian(x) (M_PI * (x) / 180.0 )

#define kRadianToDegrees(radian) (radian* 180.0 )/(M_PI)

@interface HomeMenuView ()
{
    UIButton *menuButton;
    UIButton *signalButton;
    UIButton *locationButton;
    UIButton *chatButton;
    UIButton *phoneButton;
    UIButton *selfButton;
    UIButton *deviceButton;
    
    float CELL_WIDTH;
    BOOL ISEXPAND;
    
    NSInteger buttonTag;
}

@end

@implementation HomeMenuView
- (instancetype)init{
    self = [super init];
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self initButton];
        
        [self initConstraint];
                 
    }
    return self;
}

- (void)initButton{
    buttonTag = 0;
    
    menuButton = [UIButton new];
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuButton setBackgroundColor:BUTTON_BACKCOLOR];
    
    signalButton = [self buttonWithImageName:@"signal100"];
    
    locationButton = [self buttonWithImageName:@"location"];
    
    chatButton = [self buttonWithImageName:@"chat"];
    
    phoneButton = [self buttonWithImageName:@"phone"];
    
    selfButton = [self buttonWithImageName:@"self"];
    
    deviceButton = [self buttonWithImageName:@"device"];
    
    [self addSubview:menuButton];
        
    [menuButton addTarget:self action:@selector(beginAnimation) forControlEvents:UIControlEventTouchUpInside];
}

- (UIButton *)buttonWithImageName:(NSString *)imageName{
    UIButton *button = [UIButton new];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
    [button setBackgroundColor:BUTTON_BACKCOLOR];
    
    [button setTag:buttonTag];
    
    buttonTag ++ ;
    
    [self addSubview:button];
    
    return button;
}

- (void)initConstraint{
    [menuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.width.equalTo(self.mas_width);
        make.left.equalTo(self.mas_left);
        make.height.equalTo(self.mas_width);
    }];
    
    [signalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.width.equalTo(self.mas_width);
        make.left.equalTo(self.mas_left);
        make.height.equalTo(self.mas_width);
    }];
    [locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.width.equalTo(self.mas_width);
        make.left.equalTo(self.mas_left);
        make.height.equalTo(self.mas_width);
    }];
    [chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.width.equalTo(self.mas_width);
        make.left.equalTo(self.mas_left);
        make.height.equalTo(self.mas_width);
    }];
    [phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.width.equalTo(self.mas_width);
        make.left.equalTo(self.mas_left);
        make.height.equalTo(self.mas_width);
    }];
    [selfButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.width.equalTo(self.mas_width);
        make.left.equalTo(self.mas_left);
        make.height.equalTo(self.mas_width);
    }];
    [deviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.width.equalTo(self.mas_width);
        make.left.equalTo(self.mas_left);
        make.height.equalTo(self.mas_width);
    }];
}

- (void)beginAnimation{
    if (ISEXPAND) {
        CELL_WIDTH = 0;
        
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        menuButton.transform = CGAffineTransformIdentity;
        [UIView commitAnimations];
        
        ISEXPAND = false;
        
    } else{
        CELL_WIDTH = self.frame.size.width;
        
        [UIView beginAnimations:@"counterclockwiseAnimation"context:NULL];

        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        menuButton.transform = CGAffineTransformMakeRotation(M_PI);
        [UIView commitAnimations];
        
        ISEXPAND = true;
    }

    [deviceButton.layer addAnimation:[CommentAnimation animtionToMoveX:[NSNumber numberWithFloat:CELL_WIDTH*6] andTime:0.2] forKey:nil];
    
    [selfButton.layer addAnimation:[CommentAnimation animtionToMoveX:[NSNumber numberWithFloat:CELL_WIDTH*5] andTime:0.2] forKey:nil];

    [phoneButton.layer addAnimation:[CommentAnimation animtionToMoveX:[NSNumber numberWithFloat:CELL_WIDTH*4] andTime:0.2] forKey:nil];

    [chatButton.layer addAnimation:[CommentAnimation animtionToMoveX:[NSNumber numberWithFloat:CELL_WIDTH*3] andTime:0.2] forKey:nil];

    [locationButton.layer addAnimation:[CommentAnimation animtionToMoveX:[NSNumber numberWithFloat:CELL_WIDTH*2] andTime:0.2] forKey:nil];

    [signalButton.layer addAnimation:[CommentAnimation animtionToMoveX:[NSNumber numberWithFloat:CELL_WIDTH*1] andTime:0.2] forKey:nil];
    
}


- (void)handleButtonSelected:(UIButton *)button{
    NSLog(@"button tag : %ld",button.tag);
    
    [self.homeDelegat passSelectedVaule:button.tag];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    if (point.y > self.frame.size.width * 3 && point.y < self.frame.size.width * 4) {
        [self.homeDelegat passSelectedVaule:2];
        
        NSLog(@"chat button selected");
    }
}

@end
