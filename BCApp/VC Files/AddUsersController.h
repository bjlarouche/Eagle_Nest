//
//  AddUsersController.m
//  BCApp for HackTheHeights
//
//  Created on 4/21/18.
//  Copyright © 2018 Brandon LaRouche, Estevan Feliz, and Joseph Squillaro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AccountCell.h"
#import "LoadCell.h"

@import Parse;

@interface AddUsersController : PFQueryTableViewController <UISearchBarDelegate, UIScrollViewDelegate>

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSMutableArray *checkedUsers;

@end
