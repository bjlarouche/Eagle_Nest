//
//  VerificationController.m
//  BCApp for HackTheHeights
//
//  Created on 4/21/18.
//  Copyright © 2018 Brandon LaRouche, Estevan Feliz, and Joseph Squillaro. All rights reserved.
//

#import "VerificationController.h"

@interface VerificationController ()

@end

@implementation VerificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Every 2.5 seconds check if user emailValidated is true
    NSTimer *verificationTimer = [NSTimer scheduledTimerWithTimeInterval:2.5
                                     target:self
                                                                selector:@selector(verifyEmail:)
                                   userInfo:nil
                                    repeats:YES];
   
    [verificationTimer fire];
    
    [_activityIndicator startAnimating]; // Start the activity indicator
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Validate Email

// Return value of PFUser emailVerified field
-(BOOL)emailValidatedStatus {
    // Not fetching in background on purpose... Need updated fields
    PFUser *currentUser = [[PFUser currentUser] fetch];
    return [[currentUser objectForKey:@"emailVerified"] boolValue];
}

// Check if PFUser emailValidated is true
-(void)verifyEmail:(NSTimer *)timer {
    BOOL isEmailValidated = [self emailValidatedStatus];

    if (isEmailValidated) {
        // Halt activity related indicators
        [timer invalidate];
        [_activityIndicator stopAnimating];
        
        [self linkUserToInstallation]; // Link currentUser to Installation
    }
    else {
        // Still not verified...
    }
}

#pragma mark Installation

// Link PFUser to Installation object for current device
-(void)linkUserToInstallation {
    PFUser *currentUser = [[PFUser currentUser] fetch];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    [currentInstallation setObject:currentUser.objectId forKey:@"userObjectId"];
    
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded)
            [self performSegueWithIdentifier:@"verified" sender:self];
    }];
}


@end
