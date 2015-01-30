//
//  CreateProfile.h
//  WTM
//
//  Created by Prashant Bhayani on 20/01/15.
//  Copyright (c) 2015 Prashant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface CreateProfile : UIViewController<UINavigationControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate>
{
    __weak IBOutlet UIImageView *imgViewProfile;
    __weak IBOutlet UIScrollView *scrollViewProfile;
    __weak IBOutlet UITextField *txtFName;
    __weak IBOutlet UITextField *txtLName;
    __weak IBOutlet UITextField *txtZipCode;
    __weak IBOutlet UITextField *txtBirthday;
    __weak IBOutlet UITextField *txtMyRide;
    __weak IBOutlet UITextField *txtPrivacy;
    __weak IBOutlet UIView *viewBirthday;
    NSDate *dob;
    __weak IBOutlet UIView *viewPrivacy;
    
    NSArray *privacyArray;
    NSString *strPrivacyValue;
}

@property (nonatomic, strong) NSString *strEmailId;
@property (nonatomic, strong) NSString *strPassword;
@property (nonatomic, readwrite) BOOL isEditMode;
@property (nonatomic, strong) PFObject *profileDetails;
@end
