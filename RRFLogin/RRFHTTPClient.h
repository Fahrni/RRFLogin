//
//  RRFHTTPClient.h
//  RRFLogin
//
//  Created by Rob Fahrni on 10/5/14.
//  Copyright (c) 2014 Apple Core Labs. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef void (^RRFSuccessBlock)(id thing);                       // Could be anything, contextual.
typedef void (^RRFEmptySuccessBlock)();                          // Nothing to record
typedef void (^RRFFailureBlock)(NSDictionary* errorDictionary);  // Our failures include extra information stuffed into a dictionary

@interface RRFHTTPClient : NSObject

// Our one and only
+ (instancetype)shared;

// Client side methods
- (BOOL)isLoggedIn;
- (void)logoutUser;
- (void)loginUser:(NSString*)user password:(NSString*)password success:(RRFEmptySuccessBlock)success failure:(RRFFailureBlock)failure;

@end
