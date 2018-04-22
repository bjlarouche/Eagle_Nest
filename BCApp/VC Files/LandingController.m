//
//  LandingController.m
//  BCApp for HackTheHeights
//
//  Created on 4/21/18.
//  Copyright © 2018 Brandon LaRouche, Estevan Feliz, and Joseph Squillaro. All rights reserved.
//

#import "LandingController.h"

@interface LandingController ()

@end

@implementation LandingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Trigger action on swipe left
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp)];
    [swipeUp setDirection: UISwipeGestureRecognizerDirectionUp];
    swipeUp.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:swipeUp];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)swipeUp {
    [self performSegueWithIdentifier:@"authenticate" sender:nil];
}

@end
