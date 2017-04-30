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
    _tableDataArray =  [[NSMutableArray alloc] init];
    _questNameArray =  [[NSMutableArray alloc] init];
    _questURLArray =  [[NSMutableArray alloc] init];
    _questCategoryArray =  [[NSMutableArray alloc] init];
    _timeStampArray=  [[NSMutableArray alloc] init];
    _formattedDateArray=  [[NSMutableArray alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    FIRUser *user = [FIRAuth auth].currentUser;
  
    self.ref = [[FIRDatabase database] reference];
    self.refQuests = [[FIRDatabase database] reference];

    [[[_ref child:@"users"] child: user.uid ]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        _achievements = snapshot.value;
        // ...
  
        
        for(NSString *key in _achievements){
            if([key isEqualToString:@"quests"] ){
  
                _questsCompleted = [_achievements objectForKey:key];
                
                
            }
            
        }

        for(NSString *key in _questsCompleted){
            [_tableDataArray addObject: key];
            [_questURLArray addObject:[[_questsCompleted objectForKey:key] objectForKey:@"selfie_url"]];
            [_timeStampArray addObject:[[_questsCompleted objectForKey:key] objectForKey:@"timestamp"]];
                
            }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        for(NSString *time in _timeStampArray){
            double timeDouble = [time doubleValue];
            NSTimeInterval timeInterval=timeDouble/1000;
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
            NSString *formattedDateString = [dateFormatter stringFromDate:date];
            [_formattedDateArray addObject: formattedDateString];
        }
       
 
        //NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:162000];
        
        
        
        NSLog(@"%@", _formattedDateArray);
        NSLog(@"%@", _questURLArray);
        
        
        
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
    
    
    [[_refQuests child:@"quests"]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        _questsDatabase = snapshot.value;
        // ...
        
        
        for(NSString *key in _questsDatabase){
            [_questCategoryArray addObject: key];
            
            
        }
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    for (NSString *strComapre in _tableDataArray)
    {
        NSLog(@"%@",strComapre);
        if ([_questCategoryArray containsObject:strComapre])
        {
            NSLog(@"Compare");
            [_questNameArray addObject: [[_questsDatabase objectForKey:strComapre] objectForKey:@"placename"]];
            
        }
        else
        {
            NSLog(@"Not Compare");
        }
        
    }
    NSLog(@"%@", _questNameArray);
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    static NSString *cellIdentifier = @"Cell";
    QuestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    cell.questName.text = [_questNameArray objectAtIndex:indexPath.row];
    cell.date.text = [_formattedDateArray objectAtIndex:indexPath.row];
    cell.questNumber.text = [NSString stringWithFormat:@"Quest# %ld -", (long)indexPath.row + 1];
    cell.selfieImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_questURLArray objectAtIndex:indexPath.row]]]];
    
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
