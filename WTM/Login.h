//
//  Login.h
//  WTM
//
//  Created by Prashant Bhayani on 20/01/15.
//  Copyright (c) 2015 Prashant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface Login : UIViewController
{
    __weak IBOutlet UITextField *txtEmailId;
    __weak IBOutlet UITextField *txtPassword;
    
     PFObject *userDetails;
}
@end
