//
//  ProfileViewController.m
//  nyu-afr
//
//  Created by Alyssa Hsiang on 4/13/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import "ProfileViewController.h"
@import Firebase;
@interface ProfileViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;

@property (strong, nonatomic) IBOutlet UIButton *editProfile;

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
