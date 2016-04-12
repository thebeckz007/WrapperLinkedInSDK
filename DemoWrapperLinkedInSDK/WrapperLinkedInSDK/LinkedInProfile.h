//
//  LinkedInProfile.h
//  Anomo
//
//  Created by Duy on 4/11/16.
//  Copyright © 2016 Anomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinkedInProfile : NSObject

@property (nonatomic, readonly) NSString *profileID;
@property (nonatomic, readonly) NSString *email;

@property (nonatomic, readonly) NSString *firstname;
@property (nonatomic, readonly) NSString *lastName;
@property (nonatomic, readonly) NSString *maidenname;  // like alias

@property (nonatomic, readonly) NSString *urlProfilePicture;
@property (nonatomic, readonly) NSString *headLine;
@property (nonatomic, readonly) NSString *industry;
@property (nonatomic, readonly) NSString *sumary;
@property (nonatomic, readonly) NSString *specialties;

/**
 *  initial instance of LinkedInProfile from dictionary
 *
 *  @param dict dictionary of profile linkedIn
 *
 *  @return instance LinkedInProfile
 */
+ (instancetype)linkedInProfileFromDictionary:(NSDictionary *)dict;


/**
 *  initial instance of LinkedInProfile from dictionary
 *
 *  @param dict dictionary of profile linkedIn
 *
 *  @return instance LinkedInProfile
 */
- (instancetype)initFromDictionary:(NSDictionary *)dict;

@end
