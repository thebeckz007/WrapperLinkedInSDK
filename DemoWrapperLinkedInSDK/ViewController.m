//
//  ViewController.m
//  DemoWrapperLinkedInSDK
//
//  Created by david  beckz on 4/12/16.
//  Copyright © 2016 Thebeckz007. All rights reserved.
//

#import "ViewController.h"
#import "LinkedInHeader.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnSignInLinkedIn_Tapped:(id)sender {
    [[LinkedInManager shareInstance] signInLinkedInCompleteBlock:^(LinkedInProfile *profile, LinkedInTokenObject *token, NSError *error) {
        if (error) {
            // failed
            [[[UIAlertView alloc] initWithTitle:@"LinkedIn" message:@"Login failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        } else {
            // success
            NSMutableString *message = [NSMutableString string];
            
            [message appendFormat:@"LinkedIn ID: %@", profile.profileID];
            [message appendFormat:@"\nLinkedIn Name: %@ %@", profile.firstname, profile.lastName];
            [message appendFormat:@"\nLinkedIn Email: %@", profile.email];
            [message appendFormat:@"\nLinkedIn HeadLine: %@", profile.headLine];
            [message appendFormat:@"\nLinkedIn Industry: %@", profile.industry];
            
            [message appendFormat:@"\n\n-----------------------"];
            [message appendFormat:@"\nAccessToken: %@", token.accessToken];
            [message appendFormat:@"\nExpiredDate: %@", token.expiredDate];
            
            [[[UIAlertView alloc] initWithTitle:@"LinkedIn" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
    }];
}

@end
