//
//  DB.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/24.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "DB.h"

@implementation DB

+ (UIImage *)getImageWithID:(NSString *)imageID{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *imagePath = [NSString stringWithFormat:@"%@%@.png",path,imageID];
    
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    
    UIImage *image = [UIImage imageWithData:imageData];
    
    return image;
}

@end
