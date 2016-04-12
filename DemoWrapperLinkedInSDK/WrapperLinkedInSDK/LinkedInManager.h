//
//  LinkedInManager.h
//  Anomo
//
//  Created by Duy on 4/8/16.
//  Copyright © 2016 Anomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString *const ErrorDomainLinkedIn = @"ErrorDomainLinkedIn";

typedef enum : NSUInteger {
    LinkedInSignInFailed = 1,
    LinkedInCancelled,
    LinkedInUnauthicated,
    LinkedInOther,
} LinkedInErrorCode;

@class LinkedInProfile;
@class LinkedInTokenObject;

typedef void (^GetInfoUserLinkedInHandler)(LinkedInProfile *profile, LinkedInTokenObject *token, NSError *error);

@interface LinkedInManager : NSObject

/**
 *  singleton
 *
 *  @return instance of LinkedInManager
 */
+ (id)shareInstance;

/**
 *  Trigger sign in LinkedIn to get basic profile of user
 *
 *  @param completeBlock complete block get basic profile
 */
- (void)signInLinkedInCompleteBlock:(GetInfoUserLinkedInHandler)completeBlock;

@end

@interface LinkedInManager (Handler)

/**
 call this from application:openURL:sourceApplication:annotation: in AppDelegate to check if the callback can be handled by LinkedIn SDK.
 */
+ (BOOL)shouldHandleUrl:(NSURL *)url;

/**
 call this from application:openURL:sourceApplication:annotation: in AppDelegate in order to properly handle the callbacks. This must be called only if shouldHandleUrl: returns YES.
 */
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end