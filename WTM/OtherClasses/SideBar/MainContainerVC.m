//
//  MainContainerVC.m
//  WTM
//
//   27/01/15.

//

#import "MainContainerVC.h"
#import <UIKit/UIKit.h>
#define kToggleDuration 0.5

@interface MainContainerVC (){
    BOOL isSideBarOpen;
}

@end

@implementation MainContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnMenuAction:(UIButton *)sender {
    [self toggleSideBar];
}


#pragma mark - SideBar Methods
// This Method will toggle Sidebar In/Out
-(void)toggleSideBar{

    if(isSideBarOpen){
        [self closeSideBar];
    }else{
        [self openSideBar];
    }
}
-(void)closeSideBar{
    isSideBarOpen = NO;
    [UIView animateWithDuration:kToggleDuration delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.5 options:1 animations:^{
        _viewCenterContainer.transform = CGAffineTransformIdentity;
        CGRect rectOfCenterContainer = _viewCenterContainer.frame;
        rectOfCenterContainer.origin.x = 0;
        _viewCenterContainer.frame =rectOfCenterContainer;
    } completion:^(BOOL finished) {
        
    }];
}
-(void)openSideBar{
    isSideBarOpen = YES;
    
    CGAffineTransform aTargetTransformOfCenter = CGAffineTransformScale(_viewCenterContainer.transform, 0.8, 0.8);
    
    [UIView animateWithDuration:kToggleDuration delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.5 options:1 animations:^{
        _viewCenterContainer.transform = aTargetTransformOfCenter;
        CGRect rectOfCenterContainer = _viewCenterContainer.frame;
        rectOfCenterContainer.origin.x = self.view.frame.size.width - 50.0;;
        _viewCenterContainer.frame =rectOfCenterContainer;
        
    } completion:^(BOOL finished) {
        
    }];
}

@end
