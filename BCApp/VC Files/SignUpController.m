//
//  AuthController.m
//  BCApp for HackTheHeights
//
//  Created on 4/21/18.
//  Copyright © 2018 Brandon LaRouche, Estevan Feliz, and Joseph Squillaro. All rights reserved.
//

#import "SignUpController.h"

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

#pragma mark Parse SignUp

-(IBAction)processSignUp:(id)sender {
    //Gather the relevant info
    NSString *username = @"USERNAMEHERE";
    NSString *email = @"USERNAMEHERE";
    NSString *password = @"!PLACEHOLDER_PASSWORD_PLEASE_DO_NOT_HACK!";
    
    //We are not checking the email here; just for simplicity sake
    PFUser* user = [PFUser user];
    //This is the key change; username being equal to the email
    user.username = username;
    user.password = password;
    //This is an additional and necessary info
    user.email = email;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(!error) {
            // In case everything went fine
        }
        else {
            NSString* errorString = [error userInfo][@"error"];
            // In case something went wrong
        }
    }];
}



@end
