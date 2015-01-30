//
//  MyProfile.m
//  WTM
//
//  Created by Prashant Bhayani on 20/01/15.
//  Copyright (c) 2015 Prashant. All rights reserved.
//

#import "MyProfile.h"
#import "SHKActivityIndicator.h"
#import "CreateProfile.h"

@interface MyProfile ()

@end

@implementation MyProfile

@synthesize profileDetails;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[SHKActivityIndicator currentIndicator] displayActivity:@"Loading..."];
    [self setUserDetails];
    [self getAdminUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PushToCreateProfile"])
    {
        CreateProfile *profile = segue.destinationViewController;
        profile.isEditMode = YES;
        profile.profileDetails = profileDetails;
    }
}

#pragma mark - Button Action Methods
- (IBAction)btnBackClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnEditClicked:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"PushToCreateProfile" sender:nil];
}
#pragma mark - Custom Methods
- (void) setUserDetails
{
    PFFile *imageProfile = (PFFile *)[profileDetails objectForKey:@"ProfileImage"];
    profileImageView.image = [UIImage imageWithData:imageProfile.getData];
    profileImageView.clipsToBounds = YES;
    profileImageView.layer.cornerRadius = 100.0;
    profileImageView.layer.borderWidth = 5.0;
    profileImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    lblUserName.text = [NSString stringWithFormat:@"%@ %@",[profileDetails objectForKey:@"FName"],[profileDetails objectForKey:@"LName"]];
    lblUserAddress.text = [profileDetails objectForKey:@"ZipCode"];
    lblMyRide.text = [profileDetails objectForKey:@"Ride"];
    
    [[SHKActivityIndicator currentIndicator] hide];
}

- (void) getAdminUser
{
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            PFObject *admin = [objects lastObject];
            if ([[admin objectForKey:@"EmailId"] isEqualToString:[profileDetails objectForKey:@"EmailId"]] && [[admin objectForKey:@"Password"] isEqualToString:[profileDetails objectForKey:@"Password"]])
            {
                lblUserType.text = @"User Type : Admin";
            }
            else
            {
                lblUserType.text = @"User Type : normal user";
            }
        }
        else
        {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
}
@end
