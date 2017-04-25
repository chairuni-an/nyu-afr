//
//  AppDelegate.h
//  nyu-afr
//
//  Created by Chairuni Aulia Nusapati on 4/9/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
@import Firebase;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UserModel *userModel;
@property (strong, nonatomic) FIRDatabaseReference *ref;


@end

