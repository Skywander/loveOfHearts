//
//  DB.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/24.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "DB.h"

@implementation DB

+ (void)getImageWithWatchId:(NSString *)watchId filename:(NSString *)filename block:(getImage)getImage{
    //cache
    
    if ([filename isEqualToString:@" "] || filename == NULL || filename == nil || [filename isEqualToString:@""]) {
        
        UIImage *defaultImage = [UIImage imageNamed:@"child_head"];
        
        getImage(defaultImage);
        
        return;
    }
    AccountMessage *_accoutMessage = [AccountMessage sharedInstance];

    if ([_accoutMessage.head isEqualToString:filename] && [_accoutMessage.image isKindOfClass:[UIImage class]]) {
        getImage(_accoutMessage.image);
        
        NSLog(@"image cache");
        
        return;
    }
    //file
    NSFileManager *_fileManager = [NSFileManager defaultManager];
    
    NSString *_path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    
    NSString *imagePath = [_path stringByAppendingPathComponent:filename];
    
    NSLog(@"imagePath : %@",imagePath);
    
    if ([_fileManager fileExistsAtPath:imagePath]) {
        NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
        
        UIImage *image = [UIImage imageWithData:imageData];
        
        if ([_accoutMessage.head isEqualToString:filename]) {
            _accoutMessage.image = image;

        }
        
        getImage(image);
        
        NSLog(@"image file");
        
        return;
    }
    //net
    NSDictionary *paramater = @{
                                    @"wid":watchId,
                                    @"fileName":filename
                                };
    
    [Networking getWatchPortiartWithDict:paramater blockcompletion:^(UIImage *image){
        
        if (image) {
            getImage(image);
            
            NSLog(@"image net");
            
            if ([_accoutMessage.wid isEqualToString:watchId]) {
                _accoutMessage.image = image;
            }
            
            NSData *imageData = UIImagePNGRepresentation(image);
            
            [imageData writeToFile:imagePath atomically:NO];
            
        }
        return ;
        
    }];
    
}

@end
