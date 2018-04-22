//
//  ProfileController.m
//  BCApp for HackTheHeights
//
//  Created on 4/21/18.
//  Copyright © 2018 Brandon LaRouche, Estevan Feliz, and Joseph Squillaro. All rights reserved.
//

#import "OrgProfileController.h"

@interface OrgProfileController () {
    PFObject *organization;
}
@end

@implementation OrgProfileController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    if (_organizationObject != nil)
        organization = _organizationObject;
    else
        organization = [[[PFQuery queryWithClassName:@"Organization"] whereKey:@"objectId" equalTo:_objectId] getFirstObject];
    
    _nameLabel.text = [[NSString alloc] initWithFormat:@"%@", organization[@"name"]];
    
    PFQuery *countMembersInChannel = [PFUser query];
    [countMembersInChannel whereKey:@"channels" containsString:organization[@"channel"]];
    [countMembersInChannel findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
            self->_membersLabel.text = [[NSString alloc] initWithFormat:@"%lu Members", (unsigned long)[objects count]];
        else
            self->_membersLabel.text = @"NA";
    }];
    
    _descriptionLabel.text = [[NSString alloc] initWithFormat:@"%@", organization[@"description"]];
    
    _profileImageView.file = (PFFile *)[organization objectForKey:@"profileImage"];
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

#pragma mark Join Chatroom

-(void)openChatRoom:(PFObject *)channel {
    MessagesController *vc = [MessagesController messagesViewController];
    vc.delegateModal = self;
    vc.channelObject = channel;
    vc.objectId = channel.objectId;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nc animated:YES completion:nil];
}

-(IBAction)joinChatroom:(id)sender {
    PFUser *currentUser = [[PFUser currentUser] fetch];
    
    PFObject *channel = [[[PFQuery queryWithClassName:@"Channel"] whereKey:@"objectId" equalTo:organization[@"channel"]] getFirstObject];
    
    if (channel == nil) // Error loading chatroom
        return;
    
    NSMutableArray *channels = [[NSMutableArray alloc] init];
    [channels addObjectsFromArray:[currentUser objectForKey:@"channels"]];
    if ([channels containsObject:channel[@"name"]])
        [self openChatRoom:channel];
    else {
        // Join channel then open
        [currentUser addObject:organization[@"channel"] forKey:@"channels"];
        
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded)
                [self openChatRoom:channel];
        }];
    }
}

@end
