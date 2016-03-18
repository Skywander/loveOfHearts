//
//  Rail.h
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/18.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rail : NSObject

@property (strong,nonatomic) NSString *alerttype;
@property (strong,nonatomic) NSString *createdAt;
@property (strong,nonatomic) NSString *fencearea;
@property (strong,nonatomic) NSString *fencename;
@property (strong,nonatomic) NSString *fencetype;
@property (strong,nonatomic) NSString *fid;
@property (strong,nonatomic) NSString *flag;
@property (strong,nonatomic) NSString *updatedAt;

- (void)initWithDict:(NSDictionary *)dict;

@end
