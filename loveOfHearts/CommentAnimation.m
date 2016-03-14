//
//  CommentAnimation.m
//  爱之心
//
//  Created by 于恩聪 on 16/3/14.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "CommentAnimation.h"

@implementation CommentAnimation

+(CABasicAnimation *)animtionToMoveX:(NSNumber *)x andTime:(float)time{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];///.y的话就向下移动。
    animation.toValue = x;
    animation.duration = time;
    animation.removedOnCompletion = NO;
    animation.repeatCount = 1;
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
}

+(CABasicAnimation *)animationTorotation:(float)duration degree:(float)degree toX:(float)x toY:(float)y toZ:(float)z repeatCount:(int)repeatCount{
    
    CATransform3D rotationTransform = CATransform3DMakeRotation(degree, x , y , z);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    animation.toValue = [ NSValue valueWithCATransform3D :rotationTransform];
    
    animation.duration =  duration;
    
    animation.autoreverses = YES ;
    
    animation.cumulative = NO ;
    
    animation.fillMode = kCAFillModeForwards ;
    
    animation.repeatCount = repeatCount;
    
    animation.delegate = self ;
    
    return animation;
    
}

//旋转动画

+ (CABasicAnimation *)animationRotation{
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
    rotationAnimation.duration = 0.2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.repeatCount = 1;
    
    return rotationAnimation;
}


@end
