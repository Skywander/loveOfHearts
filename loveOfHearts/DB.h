//
//  DB.h
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/24.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Networking.h"
#import "AccountMessage.h"

typedef void (^getImage)(UIImage *image);

@interface DB : NSObject

+ (void)getImageWithWatchId:(NSString *)watchId filename:(NSString *)filename block:(getImage)getImage;

@end
