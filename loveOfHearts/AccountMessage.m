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

- (void)setUserInfor:(NSDictionary *)dict{
    self.admin = [dict objectForKey:@"admin"];
    self.createdAt = [dict objectForKey:@"createdAt"];
    self.ispowered = [dict objectForKey:@"ispowerd"];
    self.relationship = [dict objectForKey:@"relationship"];
    self.updatedAt = [dict objectForKey:@"updateAt"];
    self.userId = [dict objectForKey:@"userId"];
    self.wid = [dict objectForKey:@"wid"];
}

- (void)setWatchInfor:(NSDictionary *)dict{
    self.babyage = [dict objectForKey:@"babyage"];
    self.babybir = [dict objectForKey:@"babybir"];
    self.babyheight = [dict objectForKey:@"babyheight"];
    self.babyname = [dict objectForKey:@"babyname"];
    self.babysex = [dict objectForKey:@"babysex"];
    self.babyweight = [dict objectForKey:@"babyweight"];
    self.centernumber = [dict objectForKey:@"centernumber"];
    self.clock = [dict objectForKey:@"clock"];
    self.flower = [dict objectForKey:@"flower"];
    self.head = [dict objectForKey:@"head"];
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
    self.usim = [dict objectForKey:@"usim"];
    self.whitelist1 = [dict objectForKey:@"whitelist1"];
    self.whitelist2 = [dict objectForKey:@"whitelist2"];
    self.wsim = [dict objectForKey:@"wsim"];
}

@end
