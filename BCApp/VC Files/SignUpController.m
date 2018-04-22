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
    if (textField == _firstnameField) {
        [_lastnameField becomeFirstResponder];
    }
    else if (textField == _lastnameField) {
        [_emailField becomeFirstResponder];
    }
    else if (textField == _emailField) {
        [_usernameField becomeFirstResponder];
    }
    else if (textField == _usernameField) {
        [_passwordField becomeFirstResponder];
    }
    else if (textField == _passwordField) {
        [self signUpPressed:self];
    }
    else
        [textField resignFirstResponder];
    return YES;
}

#pragma mark Parse SignUp

// Sign user up with Parse with given username, password, and email
-(void)processSignUp:(NSString *)username withPassword:(NSString *)password withEmail:(NSString *)email withFirstname:(NSString *)firstname withLastname:(NSString *)lastname {
    // Declare a new PFUser
    PFUser *user = [PFUser user];

    // Populate fields of PFUser
    user.username = username;
    user.password = password;
    user.email = email; // Populating this field will trigger verification email to be sent
    [user setObject:firstname forKey:@"firstname"];
    [user setObject:lastname forKey:@"lastname"];
    
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"PlaceholderProfileImage.jpg"]);
    PFFile *file = [PFFile fileWithData:imageData];
    [user setObject:file forKey:@"profileImage"];
    
    // Register PFUser with Parse in background
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error) {
            // In case everything went fine
            // Segue to VerificationController
            [self performSegueWithIdentifier:@"verify" sender:nil];
        }
        else {
            NSString* errorString = [error userInfo][@"error"];
            [self showAlert:@"Account Setup Failed" message:@"Please try again." actionTitle:@"OKAY"];
        }
    }];
}

// Trigger SignUp sequence
-(IBAction)signUpPressed:(id)sender {
    // Gather the relevant info
    NSString *username = _usernameField.text;
    NSString *password = _passwordField.text;
    NSString *email = _emailField.text;
    NSString *firstname = _firstnameField.text;
    NSString *lastname = _lastnameField.text;
    
    if([email isValidEmail]) {
        NSArray *emailComponents = [email componentsSeparatedByString:@"@"];
        if ([emailComponents[1] isEqualToString:@"bc.edu"]) {
            // Proccess SignUp with valid BC Username
            [self processSignUp:username withPassword:password withEmail:email withFirstname:firstname withLastname:lastname];
            return;
        }
    }
    [self showAlert:@"Invalid Email" message:@"Email must belong to the bc.edu domain." actionTitle:@"OKAY"];
}



@end
