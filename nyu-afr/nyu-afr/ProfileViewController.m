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

@interface ProfileViewController () <UIImagePickerControllerDelegate>
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
    
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    NSLog(@"-----%@", self.tabBarController.navigationItem.rightBarButtonItem);
    NSLog(@"-----%@", self.tabBarController.navigationItem.leftBarButtonItem);
    NSLog(@"-----%@", self.tabBarController.navigationItem.backBarButtonItem);
    NSLog(@"-----%@", self.tabBarController.navigationItem);
    NSLog(@"-----%@", self.tabBarController);

    //self.tabBarController.navigationItem.rightBarButtonItem = myButton;
    
    
    
    // Do any additional setup after loading the view.
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.profileImage.layer.cornerRadius = _profileImage.frame.size.height /2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 0;
    if ([delegate.userModel.userData objectForKey:@"photo_url"] != nil) {
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [delegate.userModel.userData objectForKey:@"photo_url"]]];
        if ([UIImage imageWithData: imageData] != nil) {
            self.profileImage.image = [UIImage imageWithData: imageData];
        } else {
            UIImage *image = [UIImage imageNamed: @"profpict-100"];
            [self.profileImage setImage:image];
        }
    } else {
        UIImage *image = [UIImage imageNamed: @"profpict-100"];
        [self.profileImage setImage:image];
    }
    
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
        self.displayNameLabel.text = [delegate.userModel.userData objectForKey:@"display_name"];
        self.displayNameLabel.textColor = [UIColor blackColor];
    } else {
        self.displayNameLabel.text = @"No Name";
        self.displayNameLabel.textColor = [UIColor colorWithRed: (CGFloat) 155 / (CGFloat)255 green: (CGFloat) 155 / (CGFloat) 255 blue: (CGFloat) 155 / (CGFloat) 255 alpha:1];
    }
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
