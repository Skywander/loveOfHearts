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


//缓存
@property (nonatomic,strong)NSString *tempbabyage;
@property (nonatomic,strong)NSString *tempbabybir;
@property (nonatomic,strong)NSString *tempbabyheight;
@property (nonatomic,strong)NSString *tempbabyname;
@property (nonatomic,strong)NSString *tempbabysex;
@property (nonatomic,strong)NSString *tempbabyweight;
@property (nonatomic,strong)NSString *tempcenternumber;
@property (nonatomic,strong)NSString *tempclock;
@property (nonatomic,strong)NSString *tempflower;
@property (nonatomic,strong)NSString *temphead;
@property (nonatomic,strong)NSString *tempisonline;
@property (nonatomic,strong)NSString *templowbat;
@property (nonatomic,strong)NSString *tempmode;
@property (nonatomic,strong)NSString *temppedo;
@property (nonatomic,strong)NSString *tempphb;
@property (nonatomic,strong)NSString *tempphb2;
@property (nonatomic,strong)NSString *temppower;
@property (nonatomic,strong)NSString *tempremove;
@property (nonatomic,strong)NSString *tempsilencetime;
@property (nonatomic,strong)NSString *tempsmsonoff;
@property (nonatomic,strong)NSString *tempsos;
@property (nonatomic,strong)NSString *tempsossms;
@property (nonatomic,strong)NSString *tempturn;
@property (nonatomic,strong)NSString *tempusim;
@property (nonatomic,strong)NSString *tempwhitelist1;
@property (nonatomic,strong)NSString *tempwhitelist2;
@property (nonatomic,strong)NSString *tempwsim;

+ (instancetype)sharedInstance;

- (void)setUserInfor:(NSDictionary *)dict;

- (void)setWatchInfor:(NSDictionary *)dict;

- (void)updateDataWithNumber:(NSInteger)number;

@end
