//
//  MainContainerVC.h
//  WTM
//
//   27/01/15.

//

#import <UIKit/UIKit.h>

@interface MainContainerVC : UIViewController

//Outlets
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnRightMost;
@property (weak, nonatomic) IBOutlet UILabel *btnRight;
@property (weak, nonatomic) IBOutlet UIView *viewCenterContainer;
@property (weak, nonatomic) IBOutlet UIView *contControllersHolder;
@property (weak, nonatomic) IBOutlet UIView *viewTopBar;

@end
