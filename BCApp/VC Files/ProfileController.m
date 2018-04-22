//
//  ProfileController.m
//  BCApp for HackTheHeights
//
//  Created on 4/21/18.
//  Copyright © 2018 Brandon LaRouche, Estevan Feliz, and Joseph Squillaro. All rights reserved.
//

#import "ProfileController.h"

@interface ProfileController ()

@end

@implementation ProfileController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    PFUser *currentUser = nil;
    if ((_userObject != nil))
        currentUser = [PFQuery getUserObjectWithId:_userObject.objectId];
    else if ([PFQuery getUserObjectWithId:_objectId] != nil)
        currentUser = [PFQuery getUserObjectWithId:_objectId];
    else
        currentUser = [[PFUser currentUser] fetch];
    
    _fullnameLabel.text = [[NSString alloc] initWithFormat:@"%@ %@", currentUser[@"firstname"], currentUser[@"lastname"]];
    _scoreLabel.text = [[NSString alloc] initWithFormat:@"%@ Posts", currentUser[@"score"]];
    _usernameLabel.text = [[NSString alloc] initWithFormat:@"@%@", currentUser[@"username"]];
    _profileImageView.file = (PFFile *)[currentUser objectForKey:@"profileImage"];
    [_profileImageView loadInBackground];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SignOut

// Sign the user out of Parse
-(IBAction)signOutPressed:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError *error) {
        if (!error)
            [self performSegueWithIdentifier:@"signout" sender:nil];
    }];
}

@end
