//
//  AcheivementsViewController.m
//  nyu-afr
//
//  Created by Alyssa Hsiang on 4/13/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import "AcheivementsViewController.h"
#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"
@import Firebase;

@interface AcheivementsViewController ()  < UICollectionViewDelegate, UICollectionViewDataSource >


@property (strong, nonatomic) IBOutlet UILabel *badgeCheck;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRDatabaseReference *refBadges;
@property (strong, nonatomic) FIRDatabaseReference *refCategories;

@property (strong, nonatomic) NSDictionary *achievements;
@property (strong, nonatomic) NSDictionary *badges;
@property (strong, nonatomic) NSDictionary *badgesDatabase;
@property (strong, nonatomic) NSDictionary *categoriesDatabase;
@property (nonatomic, assign) BOOL hasBadges;
@property (strong, nonatomic) NSMutableArray *tempArray;
@property (strong, nonatomic) NSMutableArray *tempArray2;
@property (strong, nonatomic) NSMutableArray *tempArray3;

@property (strong, nonatomic) NSMutableArray *badgeURLArray;
@property (strong, nonatomic) NSMutableArray *badgeLevelArray;
@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (strong, nonatomic) NSMutableArray *typeArray;

@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;


@end


@implementation AcheivementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource= self;
    self.myCollectionView.backgroundColor = [UIColor whiteColor];

    FIRUser *user = [FIRAuth auth].currentUser;
    _tempArray =  [[NSMutableArray alloc] init];
    _tempArray2 =  [[NSMutableArray alloc] init];
    _tempArray3 =  [[NSMutableArray alloc] init];
    _badgeURLArray =  [[NSMutableArray alloc] init];
    _badgeLevelArray =  [[NSMutableArray alloc] init];
    _categoryArray =  [[NSMutableArray alloc] init];
    _typeArray =  [[NSMutableArray alloc] init];
    self.ref = [[FIRDatabase database] reference];
    self.refBadges = [[FIRDatabase database] reference];
    self.refCategories = [[FIRDatabase database] reference];
    
    [[[_ref child:@"users"] child: user.uid ]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        _achievements = snapshot.value;
        // ...
        _hasBadges = false;
        
        
        for(NSString *key in _achievements){
            if([key isEqualToString:@"badges"] ){
                _hasBadges = true;
                _badges = [_achievements objectForKey:key];
                
            }
        
        }
        //NSLog(@"%@", _badges );
        if(_hasBadges == true){
            for(NSString *key in _badges){
                [_tempArray addObject: key];
                
            }
            
            
        }

        

        //NSString *subString = [string substringWithRange:NSMakeRange(0,7)];
       
        
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
    [[_refBadges child:@"badges"]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            // Get user value
            _badgesDatabase = snapshot.value;
            // ...
            
            
            for(NSString *key in _badgesDatabase){
                [_tempArray2 addObject: key];
                
                
            }
            
        } withCancelBlock:^(NSError * _Nonnull error) {
            NSLog(@"%@", error.localizedDescription);
        }];
        
    
    [[_refBadges child:@"quest_categories"]  observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        // Get user value
        _categoriesDatabase = snapshot.value;
        // ...
        
        
        for(NSString *key in _categoriesDatabase){
            [_tempArray3 addObject: key];
            
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
    if(_hasBadges == true){
        _badgeCheck.text = @"";
        for (NSString *strComapre in _tempArray)
        {
            NSLog(@"%@",strComapre);
            if ([_tempArray2 containsObject:strComapre])
            {
                NSLog(@"Compare");
                [_badgeURLArray addObject: [[_badgesDatabase objectForKey:strComapre] objectForKey:@"trophy_picture_url"]];
                [_badgeLevelArray addObject: [[_badgesDatabase objectForKey:strComapre] objectForKey:@"type"]];
                [_categoryArray addObject: [[_badgesDatabase objectForKey:strComapre] objectForKey:@"category"]];
                
            }
            else
            {
                NSLog(@"Not Compare");
            }
            
            
            
        }
        
        for (NSString *strComapre in _categoryArray)
        {
            NSLog(@"%@",strComapre);
            if ([_tempArray3 containsObject:strComapre])
            {
                NSLog(@"Compare");
                [_typeArray addObject: [[_categoriesDatabase objectForKey:strComapre] objectForKey:@"title"]];
             
                
            }
            else
            {
                NSLog(@"Not Compare");
            }
            
            
            
        }
  
        
       
    }else{
        _badgeCheck.text = @"Sorry you haven't earned any badges :(";
    }
    

    [self.myCollectionView reloadData];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%lu", (unsigned long)[_badgeURLArray count]);
    return [_badgeURLArray count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    //[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_badgeURLArray objectAtIndex:indexPath.row]]]]
    cell.layer.borderWidth=1.0f;
    cell.layer.borderColor=[UIColor purpleColor].CGColor;
    //cell.badgeDisplay.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_badgeURLArray objectAtIndex:indexPath.row]]]];
    cell.level.text = [_badgeLevelArray objectAtIndex:indexPath.row];
    cell.typeDisplay.text = [_typeArray objectAtIndex:indexPath.row];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [_badgeURLArray objectAtIndex:indexPath.row]]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            cell.badgeDisplay.image = [UIImage imageWithData: data];
        });
        
    });
    
    
    return cell;
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
