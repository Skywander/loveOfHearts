//
//  HomeViewController+delegate.h
//  loveOfHearts
//
//  Created by 于恩聪 on 16/4/3.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "HomeViewController.h"
#import "ChatViewController.h"
#import "PersonInforViewController.h"

#import "MapProtocol.h"
#import "HomeMenuProtocol.h"
#import "TopviewProltocol.h"

#import "AccountMessage.h"

@interface HomeViewController (delegate)<MapProtocol,HomeMenuProtocol,TopviewProltocol>

- (void)passValue:(NSString *)string;

- (void)passSelectedVaule:(NSInteger)selected;

- (void)presentPersonInfoView;

- (void)showRightView;

@end
