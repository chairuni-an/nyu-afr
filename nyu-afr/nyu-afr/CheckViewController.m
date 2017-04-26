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

@interface CheckViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *placenameLabel;
@property (weak, nonatomic) IBOutlet UIButton *choosePlacenameButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic) NSURL *pictureDownloadURL;
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
        
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = false;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }

}

- (IBAction)submitButtonPressed:(id)sender {
    if (self.myImageView.image != nil) {
        [self submitAnswer];
    }
}

- (void)submitAnswer {
    NSLog(@"going to submit answer");
    BOOL isAnswerRight = YES;
    if (isAnswerRight) {
        // upload picture
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        // Data in memory
        NSLog(@"-----A");
        NSData *data = UIImageJPEGRepresentation(self.myImageView.image, 0.8);
        NSLog(@"-----B");
        
        // Create file metadata including the content type
        FIRStorageMetadata *myMetadata = [[FIRStorageMetadata alloc] init];
        myMetadata.contentType = @"image/jpeg";
        
        // Create a root reference
        FIRStorageReference *storageRef = [delegate.storage reference];
        
        // Create a reference to 'user_id/userPhoto/filename.jpg'
        NSLog(@"-----C");

        NSString *uuid = [[NSUUID UUID] UUIDString];
        FIRStorageReference *imageRef = [storageRef child:[NSString stringWithFormat:@"%@/userPhoto/%@", [FIRAuth auth].currentUser.uid, uuid]];
        NSLog(@"-----D");

        // Upload the file to the path "images/rivers.jpg"
        FIRStorageUploadTask *uploadTask = [imageRef putData:data
                                                    metadata:myMetadata
                                                  completion:^(FIRStorageMetadata *metadata,
                                                               NSError *error) {
                                                      if (error != nil) {
                                                          // Uh-oh, an error occurred!
                                                          NSLog(@"-----aaak");

                                                      } else {
                                                          // Metadata contains file metadata such as size, content-type, and download URL.
                                                          self.pictureDownloadURL = metadata.downloadURL;
                                                          NSLog(@"%@", self.pictureDownloadURL);
                                                          [self uploadData];
                                                          
                                                      }
                                                  }];
    }
}

- (void)uploadData {
    NSLog(@"-----upload data");

    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSMutableDictionary *temp;
    [temp setObject:self.pictureDownloadURL forKey:@"selfieURL"];
    //[temp setObject:key forKey:@"key"]; //later for timestamp
    
    NSLog(@"-----bismillah");
    NSMutableDictionary *currentQuest= [delegate.userModel.userData objectForKey:@"current_quest"];
    
    NSString *key = [currentQuest objectForKey:@"key"];

    [[[[[delegate.ref child:@"users"]
        child:[FIRAuth auth].currentUser.uid]
        child: @"quests"]
      child: key]
        setValue: temp];
    NSLog(@"-----Binyong");

}

#pragma mark - PickerDelegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage * img = [info valueForKey:UIImagePickerControllerOriginalImage]; // you can change it to edited image
    
    self.myImageView.image = img;
    
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
