//
//  CollectionViewCell.h
//  nyu-afr
//
//  Created by Alyssa Hsiang on 4/30/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *badgeDisplay;

@property (strong, nonatomic) IBOutlet UILabel *level;
@property (strong, nonatomic) IBOutlet UILabel *typeDisplay;

@end
