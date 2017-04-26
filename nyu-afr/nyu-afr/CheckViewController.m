//
//  CheckViewController.m
//  nyu-afr
//
//  Created by Chairuni Aulia Nusapati on 4/24/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import "CheckViewController.h"
#import "AppDelegate.h"
@import FirebaseStorage;
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "SharedData.h"

@interface CheckViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *placenameLabel;
@property (weak, nonatomic) IBOutlet UIButton *choosePlacenameButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic) NSURL *pictureDownloadURL;
@property (nonatomic) NSString *placeID;
@property (nonatomic) NSString *placename;
@end

@implementation CheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)browsePhotoFromLibrary:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = false;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (IBAction)takePhoto:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        picker.allowsEditing = false;
        picker.showsCameraControls = false;
        [self presentViewController:picker animated:YES
                         completion:^ {
                             [picker takePicture];
                         }];
        
    }

}

- (IBAction)submitButtonPressed:(id)sender {
    // dummy to fill the placeID and placename
    // it should be filled after choosing the placename from the tableview
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.placeID = [[delegate.userModel.userData objectForKey:@"current_quest"] objectForKey:@"key"];
    self.placename = [[delegate.userModel.userData objectForKey:@"current_quest"] objectForKey:@"placename"];
    
    if (self.myImageView.image != nil && self.placeID != nil && self.placename != nil) {
        [self submitAnswer];
    }
}

- (void)submitAnswer {
    if ([self checkAnswer]) {
        // upload picture
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSData *data = UIImageJPEGRepresentation(self.myImageView.image, 0.8);
        FIRStorageMetadata *myMetadata = [[FIRStorageMetadata alloc] init];
        myMetadata.contentType = @"image/jpeg";
        FIRStorageReference *storageRef = [delegate.storage reference];
        NSString *uuid = [[NSUUID UUID] UUIDString];
        FIRStorageReference *imageRef = [storageRef child:[NSString stringWithFormat:@"%@/userPhoto/%@", [FIRAuth auth].currentUser.uid, uuid]];
        FIRStorageUploadTask *uploadTask = [imageRef putData:data
                                                    metadata:myMetadata
                                                  completion:^(FIRStorageMetadata *metadata,
                                                               NSError *error) {
                                                      if (error != nil) {
                                                          // Uh-oh, an error occurred!

                                                      } else {
                                                          // Metadata contains file metadata such as size, content-type, and download URL.
                                                          self.pictureDownloadURL = metadata.downloadURL;
                                                          NSLog(@"%@", self.pictureDownloadURL);
                                                          [self uploadData];
                                                          
                                                      }
                                                  }];
    }
}

- (BOOL)checkAnswer {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([self.placeID isEqualToString:[[delegate.userModel.userData objectForKey:@"current_quest"] objectForKey:@"key"]]) {
        return true;
    } else {
        return false;
    }
}

- (void)uploadData {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSMutableDictionary *currentQuest= [delegate.userModel.userData objectForKey:@"current_quest"];

    [[[[[delegate.ref child: @"users"]
        child: [FIRAuth auth].currentUser.uid]
        child: @"quests"]
        child: [currentQuest objectForKey:@"key"]]
        setValue: @{@"selfie_url": [self.pictureDownloadURL absoluteString], @"timestamp": [FIRServerValue timestamp]}];
    
    NSMutableDictionary *categories = [delegate.userModel.userData objectForKey:@"categories"];
    int categoryCount = 1;
    if (categories != nil) {
        categoryCount += [[categories objectForKey:[currentQuest objectForKey:@"category"]] integerValue];
    }
    [[[[[delegate.ref child:@"users"]
        child: [FIRAuth auth].currentUser.uid]
        child: @"categories"]
        child: [currentQuest objectForKey:@"category"]]
      setValue: [NSNumber numberWithInt:categoryCount]];
    
    [[[[delegate.ref child:@"users"]
        child: [FIRAuth auth].currentUser.uid]
       child: @"status"]
     setValue: @"NO_ACTIVE_QUEST"];
    
    
    
    if (categoryCount == 3 || categoryCount == 2 || categoryCount == 1) {
        [[[[delegate.ref child:@"quest_categories"]
          child:[currentQuest objectForKey:@"category"]]
         child: @"badges"]
         observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
             
             NSString *badgeType;
             if (categoryCount == 3) {
                 badgeType = @"gold";
             } else if (categoryCount == 2) {
                 badgeType = @"silver";
             } else if (categoryCount == 1) {
                 badgeType = @"bronze";
             }
             [[[[[delegate.ref child:@"users"]
                 child: [FIRAuth auth].currentUser.uid]
                child: @"badges"]
               child: [snapshot.value objectForKey: badgeType]]
              setValue: [FIRServerValue timestamp]];
             
    
             NSMutableDictionary *summary = [delegate.userModel.userData objectForKey:@"summary"];
             int badgeCount = 1;
             if (summary != nil) {
                 NSNumber *badge = [delegate.userModel.userData objectForKey:badgeType];
                 if (badge != nil) {
                     badgeCount += [badge intValue];
                 }
             }
             [[[[[delegate.ref child:@"users"]
                 child: [FIRAuth auth].currentUser.uid]
                child: @"summary"]
               child: badgeType]
              setValue: [NSNumber numberWithInt:badgeCount]];
             
             
        } withCancelBlock:^(NSError * _Nonnull error) {
            NSLog(@"%@", error.localizedDescription);
        }];
    }

}

#pragma mark - PickerDelegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    SharedData *data =[SharedData sharedInstance];
    UIImage * img = [info valueForKey:UIImagePickerControllerOriginalImage]; // you can change it to edited image
 
    self.myImageView.image = img;

    [data setShareImage:img];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                                                                   message:@"Share your acheivement to Facebook?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes!" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          [self performSegueWithIdentifier:@"ShareView" sender:nil];
                                                          [alert dismissViewControllerAnimated:TRUE completion:nil];   }];
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No Thanks" style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {}];
    
    [alert addAction:yesAction];
    [alert addAction:noAction];
    [self presentViewController:alert animated:YES completion:nil];
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
