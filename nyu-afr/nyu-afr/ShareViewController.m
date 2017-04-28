//
//  ShareViewController.m
//  nyu-afr
//
//  Created by Alyssa Hsiang on 4/25/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import "ShareViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "SharedData.h"
@interface ShareViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageTest;


@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *myLoginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    myLoginButton.backgroundColor=[UIColor purpleColor];
    myLoginButton.frame=CGRectMake(0,0,180,40);
    myLoginButton.center = self.view.center;
    [myLoginButton setTitle: @"Share to Facebook!" forState: UIControlStateNormal];
    
    // Handle clicks on the button
    [myLoginButton
     addTarget:self
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // Add the button to the view
    [self.view addSubview:myLoginButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginButtonClicked
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    SharedData *data =[SharedData sharedInstance];
    [login logOut];  
    [login
     logInWithReadPermissions: @[@"public_profile"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");

             FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
             photo.image =[data shareImage];
             photo.userGenerated = YES;
             FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
             content.photos = @[photo];
             [FBSDKShareDialog showFromViewController:self
                                          withContent:content
                                             delegate:nil];
      
         }
     }];
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
