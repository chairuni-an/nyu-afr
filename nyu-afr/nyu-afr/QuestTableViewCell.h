//
//  QuestTableViewCell.h
//  nyu-afr
//
//  Created by Alyssa Hsiang on 4/30/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *selfieImage;
@property (strong, nonatomic) IBOutlet UILabel *questName;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *questNumber;

@end
