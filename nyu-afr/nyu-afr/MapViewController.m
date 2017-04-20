//
//  MapViewController.m
//  nyu-afr
//
//  Created by Chairuni Aulia Nusapati on 4/12/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import "MapViewController.h"
@import GooglePlaces;
@import GoogleMaps;

#define zoomLevel 15.0

@interface MapViewController () <CLLocationManagerDelegate>

@property CLLocationManager *locationManager;
@property CLLocation *currentLocation;
@property GMSMapView *mapView;

@end

@implementation MapViewController

// You don't need to modify the default initWithNibName:bundle: method.

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    //[self.view addSubview:self.mapView];
    self.view = self.mapView;
    
    self.mapView.settings.myLocationButton = true;
    self.mapView.myLocationEnabled = true;
    self.mapView.hidden = true;
    
    // Creates markers in the "possible places"
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(40.735863, -73.991084);
    marker.title = @"Union Square";
    marker.snippet = @"Australia";
    marker.map = self.mapView;
    
    GMSMarker *marker2 = [[GMSMarker alloc] init];
    marker2.position = CLLocationCoordinate2DMake(40.728903, -73.992644);
    marker2.title = @"SHC";
    marker2.snippet = @"Australia";
    marker2.map = self.mapView;
    
    GMSMarker *marker3 = [[GMSMarker alloc] init];
    marker3.position = CLLocationCoordinate2DMake(40.7299, -73.9978);
    marker3.title = @"Kimmel";
    marker3.snippet = @"Australia";
    marker3.map = self.mapView;

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.distanceFilter = 50;
    [self.locationManager startUpdatingLocation];
    self.locationManager.delegate = self;
    
}

// LocationManagerDelegate Implementation
// Handle incoming location events.
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

// Handle authorization for the location manager.
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusRestricted) {
        
    } else if (status == kCLAuthorizationStatusRestricted) {
        NSLog(@"Location access was restricted.");
    } else if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"User denied access to location.");
        // Display the map using the default location.
        self.mapView.hidden = false;
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"Location status not determined.");
    } else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"Location status is OK.");
    }
}

// Handle location manager errors.
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.locationManager stopUpdatingLocation];
    NSLog(@"Error: %@", error);
}

@end
