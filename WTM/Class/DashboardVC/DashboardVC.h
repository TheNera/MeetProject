//
//  DashboardVC.h
//  WTM
//
//   31/01/15.
//
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    kMenuFindMeets = 0,
    kMenuIAmAttending,
    kMenuMyMeets,
    kMenuPhotostream,
    kMenuSettings
} MenuItems;

@protocol DashboardDelegate <NSObject>
-(void)dashboard:(id)dashboard DidSelectMenu:(MenuItems)menuSelected ;
-(void)dashboardDidTappedToViewProfile:(id)dashboard;
@end
@interface DashboardVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)id<DashboardDelegate>delegate;
-(void)setProfileDetail;
@end
