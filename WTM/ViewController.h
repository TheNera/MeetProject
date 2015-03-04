//
//  ViewController.h
//  WTM
//
//  Created by Prashant Bhayani on 20/01/15.
//  Copyright (c) 2015 Prashant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetTableViewCell.h"
#import "MeetDetailVC.h"
#import "IMGoingOverlay.h"
#import "IMLoginOverlay.h"

typedef enum : NSUInteger {
    kMeetsFindMeets = 0,
    kMeetsIAmAttending,
    kMeetsMyMeets,
    kMeetAllMeets,
} MeetListType;

@protocol MeetPhotoDelegate <NSObject>
-(void)getSelectedMeet:(PFObject*)meetObject;
@end

#import "PostPhotoVC.h"

@interface ViewController : UIViewController<MainControllerNavigationDelegate,MainControllerTopbarDatasource,UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate,UITextFieldDelegate,SelectCategoriesDelegate,SelectLocationDelegate>
{
    IMGoingOverlay *overlay;
    IMLoginOverlay *overlayLogin;
    SelectCategoriesVC         *selectCategoriesVC;
    MapVC            *selectLocationVC;
    NSMutableDictionary       *mutDictLocationInfo;
    NSDate *selectedDate;
    NSArray *selectedCategory;
    BOOL isFilterOpen;
}
@property(nonatomic,assign) MeetListType meetListType;
@property(nonatomic,assign)BOOL isSelectMeet;
@property (nonatomic,assign)id <MeetPhotoDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *lblFilterLocation;


@end

