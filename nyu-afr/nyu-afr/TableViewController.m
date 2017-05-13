//
//  TableViewController.m
//  nyu-afr
//
//  Created by Alyssa Hsiang on 4/26/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import "TableViewController.h"
#import "SharedData.h"
@import Firebase;

@interface TableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSMutableArray *tableDataArray;
@property (strong, nonatomic) NSMutableArray *keyDataArray;
@property (strong, nonatomic) NSDictionary *quests;

@end

@implementation TableViewController

 NSArray *tableData;
 NSString *test;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    _tableDataArray =  [[NSMutableArray alloc] init];
    _keyDataArray =  [[NSMutableArray alloc] init];
    self.ref = [[FIRDatabase database] reference];
    [[_ref child:@"quests"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        _quests = snapshot.value;
        for(NSString *key in _quests){
            [_tableDataArray addObject:[[_quests objectForKey:key] objectForKey:@"placename"]];
            [_keyDataArray addObject: key];
        }
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];

    _tableview.delegate = self;
    _tableview.dataSource = self;
     tableData = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [_tableDataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SharedData *data = [SharedData sharedInstance];
    [data setPickedLocation:[_tableDataArray objectAtIndex:indexPath.row]];
    [data setPickedKey:[_keyDataArray objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
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
