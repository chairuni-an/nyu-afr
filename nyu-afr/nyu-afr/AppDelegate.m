//
//  AppDelegate.m
//  nyu-afr
//
//  Created by Chairuni Aulia Nusapati on 4/9/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@import Firebase;
@import GoogleMaps;
@import GooglePlaces;
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [FIRApp configure];
    self.ref = [[FIRDatabase database] reference];
    self.storage = [FIRStorage storage];
    [GMSServices provideAPIKey:@"AIzaSyDeKPEQLYkFNRSqm7CySFdrJjmd7FDX1GI"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyDeKPEQLYkFNRSqm7CySFdrJjmd7FDX1GI"];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance]
                    application:application
                    openURL:url
                    sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                    annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    return handled;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
