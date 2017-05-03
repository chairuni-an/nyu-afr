//
//  LoginViewController.m
//  nyu-afr
//
//  Created by Chairuni Aulia Nusapati on 4/11/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import "LoginViewController.h"
#import "MainTabBarController.h"
#import "AppDelegate.h"
#import "UserModel.h"
@import FirebaseAuth;

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailAddressTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.errorLabel.text = @"";
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    _tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:_tapRecognizer];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)isEmailAddressFilled {
    return self.emailAddressTF.text && self.emailAddressTF.text.length > 0;
}

- (BOOL)isPasswordFilled {
    return self.passwordTF.text && self.passwordTF.text.length > 0;
}

- (BOOL)isEveryFieldFilled {
    return [self isEmailAddressFilled] && [self isPasswordFilled];
}

- (BOOL)isEmailAddressValid {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self.emailAddressTF.text];
}

- (void)gotoMainTabBar {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *vc = (MainTabBarController *) [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

- (void)login {
    [[FIRAuth auth]
     signInWithEmail:self.emailAddressTF.text
     password:self.passwordTF.text
     completion:^(FIRUser *user, NSError *error) {
        if (!error) {
            AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            [[[delegate.ref
               child:@"users"]
              child:user.uid]
             observeSingleEventOfType:FIRDataEventTypeValue
             withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                delegate.userModel = [[UserModel alloc] initWithUserData:snapshot.value];
                if (user.displayName != nil) {
                    [delegate.userModel.userData setObject:user.displayName forKey:@"display_name"];
                }
                if (user.photoURL != nil) {
                    NSLog(@"----- photoURL exist");
                    [delegate.userModel.userData setObject:user.photoURL.absoluteString forKey:@"photo_url"];
                    //NSLog(@"----- photoURL is nil!!!");
                } else {
                    NSLog(@"----- photoURL is nil!!!");
                }
                
                [delegate.userModel.userData setObject:self.emailAddressTF.text forKey:@"email"];
                [self gotoMainTabBar];
            } withCancelBlock:^(NSError * _Nonnull error) {
                NSLog(@"%@", error.localizedDescription);
            }];
        } else {
            self.errorLabel.text = @"Incorrect email or password";
        }
    }];
}

- (IBAction)loginClicked:(id)sender {
    if ([self isEveryFieldFilled]) {
        if ([self isEmailAddressValid]) {
            [self login];
        } else {
            self.errorLabel.text = @"Uh oh, double check your email address format";
        }
    } else {
        self.errorLabel.text = @"Oops, make sure you have filled all fields";
    }
}

@end
