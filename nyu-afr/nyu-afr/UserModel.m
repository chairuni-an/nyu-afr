//
//  UserModel.m
//  nyu-afr
//
//  Created by Chairuni Aulia Nusapati on 4/21/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (id)initWithUserData:(NSMutableDictionary *)userData {
    if (self = [super init]) {
        self.userData = userData;
    }
    return self;
}

@end
