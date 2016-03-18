//
//  Rail.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/18.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "Rail.h"

@implementation Rail

- (void)initWithDict:(NSDictionary *)dict{
    self.alerttype = [dict objectForKey:@"alerttype"];
    self.createdAt = [dict objectForKey:@"createdAt"];
    self.fencearea = [dict objectForKey:@"fencearea"];
    self.fencename = [dict objectForKey:@"fencename"];
    self.fencetype = [dict objectForKey:@"fencetype"];
    self.fid = [dict objectForKey:@"fid"];
    self.flag = [dict objectForKey:@"flag"];
    self.updatedAt = [dict objectForKey:@"updatedAt"];
}

- (id)init{
    self = [super init];
    
    return self;
}

@end
