//
//  MessagesController.h
//  BCApp for HackTheHeights
//
//  Created on 4/21/18.
//  Copyright © 2018 Brandon LaRouche, Estevan Feliz, and Joseph Squillaro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModelData.h"
#import "JSQMessagesAvatarImage.h"
#import <Parse/Parse.h>
#import "ParseLiveQuery-Swift.h"


@import JSQMessagesViewController;
@import Parse;

@class MessagesController;

@protocol JSQMessagesViewControllerDelegate <NSObject>

- (void)didDismissJSQMessagesViewController:(UIViewController *)vc;

@end

@interface MessagesController : JSQMessagesViewController <UIActionSheetDelegate, JSQMessagesComposerTextViewPasteDelegate>

@property (strong, nonatomic) MessageModelData *messageData;

@property (weak, nonatomic) UIViewController *delegateModal;

@property (nonatomic, retain) NSString *objectId;
@property (nonatomic, retain) PFObject *channelObject;

@property (nonatomic, strong) PFLiveQueryClient *liveQueryClient;
@property (nonatomic, strong) PFQuery *msgQuery;
@property (nonatomic, strong) PFLiveQuerySubscription *subscription;


@end

