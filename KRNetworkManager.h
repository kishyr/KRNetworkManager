//
//  KRNetworkManager.h
//
//  Created by Kishyr Ramdial on 2012/03/28.
//  Copyright (c) 2012 Kishyr Ramdial. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Reachability;

@interface KRNetworkManager : NSObject

@property (nonatomic, retain) Reachability *hostReach;
@property (nonatomic) BOOL connectionAvailable;

+ (KRNetworkManager *)sharedKRNetworkManager;
- (void)startNetworkMonitor;
- (void)updateReachability:(Reachability *)curReach;

@end
