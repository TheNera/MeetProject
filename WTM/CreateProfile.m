//
//  CreateProfile.m
//  WTM
//
//  Created by Prashant Bhayani on 20/01/15.
//  Copyright (c) 2015 Prashant. All rights reserved.
//

#import "CreateProfile.h"
#import "SHKActivityIndicator.h"
#import <Parse/Parse.h>

@interface CreateProfile ()

@end

@implementation CreateProfile

@synthesize strEmailId;
@synthesize strPassword;
@synthesize isEditMode;
@synthesize profileDetails;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set Testfield placeholder color
    
    [txtFName setValue:[UIColor blackColor]
            forKeyPath:@"_placeholderLabel.textColor"];
    [txtLName setValue:[UIColor blackColor]
            forKeyPath:@"_placeholderLabel.textColor"];
    [txtZipCode setValue:[UIColor blackColor]
              forKeyPath:@"_placeholderLabel.textColor"];
    [txtBirthday setValue:[UIColor blackColor]
               forKeyPath:@"_placeholderLabel.textColor"];
    [txtMyRide setValue:[UIColor blackColor]
             forKeyPath:@"_placeholderLabel.textColor"];
    [txtPrivacy setValue:[UIColor blackColor]
              forKeyPath:@"_placeholderLabel.textColor"];
    
    if (isEditMode)
    {
        [[SHKActivityIndicator currentIndicator] displayActivity:@"Loading..."];
        [self setUserDetails];
        [btnProfileImage setImage:[UIImage imageNamed:@"banner_cover_image_icon.png"] forState:UIControlStateNormal];
    }
    else
        [btnProfileImage setImage:[UIImage imageNamed:@"takepicture.png"] forState:UIControlStateNormal];
    scrollViewProfile.contentSize = CGSizeMake(310, 730.0);
    viewBirthday.hidden = YES;
    viewPrivacy.hidden = YES;
    
    privacyArray = [[NSArray alloc] initWithObjects:@"Public",@"Private",nil];
    
    appDel.mainController.topbarDatasource =  self;
    appDel.mainController.navigationDelegate = self;
    btnProfileImage.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Custom Methods
