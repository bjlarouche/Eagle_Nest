//
//  ProfileController.h
//  BCApp for HackTheHeights
//
//  Created on 4/21/18.
//  Copyright © 2018 Brandon LaRouche, Estevan Feliz, and Joseph Squillaro. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Parse;

@interface ProfileController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *fullnameLabel;
@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) IBOutlet PFImageView *profileImageView;
@property (nonatomic, retain) NSString *objectId;
@property (nonatomic, retain) PFObject *userObject;

@end

