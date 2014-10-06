//
//  RRFHTTPClient.m
//  RRFLogin
//
//  Created by Rob Fahrni on 10/5/14.
//  Copyright (c) 2014 Apple Core Labs. All rights reserved.
//
#import "RRFHTTPClient.h"
#import <AFNetworking/AFNetworking.h>
#import <SFHFKeychainUtils/SFHFKeychainUtils.h>

@interface RRFHTTPClient ()
@property (strong, nonatomic) AFHTTPRequestOperationManager* rrf_requestOperation;
@property (strong, nonatomic) NSString* rrf_authToken;
@end

@implementation RRFHTTPClient

// Our one and only
+ (instancetype)shared
{
    static dispatch_once_t pred;
    static RRFHTTPClient* instance = nil;
    dispatch_once(&pred, ^{
        instance = [[RRFHTTPClient alloc] init];
    });
    return instance;
}

- (id)init
{
    if ((self = [super init])) {
        self.rrf_requestOperation = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kRRFServiceBaseUrl]];
        [self rrf_loadCredentials];
    }
    return self;
}

- (BOOL)isLoggedIn
{
    return (!IsEmpty(self.rrf_authToken));
}

- (void)logoutUser
{
    [self rrf_wackCredentials];
}

- (void)loginUser:(NSString*)user
         password:(NSString*)password
          success:(RRFEmptySuccessBlock)success
          failure:(RRFFailureBlock)failure
{
    NSDictionary* parameters = @{kRRFUserName: user,
                                 kRRFPassword: password};
    [self.rrf_requestOperation POST:kRRFLogin parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary* responseDictionary = (NSDictionary*)responseObject;
            NSString* token = [responseDictionary objectForKey:kRRFMagicToken];
            if (NO == IsEmpty(token)) {
                
                // Valid token, save it off.
                self.rrf_authToken = (NSString*)token;
                [self rrf_saveCredentials];
                
                // If the caller supplied a block, call it.
                if (success) success();
            } else {
                // If for some weird reason we didn't get back what we wanted, report a "soft" error
                NSDictionary* errorDictionary = @{kRRFSoftErrorField: kRRFSoftErrorText};
                if (failure) failure(errorDictionary);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Most likely an HTTP error, E.G. 401 - Unauthorized
        NSDictionary* errorDictionary = @{kRRFRequestOperation: operation,
                                          kRRFNSError: error};
        if (failure) failure(errorDictionary);
    }];

}

#pragma mark Private Methods

NSString* const kRRFAppBaseUrl      = @"com.applecorelabs.RRFLogin";
NSString* const kRRFAuthTokenKey    = @"RRFAuthTokenKey";

- (void)rrf_saveCredentials
{
    NSError* error = nil;
    [SFHFKeychainUtils storeUsername:kRRFAuthTokenKey andPassword:self.rrf_authToken forServiceName:kRRFAppBaseUrl updateExisting:YES error:&error];
}

- (void)rrf_loadCredentials
{
    NSError* error = nil;
    self.rrf_authToken = [SFHFKeychainUtils getPasswordForUsername:kRRFAuthTokenKey andServiceName:kRRFAppBaseUrl error:&error];
}

- (void)rrf_wackCredentials
{
    NSError* error = nil;
    [SFHFKeychainUtils deleteItemForUsername:kRRFAuthTokenKey andServiceName:kRRFAppBaseUrl error:&error];
    self.rrf_authToken = nil;
}
@end
