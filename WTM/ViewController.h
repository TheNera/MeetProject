//
//  ViewController.h
//  WTM
//
//  Created by Prashant Bhayani on 20/01/15.
//  Copyright (c) 2015 Prashant. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kMeetsFindMeets = 0,
    kMeetsIAmAttending,
    kMeetsMyMeets,
} MeetListType;

@interface ViewController : UIViewController<MainControllerNavigationDelegate,MainControllerTopbarDatasource>
@property(nonatomic,assign) MeetListType meetListType;

@end

