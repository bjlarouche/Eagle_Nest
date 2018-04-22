//
//  OrgProfileController.h
//  BCApp for HackTheHeights
//
//  Created on 4/21/18.
//  Copyright © 2018 Brandon LaRouche, Estevan Feliz, and Joseph Squillaro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessagesController.h"

@import Parse;

@interface OrgProfileController : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *membersLabel;
@property (nonatomic, retain) IBOutlet UITextView *descriptionLabel;
@property (nonatomic, retain) IBOutlet PFImageView *profileImageView;
@property (nonatomic, retain) NSString *objectId;
@property (nonatomic, retain) PFObject *organizationObject;

@end

