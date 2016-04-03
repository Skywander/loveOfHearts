
//
//  AddWatchByInput+delegate.m
//  loveOfHearts
//
//  Created by 于恩聪 on 16/4/3.
//  Copyright © 2016年 于恩聪. All rights reserved.
//

#import "AddWatchByInput+delegate.h"

@implementation AddWatchByInput (delegate)

//tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.relationArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CMainCell = @"CMainCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CMainCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: CMainCell];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    [cell.textLabel setText:[self.relationArray objectAtIndex:[indexPath row]]];
    [cell.textLabel setTextColor:[UIColor grayColor]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *tempStr = [self.relationArray objectAtIndex:[indexPath row]];
    [self.relationButton setTitle:tempStr forState:UIControlStateNormal];
    
    return;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.6;
}

@end
