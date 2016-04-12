//
//  LinkedIn_m
//  Anomo
//
//  Created by Duy on 4/11/16.
//  Copyright © 2016 Anomo. All rights reserved.
//

#import "LinkedInProfile.h"

// define all keys for profile linkedIn, it's referrance https://developer.linkedin.com/docs/fields/basic-profile
#define kLinkedInId             @"id"
#define kLinkedInEmail          @"emailAddress"

#define kLinkedInFirstName      @"firstName"
#define kLinkedInLastName       @"lastName"
#define kLinkedInmaidenName     @"maidenName"

#define kLinkedInProfilePicture @"pictureUrl"
#define kLinkedInHeadLine       @"headline"
#define kLinkedInIndustry       @"industry"
#define kLinkedInLocation       @"location"
#define kLinkedInSummary        @"summary"
#define kLinkedInSpecialties    @"specialties"

@implementation LinkedInProfile

/**
 *  initial instance of LinkedInProfile from dictionary
 *
 *  @param dict dictionary of profile linkedIn
 *
 *  @return instance LinkedInProfile
 */
+ (instancetype)linkedInProfileFromDictionary:(NSDictionary *)dict {
    return [[LinkedInProfile alloc] initFromDictionary:dict];
}

/**
 *  initial instance of LinkedInProfile from dictionary
 *
 *  @param dict dictionary of profile linkedIn
 *
 *  @return instance LinkedInProfile
 */
- (instancetype)initFromDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        // id linkedIn
        _profileID = [dict objectForKey:kLinkedInId];
        _email = [dict objectForKey:kLinkedInEmail];
        _firstname = [dict objectForKey:kLinkedInFirstName];
        _lastName = [dict objectForKey:kLinkedInLastName];
        _maidenname = [dict objectForKey:kLinkedInmaidenName];
        _urlProfilePicture = [dict objectForKey:kLinkedInProfilePicture];
        _headLine = [dict objectForKey:kLinkedInHeadLine];
        _industry = [dict objectForKey:kLinkedInIndustry];
        _sumary = [dict objectForKey:kLinkedInSummary];
        _specialties = [dict objectForKey:kLinkedInSpecialties];
    }
    return self;
}

@end