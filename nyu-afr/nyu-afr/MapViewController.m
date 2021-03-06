//
//  MapViewController.m
//  nyu-afr
//
//  Created by Chairuni Aulia Nusapati on 4/12/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"
@import GooglePlaces;
@import GoogleMaps;

#define zoomLevel 15.0

@interface MapViewController () <CLLocationManagerDelegate>

@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property GMSMapView *mapView;
@property GMSMarker *marker1;
@property GMSMarker *marker2;
@property GMSMarker *marker3;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GMSCameraPosition *camera = [GMSCameraPosition
     cameraWithLatitude:-33.86
     longitude:151.20
     zoom:zoomLevel];
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.tabBarController.tabBar.frame.size.height) camera:camera];
    self.mapView.myLocationEnabled = YES;
    [self.view addSubview:self.mapView];
    self.mapView.settings.myLocationButton = true;
    self.mapView.myLocationEnabled = true;
    self.mapView.hidden = true;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.distanceFilter = 50;
    [self.locationManager startUpdatingLocation];
    self.locationManager.delegate = self;
    self.marker1 = [[GMSMarker alloc] init];
    self.marker2 = [[GMSMarker alloc] init];
    self.marker3 = [[GMSMarker alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[delegate.userModel.userData objectForKey:@"status"] isEqualToString:@"NO_ACTIVE_QUEST"]) {
        self.mapView.hidden = true;
        if (self.marker1 != nil) {
            self.marker1.map = nil;
        }
        if (self.marker2 != nil) {
            self.marker2.map = nil;
        }
        if (self.marker3 != nil) {
            self.marker3.map = nil;
        }
    } else if ([[delegate.userModel.userData objectForKey:@"status"] isEqualToString:@"QUEST_IN_PROGRESS"]) {
        self.mapView.hidden = false;
        self.marker1.position = CLLocationCoordinate2DMake([[[delegate.userModel.userData objectForKey:@"current_quest"] objectForKey:@"latitude"] doubleValue], [[[delegate.userModel.userData objectForKey:@"current_quest"] objectForKey:@"longitude"] doubleValue]);
        self.marker1.title = @"?";
        self.marker1.snippet = [[delegate.userModel.userData objectForKey:@"current_quest"] objectForKey:@"street_address"];
        self.marker1.map = self.mapView;
        self.marker2.position = CLLocationCoordinate2DMake([[[delegate.userModel.userData objectForKey:@"deception_quest1"] objectForKey:@"latitude"] doubleValue], [[[delegate.userModel.userData objectForKey:@"deception_quest1"] objectForKey:@"longitude"] doubleValue]);
        self.marker2.title = @"?";
        self.marker2.snippet = [[delegate.userModel.userData objectForKey:@"deception_quest1"] objectForKey:@"street_address"];
        self.marker2.map = self.mapView;
        self.marker3.position = CLLocationCoordinate2DMake([[[delegate.userModel.userData objectForKey:@"deception_quest2"] objectForKey:@"latitude"] doubleValue], [[[delegate.userModel.userData objectForKey:@"deception_quest2"] objectForKey:@"longitude"] doubleValue]);
        self.marker3.title = @"?";
        self.marker3.snippet = [[delegate.userModel.userData objectForKey:@"deception_quest2"] objectForKey:@"street_address"];
        self.marker3.map = self.mapView;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.lastObject;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude zoom:zoomLevel];
    
    if ([self.mapView isHidden]) {
        self.mapView.hidden = false;
        self.mapView.camera = camera;
    } else {
        [self.mapView animateToCameraPosition:camera];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusRestricted) {
        
    } else if (status == kCLAuthorizationStatusRestricted) {
        NSLog(@"Location access was restricted.");
    } else if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"User denied access to location.");
        self.mapView.hidden = false;
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"Location status not determined.");
    } else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"Location status is OK.");
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.locationManager stopUpdatingLocation];
    NSLog(@"Error: %@", error);
}

@end
