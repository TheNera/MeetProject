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

@protocol EditMeetDelegate <NSObject>
-(void)meetDidEditedWithNewData:(PFObject*)object;
@end
@interface AddMeetVC : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,SelectCategoriesDelegate,SelectLocationDelegate,MainControllerNavigationDelegate,MainControllerTopbarDatasource,UIAlertViewDelegate>
{
    SelectCategoriesVC         *selectCategoriesVC;
    MapVC            *selectLocationVC;
    NSDate *startDate,*endDate;
    
    NSMutableDictionary       *mutDictLocationInfo;
    NSMutableArray              *mutArrCategories;
}
@property (nonatomic,strong)PFObject *editMeetObject;
@property (nonatomic,strong)id<EditMeetDelegate>delegate;
@end
