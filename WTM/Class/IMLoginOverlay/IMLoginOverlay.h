//
//  IMLoginOverlay.h
//  WTM
//
//  Created by Jwalin Shah on 13/02/15.
//
//

#import <UIKit/UIKit.h>

@interface IMLoginOverlay : UIView
{
    UIVisualEffectView *visualEffectView;
}
@property (weak, nonatomic) IBOutlet UIView *msgView;
@property(nonatomic,strong)PFObject *meetInfo;
@property(nonatomic,strong)UIViewController *refVC;
+(id)showOverlayForMeet:(PFObject*)meet withRefVC:(UIViewController*)controller;
+(id)showOverlayForLoginController:(UIViewController*)controller;
@end
