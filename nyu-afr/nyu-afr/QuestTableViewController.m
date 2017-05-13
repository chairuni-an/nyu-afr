//
//  QuestTableViewController.m
//  nyu-afr
//
//  Created by Alyssa Hsiang on 4/30/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import "QuestTableViewController.h"
#import "QuestTableViewCell.h"
@import Firebase;

@interface QuestTableViewController ()

@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRDatabaseReference *refQuests;
@property (strong, nonatomic) NSDictionary *questsCompleted;
@property (strong, nonatomic) NSDictionary *achievements;
@property (strong, nonatomic) NSDictionary *questsDatabase;
@property (strong, nonatomic) NSMutableArray *tableDataArray;
@property (strong, nonatomic) NSMutableArray *questNameArray;
@property (strong, nonatomic) NSMutableArray *questURLArray;
@property (strong, nonatomic) NSMutableArray *timeStampArray;
@property (strong, nonatomic) NSMutableArray *formattedDateArray;
@property (strong, nonatomic) NSMutableArray *questCategoryArray;

@end

@implementation QuestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableDataArray = [[NSMutableArray alloc] init];
    _questNameArray = [[NSMutableArray alloc] init];
    _questURLArray = [[NSMutableArray alloc] init];
    _questCategoryArray = [[NSMutableArray alloc] init];
    _timeStampArray = [[NSMutableArray alloc] init];
    _formattedDateArray = [[NSMutableArray alloc] init];
    FIRUser *user = [FIRAuth auth].currentUser;
    self.ref = [[FIRDatabase database] reference];
    self.refQuests = [[FIRDatabase database] reference];

    [[[_ref child:@"users"] child: user.uid ]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        _achievements = snapshot.value;

        for (NSString *key in _achievements) {
            if ([key isEqualToString:@"quests"]) {
                _questsCompleted = [_achievements objectForKey:key];
            }
        }

        for (NSString *key in _questsCompleted) {
            [_tableDataArray addObject:key];
            [_questURLArray addObject:[[_questsCompleted objectForKey:key] objectForKey:@"selfie_url"]];
            [_timeStampArray addObject:[[_questsCompleted objectForKey:key] objectForKey:@"timestamp"]];
            }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        for(NSString *time in _timeStampArray){
            double timeDouble = [time doubleValue];
            NSTimeInterval timeInterval = timeDouble/1000;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
            NSString *formattedDateString = [dateFormatter stringFromDate:date];
            [_formattedDateArray addObject:formattedDateString];
        }
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
    [[_refQuests child:@"quests"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        _questsDatabase = snapshot.value;

        for (NSString *key in _questsDatabase) {
            [_questCategoryArray addObject: key];
        }
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    for (NSString *strComapre in _tableDataArray) {
        if ([_questCategoryArray containsObject:strComapre]) {
            [_questNameArray addObject: [[_questsDatabase objectForKey:strComapre] objectForKey:@"placename"]];
        }
    }
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    static NSString *cellIdentifier = @"Cell";
    QuestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    cell.questName.text = [_questNameArray objectAtIndex:indexPath.row];
    cell.date.text = [_formattedDateArray objectAtIndex:indexPath.row];
    cell.questNumber.text = [NSString stringWithFormat:@"Quest# %ld -", (long)indexPath.row + 1];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[_questURLArray objectAtIndex:indexPath.row]]];
        if (data == nil)
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.selfieImage.image = [UIImage imageWithData:data];
        });
    });
    
    return cell;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [_tableDataArray count];
}

@end
