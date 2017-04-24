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
    NSLog(@"---View will appear!");
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([[delegate.userModel.userData objectForKey:@"status"] isEqualToString:@"NO_ACTIVE_QUEST"]) {
        NSLog(@"---Cleaning the page!");
        // clean the page
        self.titleLabel.text = @"Start Your Journey!";
        self.clueLabel1.text = @"Press the Go! button";
        self.clueLabel2.text = @"to begin a quest";
    } else if ([[delegate.userModel.userData objectForKey:@"status"] isEqualToString:@"QUEST_IN_PROGRESS"]) {
        NSLog(@"---Populating the page!");
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
        [[[delegate.ref child:@"users"] child:userID] setValue:@{@"status": @"QUEST_IN_PROGRESS"}];
        [delegate.userModel.userData setObject:@"QUEST_IN_PROGRESS" forKey:@"current_quest"];
        
        for (NSString *key in quests) {
            if (i == rand1) {
                [delegate.userModel.userData setObject:[quests objectForKey:key] forKey:@"current_quest"];
                
                NSMutableDictionary *temp = [quests objectForKey:key];
                [temp setObject:key forKey:@"key"];
                
                [[[[delegate.ref child:@"users"] child:userID] child: @"current_quest"] setValue: temp];
            } else if (i == rand2) {
                [delegate.userModel.userData setObject:[quests objectForKey:key] forKey:@"deception_quest1"];
                
                NSMutableDictionary *temp = [quests objectForKey:key];
                [temp setObject:key forKey:@"key"];
                
                [[[[delegate.ref child:@"users"] child:userID] child: @"deception_quest1"] setValue: temp];
            } else if (i == rand3) {
                [delegate.userModel.userData setObject:[quests objectForKey:key] forKey:@"deception_quest2"];
                
                NSMutableDictionary *temp = [quests objectForKey:key];
                [temp setObject:key forKey:@"key"];
                
                [[[[delegate.ref child:@"users"] child:userID] child: @"deception_quest2"] setValue: temp];
            }
            
            if ([delegate.userModel.userData objectForKey:@"current_quest"] != nil && [delegate.userModel.userData objectForKey:@"deception_quest1"] != nil && [delegate.userModel.userData objectForKey:@"deception_quest2"] != nil) {
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
    //AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.titleLabel.text = [NSString stringWithFormat:@"QUEST #"];
    self.clueLabel1.text = [NSString stringWithFormat:@"Syalala"];
    self.clueLabel2.text = [NSString stringWithFormat:@"Syalili"];
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
