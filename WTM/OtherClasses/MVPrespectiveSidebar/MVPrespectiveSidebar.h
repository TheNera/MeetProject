//
//  MVPrespectiveSidebar.h
//  ParseStarterProject
//
//  Created by indianic on 29/01/15.
//
//

#import <UIKit/UIKit.h>
#define kSegueNameForMainController @"mainController"
#define kSegueNameForSideMenu       @"sideMenu"

#define kSidebarNotificationWillOpen @"sidebarOpened"
#define kSidebarNotificationWillClose @"sidebarClosed"

@protocol SidebarDelegate <NSObject>
-(void)sidebarWillChangeItsState:(BOOL)willOpened;
-(void)sidebarDidChangedItsState:(BOOL)isOpened;
@end

@interface MVPrespectiveSidebar : UIViewController

@property(nonatomic,strong)id<SidebarDelegate>delegate;
@property(nonatomic,assign)BOOL isSidebarOpened;
@property(nonatomic,assign)BOOL shouldShowCommonTopbar;
@property(nonatomic,strong)UIViewController *sideMenuController;
@property(nonatomic,strong)UIViewController *mainController;
@property(nonatomic,assign)CGFloat angle;
@property (weak, nonatomic) IBOutlet UIView *topbar;

-(void)addMainController:(UIViewController*)aMainController withAnimation:(BOOL)shouldAnimate;
-(void)openSidebar;
-(void)closeSidebar;
-(void)toggleSidebar;
@end
