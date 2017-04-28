//
//  SharedData.h
//  nyu-afr
//
//  Created by Alyssa Hsiang on 4/26/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SharedData : NSObject
@property (nonatomic, strong) NSURL *shareImage;
@property (nonatomic, strong) NSString *pickedLocation;
@property (nonatomic, strong) NSString *pickedKey;

+(SharedData *) sharedInstance;
@end
