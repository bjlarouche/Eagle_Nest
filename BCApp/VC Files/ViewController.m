//
//  ViewController.m
//  BCApp for HackTheHeights
//
//  Created on 4/21/18.
//  Copyright © 2018 Brandon LaRouche, Estevan Feliz, and Joseph Squillaro. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    PFUser *currentUser = [[PFUser currentUser] fetch];
    if (currentUser.sessionToken.length > 0) {
        if([[currentUser objectForKey:@"emailVerified"] boolValue]) {
            // Email has been verified
            //[PFUser logOut];
            [self linkUserToInstallation]; // Link currentUser to Installation
        }
        else {
            // Email has not been verified
            [self performSegueWithIdentifier:@"verify" sender:nil];
        }
    }
    else
        [self performSegueWithIdentifier:@"landing" sender:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
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
        else
            [self performSegueWithIdentifier:@"landing" sender:self];
    }];
}

@end
