//
//  IMLoginOverlay.m
//  WTM
//
//  Created by Jwalin Shah on 13/02/15.
//
//

#import "IMLoginOverlay.h"
static IMLoginOverlay *view=nil;

@implementation IMLoginOverlay
+(id)showOverlayForMeet:(PFObject *)meet withRefVC:(UIViewController *)controller{
    view = [[NSBundle mainBundle]loadNibNamed:@"IMLoginOverlay" owner:self options:nil].lastObject;
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
- (IBAction)btnSignUpAction:(id)sender
{
    [self removeOverLay];
    [_refVC performSegueWithIdentifier:@"SignUp" sender:nil];
}
- (IBAction)btnLoginAction:(id)sender
{
    [self removeOverLay];
    [_refVC performSegueWithIdentifier:@"LogIn" sender:nil];
}
- (IBAction)btnCancelAction:(id)sender {
    [self removeOverLay];
 }
-(void)removeOverLay
{
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:1 animations:^{
        visualEffectView.alpha = 0.0;
        _msgView.transform = CGAffineTransformTranslate(_msgView.transform, 0, _msgView.frame.size.height);
    }
                     completion:^(BOOL finished) {
                         [view removeFromSuperview];
                         view = nil;
                         
                     }];

}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
