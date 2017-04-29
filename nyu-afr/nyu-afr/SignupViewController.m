//
//  SignupViewController.m
//  nyu-afr
//
//  Created by Chairuni Aulia Nusapati on 4/11/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import "SignupViewController.h"
#import "MainTabBarController.h"
#import "AppDelegate.h"
#import "UserModel.h"
@import FirebaseAuth;

@interface SignupViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailAddressTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *verifyPasswordTF;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.errorLabel.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)isEmailAddressFilled {
    return self.emailAddressTF.text && (self.emailAddressTF.text.length > 0);
}

- (BOOL)isPasswordFilled {
    return self.passwordTF.text && (self.passwordTF.text.length > 0);
}

- (BOOL)isVerifyPasswordFilled {
    return self.verifyPasswordTF.text && (self.verifyPasswordTF.text.length > 0);
}

- (BOOL)isEveryFieldFilled {
    return [self isEmailAddressFilled] && [self isPasswordFilled] && [self isVerifyPasswordFilled];
}

- (BOOL)isEmailAddressValid {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self.emailAddressTF.text];
}

- (BOOL)isPasswordLongEnough {
    return self.passwordTF.text.length >= 6;
}

- (BOOL)doesPasswordAndVerifyPasswordMatch {
    return [self.passwordTF.text isEqualToString:self.verifyPasswordTF.text];
}

- (void)gotoMainTabBar {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *vc = (MainTabBarController *) [storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)signupOnClick:(id)sender {
    if ([self isEveryFieldFilled]) {
        if ([self isEmailAddressValid]) {
            if ([self isPasswordLongEnough]) {
                if ([self doesPasswordAndVerifyPasswordMatch]) {
                    [self signup];
                } else {
                    self.errorLabel.text = @"Hmm, password and verify password doesn't match";
                }
            } else {
                self.errorLabel.text = @"Password is weak, make it at least 6 characters";
            }
        } else {
            self.errorLabel.text = @"Uh oh, double check your email address";
        }
    } else {
        self.errorLabel.text = @"Oops, make sure you have filled all fields";
    }
}

- (void)signup {
    [[FIRAuth auth]
     createUserWithEmail:self.emailAddressTF.text
     password:self.passwordTF.text
     completion:^(FIRUser *_Nullable user, NSError *_Nullable error) {
         if (!error) {
             AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
             [[[delegate.ref child:@"users"] child:user.uid] setValue:@{@"status" : @"NO_ACTIVE_QUEST"}];
             delegate.userModel = [[UserModel alloc] init];
             delegate.userModel.userData = [[NSMutableDictionary alloc] init];
             [delegate.userModel.userData setObject:@"NO_ACTIVE_QUEST" forKey:@"status"];
             [delegate.userModel.userData setObject:self.emailAddressTF.text forKey:@"email"];
             [self gotoMainTabBar];
         } else {
             self.errorLabel.text = @"Cannot sign up, please contact our customer service";
         }
     }];
}

@end
