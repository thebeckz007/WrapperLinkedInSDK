//
//  LinkedInTokenObject.h
//  Anomo
//
//  Created by Duy on 4/11/16.
//  Copyright © 2016 Anomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LISDKAccessToken;

@interface LinkedInTokenObject : NSObject

@property (readonly,nonatomic) NSString *accessToken;
@property (readonly,nonatomic) NSDate   *expiredDate;
@property (readonly,nonatomic) NSString *serializedToken;  // a serialized access token obtained

+ (instancetype)linkedInTokenObjectFromLISDKToken:(LISDKAccessToken *)token;

- (instancetype)initWithAccesToken:(NSString *)accessToken expiredDate:(NSDate *)expDate serializedToken:(NSString *)serToken;

@end
