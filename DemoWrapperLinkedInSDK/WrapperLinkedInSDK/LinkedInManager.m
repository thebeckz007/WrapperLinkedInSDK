//
//  LinkedInManager.m
//  Anomo
//
//  Created by Duy on 4/8/16.
//  Copyright © 2016 Anomo. All rights reserved.
//

#import "LinkedInManager.h"
#import <linkedin-sdk/LISDK.h>
#import "LinkedInProfile.h"
#import "LinkedInTokenObject.h"

//
typedef void (^CreateSessionLinkedInHandler)(NSString *returnState, NSError *error);

// format data out put
NSString *const dataFormatJson = @"?format=json";
NSString *const dataFormatXML = @"?format=xml";

NSString *const api_Get_Full_Profile = @"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,headline,industry,email-address,picture-url)";
NSString *const api_Get_Basic_Profile = @"https://api.linkedin.com/v1/people/~";

@interface LinkedInManager ()

@property (nonatomic, strong) LISDKSession *linkedSession;

@end

@implementation LinkedInManager

/**
 *  singleton
 *
 *  @return instance of LinkedInManager
 */
+ (id)shareInstance {
    static LinkedInManager *shareInstance = nil;
    static dispatch_once_t oneToken = 0;
    dispatch_once(&oneToken, ^{
        shareInstance = [[LinkedInManager alloc] init];
        shareInstance.linkedSession = [[LISDKSession alloc] init];
    });
    
    return shareInstance;
}

/**
 *  Trigger sign in LinkedIn to get basic profile of user
 *
 *  @param completeBlock complete block get basic profile
 */
- (void)signInLinkedInCompleteBlock:(GetInfoUserLinkedInHandler)completeBlock {
    // we should to clear session if need before trigger any apis.
    [self clearSession];
    
    // trigger sign in with linkedin
    [self signInLinkedInCompleteBlockWithoutClearSession:completeBlock];
}

/**
 *  Trigger sign in LinkedIn to get full profile of user
 *
 *  @param completeBlock complete block get basic profile
 */
- (void)signInLinkedInCompleteBlockWithoutClearSession:(GetInfoUserLinkedInHandler)completeBlock {
    // to get response in json, we attend dataFormatJson
    // other else, response in xml, we attend dataFormatXML
    NSString *formatData = dataFormatJson;
    NSString *url = [NSString stringWithFormat:@"%@%@", api_Get_Full_Profile, formatData];
    
    __weak typeof(self) weakSelf = self;
    if ([LISDKSessionManager hasValidSession]) {
        [[LISDKAPIHelper sharedInstance] getRequest:url
                                            success:^(LISDKAPIResponse *response) {
                                                // do something with response
                                                if (completeBlock) {
                                                    NSData* data = [response.data dataUsingEncoding:NSUTF8StringEncoding];
                                                    if (data) {
                                                        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                        LinkedInProfile *profile = [LinkedInProfile linkedInProfileFromDictionary:dictResponse];
                                                        completeBlock(profile, [LinkedInTokenObject linkedInTokenObjectFromLISDKToken:_linkedSession.accessToken], nil);
                                                    } else {
                                                        // data is null, so it's failed
                                                        completeBlock(nil, nil, [weakSelf genarateErrorWithCode:LinkedInSignInFailed]);
                                                    }
                                                }
                                            }
                                              error:^(LISDKAPIError *apiError) {
                                                  // do something with error
                                                  if (apiError && completeBlock && weakSelf) {
                                                      completeBlock(nil, nil, [weakSelf generateErrorFromLISDKAPIError:apiError]);
                                                  }
                                              }];
    } else if (weakSelf) {
        // create session
        NSArray *permissions = @[LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION];
        [weakSelf createSessionWithAuth:permissions state:nil showGoToAppStoreDialog:YES completeBlock:^(NSString *returnState, NSError *error) {
            if (error) {
                // it's failed
                if (completeBlock) {
                    completeBlock(nil, nil, [weakSelf genarateErrorWithCode:LinkedInSignInFailed]);
                }
            } else {
                // created session successfully
                // so, we will call back api sign in with linkedin
                [weakSelf signInLinkedInCompleteBlockWithoutClearSession:completeBlock];
            }
        }];
    } else {
        // it's failed
        if (completeBlock) {
            completeBlock(nil, nil, [weakSelf genarateErrorWithCode:LinkedInSignInFailed]);
        }
    }
}


