//
//  EditProfileViewController.m
//  nyu-afr
//
//  Created by Alyssa Hsiang on 4/28/17.
//  Copyright © 2017 New York University. All rights reserved.
//

#import "EditProfileViewController.h"
#import "AppDelegate.h"

@interface EditProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *displayNameField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressField;
@property (nonatomic) NSString *prevDisplayName;
@property (nonatomic) NSString *prevEmailAddress;
@property (nonatomic) BOOL isPhotoURLChanged;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isPhotoURLChanged = false;
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.height/2;
    self.profileImage.layer.masksToBounds = YES;
    self.profileImage.layer.borderWidth = 0;
    if ([delegate.userModel.userData objectForKey:@"photo_url"] != nil) {
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [delegate.userModel.userData objectForKey:@"photo_url"]]];
        if ([UIImage imageWithData: imageData] != nil) {
            self.profileImage.image = [UIImage imageWithData: imageData];
        } else {
            UIImage *image = [UIImage imageNamed: @"imageplaceholder.png"];
            [self.profileImage setImage:image];
        }
    } else {
        UIImage *image = [UIImage imageNamed: @"imageplaceholder.png"];
        [self.profileImage setImage:image];
    }
    if ([delegate.userModel.userData objectForKey:@"display_name"] != nil) {
        self.displayNameField.text = [delegate.userModel.userData objectForKey:@"display_name"];
        self.prevDisplayName = [delegate.userModel.userData objectForKey:@"display_name"];
    } else {
        self.displayNameField.text = @"";
        self.prevDisplayName = @"";
    }
    if ([delegate.userModel.userData objectForKey:@"email"] != nil) {
        self.emailAddressField.text = [delegate.userModel.userData objectForKey:@"email"];
        self.prevEmailAddress = [delegate.userModel.userData objectForKey:@"email"];
    } else {
        self.emailAddressField.text = @"";
        self.prevEmailAddress = @"";
    }
}

- (IBAction)editPhotoTapped:(id)sender {
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:@"Choose Media"
                                message:@"Do you want to take the picture with your camera or photo library?"
                                preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {[self takePhoto];}];
    UIAlertAction* libraryAction = [UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {[self browsePhotoFromLibrary];}];
    [alert addAction:cameraAction];
    [alert addAction:libraryAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)browsePhotoFromLibrary{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = false;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

- (void)takePhoto{
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    self.isPhotoURLChanged = true;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage * img = [info valueForKey:UIImagePickerControllerOriginalImage]; // you can change it to edited image
    self.profileImage.image = img;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editProfileButtonTapped:(id)sender {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.isPhotoURLChanged) {
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSData *data = UIImageJPEGRepresentation(self.profileImage.image, 0.8);
        FIRStorageMetadata *myMetadata = [[FIRStorageMetadata alloc] init];
        myMetadata.contentType = @"image/jpeg";
        FIRStorageReference *storageRef = [delegate.storage reference];
        NSString *uuid = [[NSUUID UUID] UUIDString];
        FIRStorageReference *imageRef = [storageRef child:[NSString stringWithFormat:@"%@/profilePhoto/%@", [FIRAuth auth].currentUser.uid, uuid]];
        FIRStorageUploadTask *uploadTask =
        [imageRef
         putData:data
         metadata:myMetadata
         completion:^(FIRStorageMetadata *metadata,NSError *error) {
             if (error != nil) {
                // Uh-oh, an error occurred!
             } else {
                FIRUserProfileChangeRequest *changeRequest =
                [[FIRAuth auth].currentUser profileChangeRequest];
                changeRequest.photoURL = metadata.downloadURL;
                [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
                    if (!error) {
                        [delegate.userModel.userData setObject:metadata.downloadURL.absoluteString forKey:@"photo_url"];
                        UIAlertController *alert = [UIAlertController
                                                    alertControllerWithTitle:@"Updated!"
                                                    message:@"Your profile was updated"
                                                    preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
                        [alert addAction:noAction];
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                }];
             }
         }];
    }
    if ([self isDisplayNameChanged]) {
        FIRUserProfileChangeRequest *changeRequest =
        [[FIRAuth auth].currentUser profileChangeRequest];
        changeRequest.displayName = self.displayNameField.text;
        [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
            if (!error) {
                [delegate.userModel.userData setObject:self.displayNameField.text forKey:@"display_name"];
                if (!self.isPhotoURLChanged) {
                    UIAlertController *alert = [UIAlertController
                                                alertControllerWithTitle:@"Updated!"
                                                message:@"Your profile was updated"
                                                preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
                    [alert addAction:noAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
        }];
    }
    if ([self isEmailAddressChanged] && [self isEmailAddressValid]) {
        [[FIRAuth auth]
         .currentUser
         updateEmail:self.emailAddressField.text
         completion:^(NSError *_Nullable error) {
             if (!error) {
                 [delegate.userModel.userData setObject:self.emailAddressField.text forKey:@"email"];
                 if (!self.isPhotoURLChanged && ![self isDisplayNameChanged]) {
                     UIAlertController *alert = [UIAlertController
                                                 alertControllerWithTitle:@"Updated!"
                                                 message:@"Your profile was updated"
                                                 preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
                     [alert addAction:noAction];
                     [self presentViewController:alert animated:YES completion:nil];
                 }
             }
         }];
    }
}

- (BOOL)isDisplayNameChanged {
    return ![self.prevDisplayName isEqualToString:self.displayNameField.text];
}

- (BOOL)isEmailAddressChanged {
    return ![self.prevEmailAddress isEqualToString:self.emailAddressField.text];
}

- (BOOL)isEmailAddressValid {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self.emailAddressField.text];
}

@end
