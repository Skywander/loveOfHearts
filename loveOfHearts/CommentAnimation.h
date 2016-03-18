//
//  CommentAnimation.h
//  爱之心
//
//  Created by 于恩聪 on 16/3/14.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
/**
 *  简单的动画合集
 */
@interface CommentAnimation : CABasicAnimation

/**
 *  移动动画
 *
 *  @param time
 *  @param x
 *
 *  @return
 */
+(CABasicAnimation *)animtionToMoveX:(NSNumber *)x andTime:(float)time;

/**
 *   旋转动画
 *
 *  @param duration
 *  @param degree
 *  @param x
 *  @param y
 *  @param z
 *  @param repeatCount
 *
 *  @return
 */
+(CABasicAnimation *)animationRotation;
+(CABasicAnimation *)animationTorotation:(float)duration degree:(float)degree toX:(float)x toY:(float)y toZ:(float)z repeatCount:(int)repeatCount;



@end
