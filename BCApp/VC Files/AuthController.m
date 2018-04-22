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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [swipeDown setDirection: UISwipeGestureRecognizerDirectionDown];
    swipeDown.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:swipeDown];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -keyboardSize.height + 64;
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 64.0f;
        self.view.frame = f;
    }];
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

#pragma mark Keyboard

// Dismiss the keyboard
-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _usernameField) {
        [_passwordField becomeFirstResponder];
    }
    else if (textField == _passwordField) {
        [self loginPressed:self];
    }
    else
        [textField resignFirstResponder];
    return YES;
}

#pragma mark Installation

// Link PFUser to Installation object for current device
-(void)linkUserToInstallation {
    PFUser *currentUser = [[PFUser currentUser] fetch];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    [currentInstallation setObject:currentUser.objectId forKey:@"userObjectId"];
    
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded)
            [self performSegueWithIdentifier:@"authenticated" sender:self];
    }];
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
                                                [self linkUserToInstallation]; // Link currentUser to Installation
                                            }
                                            else {
                                                // Email has not been verified, logout the user
                                                // Segue to VerificationController
                                                [self performSegueWithIdentifier:@"verify" sender:nil];
                                            }
                                        } else {
                                            NSString* errorString = [error userInfo][@"error"];
                                            // An error occurred
                                            
                                            [self showAlert:@"Unable to Login" message:@"Please try again." actionTitle:@"OKAY"];
                                        }
                                    }];
}

// Trigger Login Sequence
-(IBAction)loginPressed:(id)sender {
    [self processLogin:_usernameField.text withPassword:_passwordField.text];
}

#pragma mark Parse SignUp

// Push to SignUpController
-(IBAction)signUpPressed:(id)sender {
    // Segue navigation to SignUpController
    [self performSegueWithIdentifier:@"signup" sender:nil];
}

@end
