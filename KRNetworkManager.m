//
//  KRNetworkManager.m
//
//  Created by Kishyr Ramdial on 2012/03/28.
//  Copyright (c) 2012 Kishyr Ramdial. All rights reserved.
//

#import "KRNetworkManager.h"
#import "Reachability.h"

@implementation KRNetworkManager

+ (KRNetworkManager *)sharedManager {
  static dispatch_once_t once;
  static KRNetworkManager *networkManager;
  dispatch_once(&once, ^{
    networkManager = [[KRNetworkManager alloc] init];
  });
  return networkManager;
}

- (id)init {
	self = [super init];
	if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
	}
	return self;
}

- (void)startNetworkMonitor {
	self.hostReach = [Reachability reachabilityForInternetConnection];
	[self.hostReach startNotifier];
	[self updateReachability:self.hostReach];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

#pragma mark - Reachability

- (void)reachabilityChanged:(NSNotification *)note {
  Reachability *curReach = [note object];
  [self updateReachability:curReach];
}

- (void)updateReachability:(Reachability *)curReach {
  NetworkStatus netStatus = [curReach currentReachabilityStatus];
  
  switch (netStatus) {
    case NotReachable: {
      self.connectionAvailable = NO;
      [[NSNotificationCenter defaultCenter] postNotificationName:@"REACH_OFFLINE" object:nil userInfo:nil];
      break;
    }
      
    case ReachableViaWWAN: {
      self.connectionAvailable = YES;      
			NSDictionary *dict = [NSDictionary dictionaryWithObject:@"WWAN" forKey:@"type"];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"REACH_ONLINE" object:nil userInfo:dict];
      break;
    }
			
    case ReachableViaWiFi: {
      self.connectionAvailable = YES;      
			NSDictionary *dict = [NSDictionary dictionaryWithObject:@"WiFi" forKey:@"type"];
      [[NSNotificationCenter defaultCenter] postNotificationName:@"REACH_ONLINE" object:nil userInfo:dict];
      break;
    }
  }
}

- (void)setConnectionAvailable:(BOOL)connectionAvailable {
  _connectionAvailable = connectionAvailable;
  
  if (_connectionAvailable && self.connectionIsOnline) {
    NSLog(@"1 ONLINE");
    self.connectionIsOnline();
  }
  else {
    NSLog(@"1 OFFLINE");
    if (self.connectionIsOffline) {
      self.connectionIsOffline();
    }
  }
}

@end
