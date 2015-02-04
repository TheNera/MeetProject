//
//  Login.m
//  WTM
//
//  Created by Prashant Bhayani on 20/01/15.
//  Copyright (c) 2015 Prashant. All rights reserved.
//

#import "Login.h"
#import "Utility.h"
#import "SHKActivityIndicator.h"
#import "CreateProfile.h"
#import "MyProfile.h"

@interface Login ()

@end

@implementation Login

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set Testfield placeholder color
    [txtEmailId setValue:[UIColor grayColor]
              forKeyPath:@"_placeholderLabel.textColor"];
    
    [txtPassword setValue:[UIColor grayColor]
               forKeyPath:@"_placeholderLabel.textColor"];
    
    appDel.mainController.topbarDatasource =  self;
    appDel.mainController.navigationDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PushToMyProfile"])
    {
        MyProfile *profile = segue.destinationViewController;
       
        profile.profileDetails = userDetails;
    }
}

#pragma mark - Custom Methods
- (void) validateUSerWithEmaiId:(NSString *)strEmail password:(NSString *)strPassword
{
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query whereKey:@"EmailId" equalTo:strEmail];
    [query whereKey:@"Password" equalTo:strPassword];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        [[SHKActivityIndicator currentIndicator] hide];
        
        if (objects.count > 0)
        {
            userDetails = [objects objectAtIndex:0];
            NSMutableDictionary *aMutDict = [NSMutableDictionary dictionary];
            [aMutDict setObject:userDetails.objectId forKey:@"objectId"];
            for (NSString*key in userDetails.allKeys) {
                if(![key isEqualToString:@"ProfileImage"]){
                    [aMutDict setObject:userDetails[key] forKey:key];
                }else{
                    PFFile *profilePic = [userDetails objectForKey:key];
                    [aMutDict setObject:profilePic.url forKey:@"url"];
                }
            }
            

            appDel.dictUserInfo = aMutDict;
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLoggedIn"];
            [[NSUserDefaults standardUserDefaults]setObject:aMutDict forKey:@"userDetail"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginStateChange" object:aMutDict];
            NSLog(@"Login Success");
            [self performSegueWithIdentifier:@"PushToMyProfile" sender:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Incorrect Email Id or Password. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}
#pragma mark - Button Action Methods
- (IBAction)btnSignInclicked:(UIButton *)sender
{
    NSString *strUserName = [Utility removeWhiteSpaceFromString:txtEmailId.text];
    NSString *strPassword = [Utility removeWhiteSpaceFromString:txtPassword.text];
    
    if ((![strUserName length] > 0) && (![strPassword length] > 0))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter email id and password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if (![strUserName length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter email id" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if (![strPassword length] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if ([Utility validateEmail:strUserName])
        {
            [[SHKActivityIndicator currentIndicator] displayActivity:@"Validating User..."];
            [self validateUSerWithEmaiId:strUserName password:strPassword];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter valid email id" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];;
        }
    }
}

- (IBAction)backButtonClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Text Field Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = -100;
    self.view.frame = viewFrame;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y = 0;
    self.view.frame = viewFrame;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



#pragma mark - Main Controller Delegate and Datasource

-(BOOL)mainControllerShouldShowTopbar{
    return NO;
}
-(NSString*)mainControllerTitleForScreen{
    return @"";
}


@end
