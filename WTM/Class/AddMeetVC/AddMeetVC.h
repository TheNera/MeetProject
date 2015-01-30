//
//  AddMeetVC.h
//  WTM
//
//   27/01/15.

//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "SelectCategoriesVC.h"
#import "SelectLocationVC.h"
#import "MapVC.h"
@interface AddMeetVC : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,SelectCategoriesDelegate,SelectLocationDelegate>
{
    SelectCategoriesVC         *selectCategoriesVC;
    MapVC            *selectLocationVC;
    NSDate *startDate,*endDate;
    
    NSMutableDictionary       *mutDictLocationInfo;
    NSMutableArray              *mutArrCategories;
}

@end
