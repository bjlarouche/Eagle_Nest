//
//  AppDelegate.h
//  BCApp
//
//  Created by Bran Muffin on 4/21/18.
//  Copyright © 2018 Double Trouble Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

