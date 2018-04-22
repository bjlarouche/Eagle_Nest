//
//  MapController.m
//  BCApp for HackTheHeights
//
//  Created on 4/21/18.
//  Copyright © 2018 Brandon LaRouche, Estevan Feliz, and Joseph Squillaro. All rights reserved.
//

#import "MapController.h"

@interface MapController ()

@end

@implementation MapController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CLLocationDegrees latitude = [@"42.3355" doubleValue];
    CLLocationDegrees longitude = [@"-71.1685" doubleValue];
    
    CLLocationCoordinate2D campus = CLLocationCoordinate2DMake(latitude, longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(campus, 1000, 100);
    [_mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    // set the camera property
    [_mapView.camera setPitch:45.f];
    [_mapView.camera setAltitude:800];
    //[_mapView.camera setHeading:500];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
