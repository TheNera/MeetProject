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
#import "UIImageView+WebCache.h"
@interface MyProfile ()

@end

@implementation MyProfile

@synthesize profileDetails;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    profileDetails  = [[NSUserDefaults standardUserDefaults]objectForKey:@"userDetail"];
        // Do any additional setup after loading the view.
    appDel.mainController.topbarDatasource = self;
    appDel.mainController.navigationDelegate = self;

    self.navigationController.navigationBarHidden = YES;
    [[SHKActivityIndicator currentIndicator] displayActivity:@"Loading..."];
    [self getNoOfMeetsAttended];
    }
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    profileDetails = [PFUser currentUser];
    [self setUserDetails];
    [self getAdminUser];
    appDel.mainController.topbarDatasource = self;
    appDel.mainController.navigationDelegate = self;
    self.navigationController.navigationBarHidden = YES;
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
//    PFFile *imageProfile = (PFFile *)[profileDetails objectForKey:@"ProfileImage"];

    [profileImageView sd_setImageWithURL:[NSURL URLWithString:profileDetails[@"ProfileImageUrl"]]];
    profileImageView.clipsToBounds = YES;
    profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2.0;
    profileImageView.layer.borderWidth = 5.0;
    profileImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    lblUserName.text = [NSString stringWithFormat:@"%@ %@",[profileDetails objectForKey:@"FName"],[profileDetails objectForKey:@"LName"]];
    lblUserAddress.text = [profileDetails objectForKey:@"ZipCode"];
    lblMyRide.text = [profileDetails objectForKey:@"Ride"];
    
    [[SHKActivityIndicator currentIndicator] hide];
}

- (void) getAdminUser
{
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
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

-(void)getNoOfMeetsAttended{
    
    PFQuery *aQuery = [PFQuery queryWithClassName:@"Attendees"];
    [aQuery whereKey:@"userId" equalTo:[PFUser currentUser].objectId];
    [aQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        lblAttenedCount.text = [NSString stringWithFormat:@"Attended %d meets",number];
    }];
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
    return @"My Profile";
}

//-(id)mainControllerIconForMenu{
//    return [UIImage imageNamed:@"back_arrow.png"];
//}
-(id)mainControllerIconForRightMostButton{
    return @"Edit";
}

-(BOOL)mainControllerNavigationMenuShouldToggleSidebar{
    return YES;
}
-(void)mainControllerNavigationRightMostButtonDidTappedWithObject:(id)object{
     [self performSegueWithIdentifier:@"PushToCreateProfile" sender:nil];
}
-(void)mainControllerNavigationMenuButtonDidTappedWithObject:(id)object{
    
}
-(BOOL)mainControllerTopbarShouldTransperant{
    return YES;
}
@end
