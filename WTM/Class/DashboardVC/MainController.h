//
//  MainController.h
//  WTM
//
//   01/02/15.
//
//

#import "MVPrespectiveSidebar.h"
#import "DashboardVC.h"
#import "PhotoStreamVC.h"
#define kNotificationMenuTapped @"menu"
#define kNotificationRightMostTapped @"rightMost"
#define kNotificationRight @"right"

@protocol MainControllerNavigationDelegate <NSObject>
-(BOOL)mainControllerNavigationMenuShouldToggleSidebar;
-(void)mainControllerNavigationMenuButtonDidTappedWithObject:(id)object;
-(void)mainControllerNavigationRightButtonDidTappedWithObject:(id)object;
-(void)mainControllerNavigationRightMostButtonDidTappedWithObject:(id)object;
@end

@protocol MainControllerTopbarDatasource <NSObject>
-(NSString*)mainControllerTitleForScreen;
-(BOOL)mainControllerShouldShowTopbar;
-(BOOL)mainControllerShouldShowMenu;
-(BOOL)mainControllerShouldShowRightButton;
-(BOOL)mainControllerShouldShowRightMostButton;
-(id)mainControllerIconForMenu;
-(id)mainControllerIconForRightButton;
-(id)mainControllerIconForRightMostButton;
-(BOOL)mainControllerTopbarShouldTransperant;
@end



@interface MainController : MVPrespectiveSidebar<DashboardDelegate>{
    BOOL isTopbarTransperant;
}
@property(nonatomic,strong)id<MainControllerNavigationDelegate>navigationDelegate;
@property(nonatomic,strong)id<MainControllerTopbarDatasource>topbarDatasource;
@property(nonatomic,strong)IBOutlet UILabel *lblTitle;
@property(nonatomic,strong)IBOutlet UIButton *btnMenu;
@property(nonatomic,strong)IBOutlet UIButton *btnRight;
@property(nonatomic,strong)IBOutlet UIButton *btnRightMost;

-(void)showImagePreviewOverlay:(PFObject*)info cellObject:(CGRect)cellRect delegate:(id)delegate;
-(void)showMeetDetailScreenWithObject:(NSDictionary*)aDictMeetInfo;
@end
