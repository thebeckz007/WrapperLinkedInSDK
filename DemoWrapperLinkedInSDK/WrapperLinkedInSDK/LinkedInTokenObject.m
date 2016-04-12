//
//  LinkedInTokenObject.m
//  Anomo
//
//  Created by Duy on 4/11/16.
//  Copyright © 2016 Anomo. All rights reserved.
//

#import "LinkedInTokenObject.h"
#import <linkedin-sdk/LISDKAccessToken.h>

@implementation LinkedInTokenObject

/**
 *  initial instance of LinkedInTokenObject from LISDKAccessToken
 *
 *  @param token LISDKAccessToken
 *
 *  @return instance LinkedInTokenObject
 */
+ (instancetype)linkedInTokenObjectFromLISDKToken:(LISDKAccessToken *)token {
    return [[LinkedInTokenObject alloc] initWithAccesToken:token.accessTokenValue expiredDate:token.expiration serializedToken:[token serializedString]];
}

/**
 *  initial instance of LinkedInTokenObject
 *
 *  @param accessToken access token
 *  @param expDate     expired date of above token
 *  @param serToken    a serialized access token obtained
 *
 *  @return instance of LinkedInTokenObject
 */
- (instancetype)initWithAccesToken:(NSString *)accessToken expiredDate:(NSDate *)expDate serializedToken:(NSString *)serToken {
    self = [super init];
    
    if (self) {
        _accessToken = accessToken;
        _expiredDate = expDate;
        _serializedToken = serToken;
    }
    
    return self;
}

@end
