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
@property (weak, nonatomic) IBOutlet UIButton *goButton;

@end

@implementation QuestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[delegate.userModel.userData objectForKey:@"status"] isEqualToString:@"NO_ACTIVE_QUEST"]) {
        self.titleLabel.text = @"Start Your Journey!";
        self.clueLabel1.text = @"Press the Go! button to begin a quest";

    } else if ([[delegate.userModel.userData objectForKey:@"status"] isEqualToString:@"QUEST_IN_PROGRESS"]) {
        [self setPageWithQuest];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)goButtonTapped:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[delegate.userModel.userData objectForKey:@"status"] isEqualToString:@"NO_ACTIVE_QUEST"]) {
        [self startNewQuest];
    } else if ([[delegate.userModel.userData objectForKey:@"status"] isEqualToString:@"QUEST_IN_PROGRESS"]) {
        [self.tabBarController setSelectedIndex:1];
    }
}

- (void)startNewQuest {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate.ref child:@"quests"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString *userID = [FIRAuth auth].currentUser.uid;
        [[[[delegate.ref child:@"users"]
           child:userID]
          child:@"status"]
         setValue:@"QUEST_IN_PROGRESS"];
        [delegate.userModel.userData setObject:@"QUEST_IN_PROGRESS" forKey:@"status"];
        NSDictionary *quests = snapshot.value;
        int i = 0;
        int rand1 = arc4random() % snapshot.childrenCount;
        int rand2 = arc4random() % snapshot.childrenCount;
        int rand3 = arc4random() % snapshot.childrenCount;
        while (rand2 == rand1)
            rand2 = arc4random() % snapshot.childrenCount;
        while (rand3 == rand2)
            rand3 = arc4random() % snapshot.childrenCount;
        BOOL isCurrentQuestChosen = false;
        BOOL isDeceptionQuest1Chosen = false;
        BOOL isDeceptionQuest2Chosen = false;
        for (NSString *key in quests) {
            if (i == rand1) {
                [delegate.userModel.userData setObject:[quests objectForKey:key] forKey:@"current_quest"];
                NSMutableDictionary *temp = [quests objectForKey:key];
                [temp setObject:key forKey:@"key"];
                [[[[delegate.ref child:@"users"] child:userID] child:@"current_quest"] setValue:temp];
                isCurrentQuestChosen = true;
            } else if (i == rand2) {
                [delegate.userModel.userData setObject:[quests objectForKey:key] forKey:@"deception_quest1"];
                NSMutableDictionary *temp = [quests objectForKey:key];
                [temp setObject:key forKey:@"key"];
                [[[[delegate.ref child:@"users"] child:userID] child:@"deception_quest1"] setValue:temp];
                isDeceptionQuest1Chosen = true;
            } else if (i == rand3) {
                [delegate.userModel.userData setObject:[quests objectForKey:key] forKey:@"deception_quest2"];
                NSMutableDictionary *temp = [quests objectForKey:key];
                [temp setObject:key forKey:@"key"];
                [[[[delegate.ref child:@"users"] child:userID] child:@"deception_quest2"] setValue:temp];
                isDeceptionQuest2Chosen = true;
            }
            if (isCurrentQuestChosen && isDeceptionQuest1Chosen && isDeceptionQuest2Chosen) {
                [self setPageWithQuest];
                break;
            }
            i++;
        }
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)setPageWithQuest {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *summary = [delegate.userModel.userData objectForKey:@"summary"];
    int questCount = 1;
    if (summary != nil) {
        NSNumber *quests = [summary objectForKey:@"quests"];
        if (quests != nil) {
            questCount += [quests intValue];
        }
    }
    NSString *text = [[delegate.userModel.userData objectForKey:@"current_quest"] objectForKey:@"clue"];

    self.titleLabel.text = [NSString stringWithFormat:@"QUEST #%d", questCount];
    self.clueLabel1.text = text;

}

@end
