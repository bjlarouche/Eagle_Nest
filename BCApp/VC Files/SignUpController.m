//
//  AuthController.m
//  BCApp for HackTheHeights
//
//  Created on 4/21/18.
//  Copyright © 2018 Brandon LaRouche, Estevan Feliz, and Joseph Squillaro. All rights reserved.
//

#import "SignUpController.h"

// Implementation of Valid email


@interface SignUpController ()

@end

@implementation SignUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Helper functions
// Should be another class... but meh why be DRY

// Present user with UIAlertView
-(void)showAlert:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle {
    UIAlertController *alert=[ UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alert animated:YES
                     completion:nil];
    UIAlertAction *dismissaction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:dismissaction];
}

#pragma mark Parse SignUp

// Sign user up with Parse with given username, password, and email
-(void)processSignUp:(NSString *)username withPassword:(NSString *)password withEmail:(NSString *)email {
    // Declare a new PFUser
    PFUser *user = [PFUser user];

    // Populate fields of PFUser
    user.username = username;
    user.password = password;
    user.email = email; // Populating this field will trigger verification email to be sent
    
    // Register PFUser with Parse in background
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(!error) {
            // In case everything went fine
            // Segue to VerificationController
        }
        else {
            NSString* errorString = [error userInfo][@"error"];
            // In case something went wrong
        }
    }];
}

// Trigger SignUp sequence
-(IBAction)signUpPressed:(id)sender {
    // Gather the relevant info
    NSString *username = @"USERNAME_HERE";
    NSString *password = @"PASSWORD_HERE";
    NSString *email = @"EMAIL_HERE";
    
    if([email isValidEmail]) {
        NSArray *emailComponents = [email componentsSeparatedByString:@"@"];
        if ([emailComponents[1] isEqualToString:@"bc.edu"]) {
            // Proccess SignUp with valid BC Username
            [self processSignUp:username withPassword:password withEmail:email];
            return;
        }
    }
    [self showAlert:@"Invalid Email" message:@"Email must belong to the bc.edu domain." actionTitle:@"OKAY"];
}



@end
