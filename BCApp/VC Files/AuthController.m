//
//  AuthController.m
//  BCApp for HackTheHeights
//
//  Created on 4/21/18.
//  Copyright © 2018 Brandon LaRouche, Estevan Feliz, and Joseph Squillaro. All rights reserved.
//

#import "AuthController.h"

@interface AuthController ()

@end

@implementation AuthController

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

#pragma mark Parse Login

-(void)processLogin:(NSString *)username withPassword:(NSString *)password {
    //This gathers the relevant info
    [PFUser logInWithUsernameInBackground:username password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if(user) {
                                            // Checking out if the email has been verified
                                            if([[user objectForKey:@"emailVerified"] boolValue]) {
                                                // Email has been verified
                                                // Segue to main part of app
                                            }
                                            else {
                                                // Email has not been verified, logout the user
                                                // [PFUser logOut];
                                                // Segue to VerificationController
                                                
                                            }
                                        } else {
                                            NSString* errorString = [error userInfo][@"error"];
                                            // An error occurred
                                        }
                                    }];
}

// Trigger Login Sequence
-(IBAction)loginPressed:(id)sender {
    NSString* username = @"USERNAMEHERE";
    NSString* password = @"PASSWORDHERE";
    
    [self processLogin:username withPassword:password];
}

#pragma mark Parse SignUp

// Push to SignUpController
-(IBAction)signUpPressed:(id)sender {
   // Segue navigation to SignUpController
}

@end
