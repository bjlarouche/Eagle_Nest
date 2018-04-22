//
//  ParentAddUserController.m
//  BCApp for HackTheHeights
//
//  Created on 4/21/18.
//  Copyright © 2018 Brandon LaRouche, Estevan Feliz, and Joseph Squillaro. All rights reserved.
//

#import "ParentAddUsersController.h"

@interface ParentAddUsersController ()

@end

@implementation ParentAddUsersController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
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
#pragma mark - Actions

-(void)openChatRoom:(PFObject *)channel {
    MessagesController *vc = [MessagesController messagesViewController];
    vc.delegateModal = self;
    vc.channelObject = channel;
    vc.objectId = channel.objectId;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nc animated:YES completion:nil];
}

-(void)createChat:(PFObject *)newChannel {
    NSMutableArray *checkedUsers = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"checkedUsers"] mutableCopy];
    
    if ([checkedUsers count] > 2)
        [newChannel setObject:@"Group Chat" forKey:@"name"];
    else
        [newChannel setObject:@"Private Chat" forKey:@"name"];
    
    [newChannel setObject:@(NO) forKey:@"isOrganization"];
    
    [newChannel saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // Add currentUser to newChannel
            PFUser *currentUser = [[PFUser currentUser] fetch];
            [currentUser addUniqueObject:newChannel.objectId forKey:@"channels"];
            [currentUser saveInBackground];
            
            // Add selected users to newChannel and send them a notification
            for (NSString *objectId in checkedUsers) {
                //Add to target's unread notifications array
                NSDictionary *modifyData = @{
                                             @"objectId": objectId,
                                             @"key": @"channels",
                                             @"value": newChannel.objectId,
                                             };
                [PFCloud callFunctionInBackground:@"addToUserArray" withParameters:modifyData];
                
                NSDictionary *data = @{
                                       @"alert": [[NSString alloc] initWithFormat:@"@%@ has just added you to a new chat!", currentUser[@"username"]],
                                       @"sender": @"New chat",
                                       @"badge": @"increment",
                                       @"sound": @"solemn.mp3",
                                       @"target": objectId,
                                       };
                // Push Notification
                [PFCloud callFunctionInBackground:@"pushToUser" withParameters:data];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"checkedUsers"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self openChatRoom:newChannel];
        }
    }];
}

-(IBAction)donePressed:(id)sender {
    NSMutableArray *checkedUsers = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"checkedUsers"] mutableCopy];
    
    if ([checkedUsers count] <= 0) // No new users to add
        [self.presentingViewController dismissModalViewControllerAnimated:YES];
    else {
        if ((_channelObject == nil) && (_objectId == nil))
            [self createChat:[PFObject objectWithClassName:@"Channel"]];
        else {
            // Channel already exists, add users to it
            if (_channelObject != nil)
                [self createChat:_channelObject];
            else
                [self createChat:[[[PFQuery queryWithClassName:@"Channel"] whereKey:@"objectId" equalTo:_objectId] getFirstObject]];
        }
    }
    
}

@end
