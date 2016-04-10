//
//  Navigation.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/18.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "Navigation.h"

@implementation Navigation

- (id)init{
    self = [super init];
    
    if(self){
        [self setFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
        
        [self setBackgroundColor:DEFAULT_PINK];
        
        UIButton *returnButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"return"]];
        
        [imageView setFrame:CGRectMake(10, 12,20, 20)];
        
        [imageView setUserInteractionEnabled:YES];
        
        [returnButton addSubview:imageView];
        
        [returnButton addTarget:self action:@selector(returenLastView) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:returnButton];

    }
    return self;
}

- (void)returenLastView{
    UIResponder *responder = [self.superview nextResponder];
    
    UIViewController *viewController = (UIViewController *)responder;
    
    [viewController dismissViewControllerAnimated:YES completion:^{
        ;
    }];
    
}


- (void)addRightViewWithName:(NSString *)name{
    UIButton *expandButton = [UIButton new];
    
    [expandButton setFrame:CGRectMake(SCREEN_WIDTH - NAVIGATION_HEIGHT, 0, NAVIGATION_HEIGHT, NAVIGATION_HEIGHT)];
    
    [expandButton setTitle:name forState:UIControlStateNormal];
    
    [expandButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [expandButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    [expandButton addTarget:self action:@selector(expand)forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:expandButton];
}

- (void)expand{
    [self.delegate clickNavigationRightView];
}


@end
