//
//  ParentAddUsersController.h
//  BCApp for HackTheHeights
//
//  Created on 4/21/18.
//  Copyright © 2018 Brandon LaRouche, Estevan Feliz, and Joseph Squillaro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessagesController.h"

@import Parse;

@interface ParentAddUsersController : UIViewController

@property (nonatomic, retain) NSString *objectId;
@property (nonatomic, retain) PFObject *channelObject;

@end

