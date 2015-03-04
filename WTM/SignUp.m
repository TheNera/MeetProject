//
//  SignUp.m
//  WTM
//
//  Created by Prashant Bhayani on 20/01/15.
//  Copyright (c) 2015 Prashant. All rights reserved.
//

#import "SignUp.h"
#import "CreateProfile.h"
#import "Utility.h"

@interface SignUp ()

@end

@implementation SignUp

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set Testfield placeholder color
    [txtEmailId setValue:[UIColor grayColor]
             forKeyPath:@"_placeholderLabel.textColor"];
    [txtPassword setValue:[UIColor grayColor]
               forKeyPath:@"_placeholderLabel.textColor"];
    

}

-(void)viewWillAppear:(BOOL)animated
{
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
    if ([segue.identifier isEqualToString:@"PushToCreateProfile"])
    {
        CreateProfile *cProfile = segue.destinationViewController;
        cProfile.strEmailId = txtEmailId.text;
        cProfile.strPassword = txtPassword.text;
    }
}

#pragma mark - Button Action Methods
- (IBAction)btnSignUpClicked:(UIButton *)sender
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

            PFQuery *aQuery = [PFUser query];
            [aQuery whereKey:@"email" equalTo:strUserName];
            
            [aQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                if(number==0){
                    [self performSegueWithIdentifier:@"PushToCreateProfile" sender:nil];
                }else{
                    [appDel showAlertwithMessage:@"This email is already registered."];
                }
            }];
            

        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please enter valid email id." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];;
        }
    }
}

- (IBAction)backButtonClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - TextField Delegates
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
