//
//  AccountMessage.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/15.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "AccountMessage.h"

@implementation AccountMessage

static AccountMessage *accountMessage;

+ (instancetype)sharedInstance{
    if (accountMessage) {
        return accountMessage;
    }else{
        accountMessage = [[AccountMessage alloc] init];
    }
    return accountMessage;
}

- (id)init{
    self = [super init];
    
    return self;
}

- (void)setUserInfor:(NSDictionary *)_dict{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_dict];

    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqual:[NSNull null]]) {
            [dict setValue:@" " forKey:key];
        }
    }];
    
    self.admin = [dict objectForKey:@"admin"];
    self.isAdmin = [self.admin integerValue];
    self.createdAt = [dict objectForKey:@"createdAt"];
    self.ispowered = [dict objectForKey:@"ispowerd"];
    self.relationship = [dict objectForKey:@"relationship"];
    self.updatedAt = [dict objectForKey:@"updateAt"];
    self.userId = [dict objectForKey:@"userId"];
    self.wid = [dict objectForKey:@"wid"];
}

- (void)setWatchInfor:(NSDictionary *)_dict{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_dict];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqual:[NSNull null]]) {
            [dict setValue:@" " forKey:key];
        }
    }];
    self.centernumber = [dict objectForKey:@"centernumber"];
    self.clock = [dict objectForKey:@"clock"];
    self.flower = [dict objectForKey:@"flower"];
    self.isonline = [dict objectForKey:@"isonline"];
    self.lowbat = [dict objectForKey:@"lowbat"];
    self.mode = [dict objectForKey:@"mode"];
    self.pedo = [dict objectForKey:@"pedo"];
    self.phb = [dict objectForKey:@"phb"];
    self.phb2 = [dict objectForKey:@"phb2"];
    self.power = [dict objectForKey:@"power"];
    self.remove = [dict objectForKey:@"remove"];
    self.silencetime = [dict objectForKey:@"silencetime"];
    self.smsonoff = [dict objectForKey:@"smsonoff"];
    self.sos = [dict objectForKey:@"sos"];
    self.sossms = [dict objectForKey:@"sossms"];
    self.turn = [dict objectForKey:@"turn"];
    self.whitelist1 = [dict objectForKey:@"whitelist1"];
    self.whitelist2 = [dict objectForKey:@"whitelist2"];
}

- (void)setBabyMessage:(NSDictionary *)_dict{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:_dict];

    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqual:[NSNull null]]) {
            [dict setValue:@" " forKey:key];
        }
    }];
    
    self.babyage = [dict objectForKey:@"babyage"];
    self.babybir = [dict objectForKey:@"babybir"];
    self.babyheight = [dict objectForKey:@"babyheight"];
    self.babyname = [dict objectForKey:@"babyname"];
    self.babysex = [dict objectForKey:@"babysex"];
    self.babyweight = [dict objectForKey:@"babyweight"];
    self.wsim = [dict objectForKey:@"wsim"];
    self.usim = [dict objectForKey:@"usim"];
    self.head = [dict objectForKey:@"babyhead"];

}

- (void)initBabyMesssage{
    self.babyage = @" ";
    self.babybir = @" ";
    self.babyheight = @" ";
    self.babyname = @" ";
    self.babysex = @" ";
    self.babyweight = @" ";
    self.wsim = @" ";
    self.usim = @" ";
    self.head = @" ";
}


@end