#pragma mark -
#pragma mark - session LinkedIn
- (void)createSessionWithAccessToken:(NSString *)token {
    // TODO: init access token LinkedIn
    LISDKAccessToken *accessToken = [LISDKAccessToken LISDKAccessTokenWithSerializedString:token];
    [LISDKSessionManager createSessionWithAccessToken:accessToken];
}

- (void)createSessionWithAuth:(NSArray *)permissions state:(NSString *)state showGoToAppStoreDialog:(BOOL)showDialog completeBlock:(CreateSessionLinkedInHandler)completeBlock {
    __weak typeof(self) weakSelf = self;
    [LISDKSessionManager createSessionWithAuth:permissions state:state showGoToAppStoreDialog:showDialog successBlock:^(NSString *returnState) {
        if (weakSelf) {
            // update session
            weakSelf.linkedSession = [[LISDKSessionManager sharedInstance] session];
        }
        
        if (completeBlock) {
            completeBlock(returnState, nil);
        }
    } errorBlock:^(NSError *error) {
        if (completeBlock) {
            completeBlock(nil, error);
        }
        
        if (weakSelf) {
            // clear session
            [weakSelf clearSession];
        }
    }];
}

- (void)clearSession {
    _linkedSession = nil;
    [LISDKSessionManager clearSession];
}


#pragma mark -
#pragma mark - Generate Error

- (NSError *)generateErrorFromLISDKAPIError:(LISDKAPIError *)error {
    LinkedInErrorCode errCode = LinkedInOther;
    
    switch (error.code) {
        case USER_CANCELLED:
            errCode = LinkedInCancelled;
            break;
            
        case INVALID_REQUEST:
            errCode = LinkedInSignInFailed;
            break;
        
        case NOT_AUTHENTICATED:
            errCode = LinkedInUnauthicated;
            break;
            
        default:
            errCode = LinkedInOther;
            break;
    }
    
    return [self genarateErrorWithCode:errCode];
}

- (NSError *)genarateErrorWithCode:(LinkedInErrorCode)code {
    NSString *description;
    switch (code) {
        case LinkedInCancelled:
            description = @"User has cancelled";
            break;
            
        case LinkedInSignInFailed:
            description = @"Sign in failed";
            break;
            
        case LinkedInUnauthicated:
            description = @"App is was not unauthicated";
            break;
            
        default:
            description = @"Unknown error";
            break;
    }
    
    return [self generateErrorWithCode:code description:description];
}

- (NSError *)generateErrorWithCode:(LinkedInErrorCode)code description:(NSString *)description {
    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
    // include description
    if (description) {
        [errorDetail setValue:description forKey:NSLocalizedDescriptionKey];
    }
    
    return [NSError errorWithDomain:ErrorDomainLinkedIn code:code userInfo:errorDetail];
}

@end

@implementation LinkedInManager (Handler)

/**
 call this from application:openURL:sourceApplication:annotation: in AppDelegate to check if the callback can be handled by LinkedIn SDK.
 */
+ (BOOL)shouldHandleUrl:(NSURL *)url {
    return [LISDKCallbackHandler shouldHandleUrl:url];
}

/**
 call this from application:openURL:sourceApplication:annotation: in AppDelegate in order to properly handle the callbacks. This must be called only if shouldHandleUrl: returns YES.
 */
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [LISDKCallbackHandler application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
