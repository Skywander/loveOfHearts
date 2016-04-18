//
//  AccountMessage.h
//  loveOfHearts
//
//  Created by 于恩聪 on 16/3/15.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountMessage : NSObject

@property (nonatomic,strong)NSString *admin;

@property (nonatomic) NSInteger isAdmin;

@property (nonatomic,strong)NSString *createdAt;
@property (nonatomic,strong)NSString *ispowered;
@property (nonatomic,strong)NSString *relationship;
@property (nonatomic,strong)NSString *relationtype;
@property (nonatomic,strong)NSString *updatedAt;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *wid;

@property (nonatomic,strong)NSString *babyage;
@property (nonatomic,strong)NSString *babybir;
@property (nonatomic,strong)NSString *babyheight;
@property (nonatomic,strong)NSString *babyname;
@property (nonatomic,strong)NSString *babysex;
@property (nonatomic,strong)NSString *babyweight;
@property (nonatomic,strong)NSString *centernumber;
@property (nonatomic,strong)NSString *clock;
@property (nonatomic,strong)NSString *flower;
@property (nonatomic,strong)NSString *head;
@property (nonatomic,strong)NSString *isonline;
@property (nonatomic,strong)NSString *lowbat;
@property (nonatomic,strong)NSString *mode;
@property (nonatomic,strong)NSString *pedo;
@property (nonatomic,strong)NSString *phb;
@property (nonatomic,strong)NSString *phb2;
@property (nonatomic,strong)NSString *power;
@property (nonatomic,strong)NSString *remove;
@property (nonatomic,strong)NSString *silencetime;
@property (nonatomic,strong)NSString *smsonoff;
@property (nonatomic,strong)NSString *sos;
@property (nonatomic,strong)NSString *sossms;
@property (nonatomic,strong)NSString *turn;
@property (nonatomic,strong)NSString *usim;
@property (nonatomic,strong)NSString *whitelist1;
@property (nonatomic,strong)NSString *whitelist2;
@property (nonatomic,strong)NSString *wsim;

@property (nonatomic,strong) UIImage *image;

@property (nonatomic) BOOL showHomeView;

@property (nonatomic,strong) UIImage *homeAnimationImage;

+ (instancetype)sharedInstance;

- (void)setUserInfor:(NSDictionary *)dict;

- (void)setWatchInfor:(NSDictionary *)dict;

- (void)setBabyMessage:(NSDictionary *)_dict;

- (void)initBabyMesssage;

@end
