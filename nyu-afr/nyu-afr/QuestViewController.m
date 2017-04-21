//
//  QuestViewController.m
//  nyu-afr
//
//  Created by Chairuni Aulia Nusapati on 4/11/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import "QuestViewController.h"
#import "AppDelegate.h"
#import "UserModel.h"

@interface QuestViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *clueLabel1;
@property (weak, nonatomic) IBOutlet UILabel *clueLabel2;
@property (weak, nonatomic) IBOutlet UIButton *goButton;


@end

@implementation QuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if ([[delegate.userModel.userData objectForKey:@"status"] isEqualToString:@"NO_ACTIVE_QUEST"]) {
        // clean the page
        self.titleLabel.text = @"Start Your Journey!";
        self.clueLabel1.text = @"Press the Go! button";
        self.clueLabel2.text = @"to begin a quest";
    } else if ([[delegate.userModel.userData objectForKey:@"status"] isEqualToString:@"QUEST_IN_PROGRESS"]) {
        // populate the page
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goButtonTapped:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([[delegate.userModel.userData objectForKey:@"status"] isEqualToString:@"NO_ACTIVE_QUEST"]) {
        [self startNewQuest];
    }
}

- (void)startNewQuest {
    // find a quest never played before (or just make it random for now)
    // set it to current quest
    // reload view or populate page
}

- (void)goToMap {
    // segue to next page
    // may pass block given by the tab page :)
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
