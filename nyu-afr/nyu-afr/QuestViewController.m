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
@property (weak, nonatomic) IBOutlet UILabel *clueLabel3;
@property (weak, nonatomic) IBOutlet UILabel *clueLabel4;
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
        self.clueLabel1.text = @"Press the Go! button to begin a quest";
        self.clueLabel2.text = @"";
        self.clueLabel3.text = @"";
        self.clueLabel4.text = @"";
    } else if ([[delegate.userModel.userData objectForKey:@"status"] isEqualToString:@"QUEST_IN_PROGRESS"]) {
        // populate the page
        [self setPageWithQuest];
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
    } else if ([[delegate.userModel.userData objectForKey:@"status"] isEqualToString:@"QUEST_IN_PROGRESS"]) {
        [self goToMap];
    }

}

- (void)startNewQuest {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[delegate.ref child:@"quests"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *quests = snapshot.value;
        int i = 0;
        int rand1 = arc4random() % snapshot.childrenCount;
        int rand2 = arc4random() % snapshot.childrenCount;
        int rand3 = arc4random() % snapshot.childrenCount;
        
        while (rand2 == rand1) {
            rand2 = arc4random() % snapshot.childrenCount;
        }
        while (rand3 == rand2) {
            rand3 = arc4random() % snapshot.childrenCount;
        }
        
        NSString *userID = [FIRAuth auth].currentUser.uid;
        [[[[delegate.ref child: @"users"]
           child: userID]
          child:@"status"]
         setValue:@"QUEST_IN_PROGRESS"];
        [delegate.userModel.userData setObject:@"QUEST_IN_PROGRESS" forKey:@"status"];
        
        BOOL isCurrentQuestChosen = false;
        BOOL isDeceptionQuest1Chosen = false;
        BOOL isDeceptionQuest2Chosen = false;
        
        for (NSString *key in quests) {
            if (i == rand1) {
                [delegate.userModel.userData setObject:[quests objectForKey:key] forKey:@"current_quest"];
                
                NSMutableDictionary *temp = [quests objectForKey:key];
                [temp setObject:key forKey:@"key"];
                
                [[[[delegate.ref child:@"users"] child:userID] child: @"current_quest"] setValue: temp];
                
                isCurrentQuestChosen = true;
            } else if (i == rand2) {
                [delegate.userModel.userData setObject:[quests objectForKey:key] forKey:@"deception_quest1"];
                
                NSMutableDictionary *temp = [quests objectForKey:key];
                [temp setObject:key forKey:@"key"];
                
                [[[[delegate.ref child:@"users"] child:userID] child: @"deception_quest1"] setValue: temp];
                
                isDeceptionQuest1Chosen = true;
            } else if (i == rand3) {
                [delegate.userModel.userData setObject:[quests objectForKey:key] forKey:@"deception_quest2"];
                
                NSMutableDictionary *temp = [quests objectForKey:key];
                [temp setObject:key forKey:@"key"];
                
                [[[[delegate.ref child:@"users"] child:userID] child: @"deception_quest2"] setValue: temp];
                
                isDeceptionQuest2Chosen = true;
            }
            
            if (isCurrentQuestChosen && isDeceptionQuest1Chosen && isDeceptionQuest2Chosen) {
                [self setPageWithQuest];
                break;
            }
            
            i++;
        }
        
        // ...
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
    
    
    // find a quest never played before (or just make it random for now)
    // set it to current quest
    // reload view or populate page
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
    NSString *text1 = @"";
    NSString *text2 = @"";
    NSString *text3 = @"";
    NSString *text4 = @"";
    
    if (text.length <= 40) {
        text1 = text;
    } else if (text.length <= 80) {
        text1 = [text substringToIndex:39];
        text2 = [text substringFromIndex:40];
    } else if (text.length <= 120) {
        text1 = [text substringToIndex:39];
        text2 = [text substringWithRange:NSMakeRange(40, 40)];
        text3 = [text substringFromIndex:80];
    } else if (text.length <= 160) {
        text1 = [text substringToIndex:39];
        text2 = [text substringWithRange:NSMakeRange(40, 40)];
        text3 = [text substringWithRange:NSMakeRange(80, 40)];
        text4 = [text substringFromIndex:120];
    } else if (text.length > 160) {
        text1 = [text substringToIndex:39];
        text2 = [text substringWithRange:NSMakeRange(40, 40)];
        text3 = [text substringWithRange:NSMakeRange(80, 40)];
        text4 = [text substringWithRange:NSMakeRange(120, 40)];
    }
    
    self.titleLabel.text = [NSString stringWithFormat:@"QUEST #%d", questCount];
    self.clueLabel1.text = text1;
    self.clueLabel2.text = text2;
    self.clueLabel3.text = text3;
    self.clueLabel4.text = text4;
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