- (void) updateUserWithImageFile:(PFFile *)img
{
    PFUser *user = [PFUser currentUser];
    [user setObject:txtFName.text forKey:@"FName"];
    [user setObject:txtLName.text forKey:@"LName"];
    [user setObject:txtZipCode.text forKey:@"ZipCode"];
    [user setObject:txtBirthday.text forKey:@"Birthday"];
    [user setObject:txtMyRide.text forKey:@"Ride"];
    [user setObject:txtPrivacy.text forKey:@"Privacy"];
    
    if (img)
    {
        [user setObject:img forKey:@"ProfileImage"];
        [user setObject:img.url forKey:@"ProfileImageUrl"];
    }
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         [[SHKActivityIndicator currentIndicator] hide];
         
         if (succeeded)
         {
             [[NSNotificationCenter defaultCenter]postNotificationName:@"loginStateChange" object:nil];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Your profile has been updated successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
         else
         {
             NSString *errorString = [[error userInfo] objectForKey:@"error"];
             UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [errorAlertView show];
         }
         
     }];
}
- (void) registerUserWithImageFile:(PFFile *)img
{
    PFUser *newUser = [PFUser user];
    newUser.username = strEmailId;
    newUser.email =strEmailId;
    newUser.password = strPassword;
    [newUser setObject:txtFName.text forKey:@"FName"];
    [newUser setObject:txtLName.text forKey:@"LName"];
    [newUser setObject:txtZipCode.text forKey:@"ZipCode"];
    [newUser setObject:txtBirthday.text forKey:@"Birthday"];
    [newUser setObject:txtMyRide.text forKey:@"Ride"];
    [newUser setObject:txtPrivacy.text forKey:@"Privacy"];
    
    if (img)
    {
        [newUser setObject:img forKey:@"ProfileImage"];
        [newUser setObject:img.url forKey:@"ProfileImageUrl"];
    }
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         [[SHKActivityIndicator currentIndicator] hide];
         
         if (succeeded)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Your profile has been created successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
         }
         else
         {
             NSString *errorString = [[error userInfo] objectForKey:@"error"];
             UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [errorAlertView show];
         }
         
     }];
}
- (void) setUserDetails
{
    txtFName.text = [profileDetails objectForKey:@"FName"];
    txtLName.text = [profileDetails objectForKey:@"LName"];
    txtZipCode.text = [profileDetails objectForKey:@"ZipCode"];
    txtBirthday.text = [profileDetails objectForKey:@"Birthday"];
    txtMyRide.text = [profileDetails objectForKey:@"Ride"];
    txtPrivacy.text = [profileDetails objectForKey:@"Privacy"];
    
    //    PFFile *imageProfile = (PFFile *)[profileDetails objectForKey:@"url"];
    //    imgViewProfile.image = [UIImage imageWithData:imageProfile.getData];
    [imgViewProfile sd_setImageWithURL:[NSURL URLWithString: [profileDetails objectForKey:@"ProfileImageUrl"]] placeholderImage:nil];
    [[SHKActivityIndicator currentIndicator] hide];
}
#pragma mark - Button Action Methods
- (IBAction)btnSaveProfileClicked:(UIButton *)sender
{
    
    if (isEditMode)
    {
        [[SHKActivityIndicator currentIndicator] displayActivity:@"Updating Profile..."];
        
        if (imgViewProfile.image)
        {
            PFFile *file = [PFFile fileWithName:@"ProfileImage" data:UIImageJPEGRepresentation(imgViewProfile.image, 0.5)]; //UIImagePNGRepresentation(imgViewProfile.image)
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded)
                {
                    [self updateUserWithImageFile:file];
                }
                else
                {
                    [[SHKActivityIndicator currentIndicator] hide];
                    
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [errorAlertView show];
                }
            } progressBlock:^(int percentDone) {
                NSLog(@"Uploaded: %d %%", percentDone);
            }];
        }
        else
        {
            [self updateUserWithImageFile:nil];
        }
    }
    else
    {
        [[SHKActivityIndicator currentIndicator] displayActivity:@"Creating Profile..."];
        
        if (imgViewProfile.image)
        {
            PFFile *file = [PFFile fileWithName:@"ProfileImage" data:UIImageJPEGRepresentation(imgViewProfile.image, 0.5)]; //UIImagePNGRepresentation(imgViewProfile.image)
            [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded)
                {
                    [self registerUserWithImageFile:file];
                }
                else
                {
                    [[SHKActivityIndicator currentIndicator] hide];
                    
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [errorAlertView show];
                }
            } progressBlock:^(int percentDone) {
                NSLog(@"Uploaded: %d %%", percentDone);
            }];
        }
        else
        {
            [self registerUserWithImageFile:nil];
        }
    }
}
- (IBAction)btnBirthdayClicked:(UIButton *)sender
{
    [self.view endEditing:YES];
    viewBirthday.hidden = NO;
    viewFaded.hidden = NO;
}
- (IBAction)btnPrivacyClicked:(UIButton *)sender
{
    [self.view endEditing:YES];
    viewPrivacy.hidden = NO;
    viewFaded.hidden = NO;
}
- (IBAction)privacyDoneClicked:(UIButton *)sender
{
    if (strPrivacyValue) {
        txtPrivacy.text = strPrivacyValue;
    }
    else
        txtPrivacy.text = [privacyArray firstObject];
   viewFaded.hidden = viewPrivacy.hidden = YES;
}
- (IBAction)dateDoneClicked:(UIButton *)sender
{
    viewFaded.hidden = viewBirthday.hidden = YES;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    
    txtBirthday.text = [dateFormatter stringFromDate:dob];
}
- (IBAction)privacyCancelClicked:(UIButton *)sender
{
    viewPrivacy.hidden = YES;
    viewBirthday.hidden = YES;
    viewFaded.hidden = YES;
}
- (IBAction)dateCancelClicked:(UIButton *)sender
{
    viewBirthday.hidden = YES;
    viewPrivacy.hidden = YES;
    viewFaded.hidden = YES;
}
- (IBAction)dateSelected:(UIDatePicker *)sender
{
    dob = sender.date;
}

- (IBAction)btnBackClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)takePicture:(UIButton *)sender
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Take Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Gallery", nil];
    [action showInView:self.view];
}

#pragma mark - Action Sheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) // Camera
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.allowsEditing = YES;
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        else
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
    else if (buttonIndex == 1) // Library
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - Image Picker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [btnProfileImage setImage:nil forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:^
     {
         imgViewProfile.image = image;
     }];
}
#pragma mark - Alert View Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma mark - Text Field Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    viewBirthday.hidden = YES;
}
#pragma mark - Picker View DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 2;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [privacyArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    strPrivacyValue = [privacyArray objectAtIndex:row];
}



#pragma mark - Main Controller Delegate and Datasource

-(BOOL)mainControllerShouldShowMenu{
    return YES;
}
-(BOOL)mainControllerShouldShowRightButton{
    return NO;
}
-(BOOL)mainControllerShouldShowRightMostButton{
    return YES;
}

-(BOOL)mainControllerShouldShowTopbar{
    return YES;
}

-(NSString*)mainControllerTitleForScreen{
    if (isEditMode)
    {
        return @"Edit Profile";
    }
    else
        return @"Create Profile";
}

-(id)mainControllerIconForMenu{
    return [UIImage imageNamed:@"back_arrow.png"];
}

-(id)mainControllerIconForRightMostButton{
    return @"Save";
}

-(BOOL)mainControllerNavigationMenuShouldToggleSidebar{
    return NO;
}
-(void)mainControllerNavigationRightMostButtonDidTappedWithObject:(id)object{
    [self btnSaveProfileClicked:nil];
}
-(void)mainControllerNavigationMenuButtonDidTappedWithObject:(id)object{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
