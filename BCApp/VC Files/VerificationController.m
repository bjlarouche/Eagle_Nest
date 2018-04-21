//
//  VerificationController.m
//  BCApp for HackTheHeights
//
//  Created on 4/21/18.
//  Copyright © 2018 Brandon LaRouche, Estevan Feliz, and Joseph Squillaro. All rights reserved.
//

#import "VerificationController.h"

@interface VerificationController () {
    NSTimer *verificationTimer;
    UIActivityIndicatorView *activityIndicator;
}
@end

@implementation VerificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Every 2.5 seconds check if user emailValidated is true
    verificationTimer = [NSTimer scheduledTimerWithTimeInterval:2.5
                                     target:self
                                   selector:@selector(verifyEmail)
                                   userInfo:nil
                                    repeats:NO];
    
    [activityIndicator startAnimating]; // Start the activity indicator
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Return value of PFUser emailVerified field
-(BOOL)emailValidatedStatus {
    // Not fetching in background on purpose... Need updated fields
    return [[[[PFUser currentUser] fetchIfNeeded] objectForKey:@"emailVerified"] boolValue];
}

// Check if PFUser emailValidated is true
-(void)verifyEmail {
    BOOL isEmailValidated = [self emailValidatedStatus];

    if (isEmailValidated) {
        // Halt activity related indicators
        [verificationTimer invalidate];
        [activityIndicator stopAnimating];
        
        // Segue or something
    }
    else {
        // Still not verified...
    }
}


@end
