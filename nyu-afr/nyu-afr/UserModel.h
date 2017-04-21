//
//  UserModel.h
//  nyu-afr
//
//  Created by Chairuni Aulia Nusapati on 4/21/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (strong, nonatomic) NSDictionary *userData;
- (id)initWithUserData:(NSDictionary *)userData;

@end
