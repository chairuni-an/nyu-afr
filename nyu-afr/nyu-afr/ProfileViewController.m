//
//  ProfileViewController.m
//  nyu-afr
//
//  Created by Alyssa Hsiang on 4/13/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
@import Firebase;

@interface ProfileViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UIButton *editProfile;
@property (weak, nonatomic) IBOutlet UILabel *displayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *questsLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldsLabel;
@property (weak, nonatomic) IBOutlet UILabel *silversLabel;
@property (weak, nonatomic) IBOutlet UILabel *bronzesLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed: @"imageplaceholder.png"];
    _profileImage.layer.cornerRadius = _profileImage.frame.size.height /2;
    _profileImage.layer.masksToBounds = YES;
    _profileImage.layer.borderWidth = 0;
    [_profileImage setImage:image];
    [_editProfile.layer setBorderColor:[[UIColor grayColor] CGColor]];
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *summary = [delegate.userModel.userData objectForKey:@"summary"];
    int questsCount = 0;
    int goldsCount = 0;
    int silversCount = 0;
    int bronzesCount = 0;
    if (summary != nil) {
        NSNumber *quests = [summary objectForKey:@"quests"];
        if (quests != nil) {
            questsCount += [quests intValue];
        }
        NSNumber *golds = [summary objectForKey:@"gold"];
        if (golds != nil) {
            goldsCount += [golds intValue];
        }
        NSNumber *silvers = [summary objectForKey:@"silver"];
        if (silvers != nil) {
            silversCount += [silvers intValue];
        }
        NSNumber *bronzes = [summary objectForKey:@"bronze"];
        if (bronzes != nil) {
            bronzesCount += [bronzes intValue];
        }
    }
    
    self.questsLabel.text = [NSString stringWithFormat:@"%d", questsCount];
    self.goldsLabel.text = [NSString stringWithFormat:@"%d", goldsCount];
    self.silversLabel.text = [NSString stringWithFormat:@"%d", silversCount];
    self.bronzesLabel.text = [NSString stringWithFormat:@"%d", bronzesCount];
    
    
    if ([delegate.userModel.userData objectForKey:@"display_name"] != nil) {
        NSLog(@"-----Not Nil");
        self.displayNameLabel.text = [delegate.userModel.userData objectForKey:@"display_name"];
        self.displayNameLabel.textColor = [UIColor blackColor];
    } else {
        NSLog(@"-----No display name yet");
        self.displayNameLabel.text = @"No Name";
        self.displayNameLabel.textColor = [UIColor colorWithRed: (CGFloat) 155 / (CGFloat)255 green: (CGFloat) 155 / (CGFloat) 255 blue: (CGFloat) 155 / (CGFloat) 255 alpha:1];
    }
    
    // Do any additional setup after loading the view.
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
