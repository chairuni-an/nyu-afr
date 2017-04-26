//
//  SharedData.m
//  nyu-afr
//
//  Created by Alyssa Hsiang on 4/26/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import "SharedData.h"

@implementation SharedData
@synthesize shareImage= _shareImage;


static SharedData *_sharedInstance;

- (id) init{
    if(self = [super init]){
        
    }
    
    return self;
    
}

+ (SharedData *) sharedInstance{
    if(!_sharedInstance){
        _sharedInstance = [[SharedData alloc] init];
    }
    
    return _sharedInstance;
}

@end
