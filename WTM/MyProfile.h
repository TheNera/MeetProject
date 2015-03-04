//
//  MyProfile.h
//  WTM
//
//  Created by Prashant Bhayani on 20/01/15.
//  Copyright (c) 2015 Prashant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface MyProfile : UIViewController<MainControllerNavigationDelegate,MainControllerTopbarDatasource>
{
    __weak IBOutlet UIImageView *profileImageView;
    
    __weak IBOutlet UILabel *lblMyRide;
    __weak IBOutlet UILabel *lblUserAddress;
    __weak IBOutlet UILabel *lblUserName;
    __weak IBOutlet UILabel *lblUserType;
    __weak IBOutlet UILabel *lblAttenedCount;
}

@property (nonatomic, strong) PFUser *profileDetails;

@end
