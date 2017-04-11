//
//  Model.m
//  nyu-afr
//
//  Created by Chairuni Aulia Nusapati on 4/11/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import "Model.h"
@import Firebase;

@interface Model ()
    @property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation Model

- (void)foo {
    self.ref = [[FIRDatabase database] reference];
}

@end
