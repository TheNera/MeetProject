//
//  IMGoingOverlay.m
//  WTM
//
//  on 11/02/15.
//
//

#import "IMGoingOverlay.h"
#import "Utility.h"
static IMGoingOverlay *view=nil;
@implementation IMGoingOverlay

+(id)showOverlayForMeet:(PFObject *)meet withRefVC:(UIViewController *)controller{
    view = [[NSBundle mainBundle]loadNibNamed:@"IMGoingOverlay" owner:self options:nil].lastObject;
    view.meetInfo = meet;
    view.refVC = controller;
    [view showMeOnController:controller];
    return view;
}

-(void)showMeOnController:(UIViewController*)vc{
    
    [self addBlurViewForiOS8Plus];
    view.frame = appDel.window.bounds;
    _msgView.transform = CGAffineTransformTranslate(_msgView.transform, 0, _msgView.frame.size.height);
    [view bringSubviewToFront:_msgView];
    [appDel.window addSubview:view];
    
    [UIView animateWithDuration:0.3 animations:^{
        visualEffectView.alpha = 1.0;

    }completion:^(BOOL finished) {
       [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:1 animations:^{
        _msgView.transform = CGAffineTransformIdentity;           
       } completion:nil];
    }];
}

-(void)addBlurViewForiOS8Plus{
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.tintColor = [UIColor blackColor];
    visualEffectView.frame = appDel.window.bounds;
    visualEffectView.alpha = 0.0;
    [self addSubview:visualEffectView];
    
}
- (IBAction)btnShareAction:(id)sender {
    [[Utility sharedInstance]shareMeet:_meetInfo viewController:_refVC];
}
- (IBAction)btnNotNowAction:(id)sender {
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:1 animations:^{
        visualEffectView.alpha = 0.0;
        _msgView.transform = CGAffineTransformTranslate(_msgView.transform, 0, _msgView.frame.size.height);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        view = nil;
    }];
}

@end
