//
//  NewsController.m
//  BCApp for HackTheHeights
//
//  Created on 4/21/18.
//  Copyright © 2018 Brandon LaRouche, Estevan Feliz, and Joseph Squillaro. All rights reserved.
//

#import "NewsController.h"

@interface NewsController ()

@end

@implementation NewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TWTRAPIClient *client = [TWTRAPIClient clientWithCurrentUser];
    self.dataSource = [[TWTRListTimelineDataSource alloc] initWithListSlug:@"BostonCollege" listOwnerScreenName:@"cowbear16" APIClient:client];
    self.showTweetActions = true;
}

@end
