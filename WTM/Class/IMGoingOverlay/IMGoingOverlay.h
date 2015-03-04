//
//  IMGoingOverlay.h
//  WTM
//
//  on 11/02/15.
//
//

#import <UIKit/UIKit.h>

@interface IMGoingOverlay : UIView{
    UIVisualEffectView *visualEffectView;
}
@property (weak, nonatomic) IBOutlet UIView *msgView;
@property(nonatomic,strong)PFObject *meetInfo;
@property(nonatomic,strong)UIViewController *refVC;
+(id)showOverlayForMeet:(PFObject*)meet withRefVC:(UIViewController*)controller;
+(id)showOverlayForLoginController:(UIViewController*)controller;
@end
