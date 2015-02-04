//
//  MVPrespectiveSidebar.m
//  ParseStarterProject
//
//  Created by indianic on 29/01/15.
//
//

#import "MVPrespectiveSidebar.h"

#define kSideMenuWidth 255
#define kRightMargin kSideMenuWidth-10
@interface MVPrespectiveSidebar ()
{
    UIView *contMainController;
    UIView *contSideMenuController;
    UIView *contMainControllerContainer;
    CATransform3D origionalTransformBG;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgViewBG;
@end

@implementation MVPrespectiveSidebar
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    origionalTransformBG = CATransform3DTranslate(CATransform3DIdentity, 0, 0, -50);
    _imgViewBG.layer.transform = origionalTransformBG;
    
    _angle = 0;
    contMainController = [[UIView alloc]initWithFrame:self.view.bounds];
    contMainControllerContainer =[[UIView alloc]initWithFrame:contMainController.bounds];
    contSideMenuController = [[UIView alloc]initWithFrame:CGRectZero];
    contMainController.backgroundColor = [UIColor clearColor];
    contSideMenuController.backgroundColor = [UIColor clearColor];
    contMainController.userInteractionEnabled = YES;
    contSideMenuController.userInteractionEnabled = YES;

    [self.view addSubview:contSideMenuController];
    [self.view addSubview:contMainController];
    [contMainController addSubview:contMainControllerContainer];
    
    CGRect rectOfTopbar = _topbar.frame;
    rectOfTopbar.origin.x=0;
    rectOfTopbar.origin.y=0;
    _topbar.frame =rectOfTopbar;
    [contMainController addSubview:_topbar];
    
    [self performSegueWithIdentifier:kSegueNameForMainController sender:self];
    [self performSegueWithIdentifier:kSegueNameForSideMenu sender:self];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kSegueNameForMainController]){
        self.mainController = segue.destinationViewController;
    }else if ([segue.identifier isEqualToString:kSegueNameForSideMenu]){
        self.sideMenuController = segue.destinationViewController;
    }
}
#pragma mark - Custom Controller Setters and Updaters
-(void)setMainController:(UIViewController *)mainController{
    if(_mainController){
        [_mainController.view removeFromSuperview];
        [_mainController removeFromParentViewController];
        _mainController.view = nil;
        _mainController = nil;
    }
    _mainController = mainController;
    [self updateMainController];
}
-(void)setSideMenuController:(UIViewController *)sideMenuController{
    if(_sideMenuController){
        [_sideMenuController.view removeFromSuperview];
        [_sideMenuController removeFromParentViewController];
        _sideMenuController.view = nil;
        _sideMenuController = nil;
    }
    _sideMenuController = sideMenuController;
    [self updateSideMenuController];
}

-(void)updateSideMenuController{    
    CGRect rectMenu = contSideMenuController.frame;
    rectMenu.size.width = kSideMenuWidth;
    rectMenu.size.height = self.view.frame.size.height;
    contSideMenuController.frame = rectMenu;
    
    [self addChildViewController:_sideMenuController];
    rectMenu = _sideMenuController.view.frame;
    rectMenu.origin =  CGPointZero;
    rectMenu.size.width = kSideMenuWidth;
    rectMenu.size.height = self.view.frame.size.height;
    _sideMenuController.view.frame=rectMenu;
    [contSideMenuController addSubview:_sideMenuController.view];
    
}

-(void)updateMainController{
    [self addChildViewController:_mainController];
    [contMainControllerContainer addSubview:_mainController.view];
}

#pragma mark - Public Methods
-(void)addMainController:(UIViewController*)aMainController withAnimation:(BOOL)shouldAnimate{
    self.mainController =aMainController;
}
-(void)openSidebar{
    if([_delegate respondsToSelector:@selector(sidebarWillChangeItsState:)]){
        [_delegate sidebarWillChangeItsState:YES];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kSidebarNotificationWillOpen object:nil];
    CATransform3D transform = CATransform3DIdentity;
    transform.m34= 1.0 / -500;
    transform = CATransform3DRotate(transform, _angle * M_PI / 180.0f, 0, 1, 0);
    transform = CATransform3DScale(transform, 0.8, 0.8, 0.8);
    _isSidebarOpened = YES;
    

    CATransform3D transformBG = CATransform3DIdentity;
    transformBG.m34= 1.0 / -500;
    transformBG = CATransform3DTranslate(transformBG, 0, 0, -100);
    transformBG =CATransform3DScale(transformBG, 1.2, 1.2, 1.2);
    
    
    CGRect rectNewForMainContainer =  contMainController.frame;
    rectNewForMainContainer.origin.x = kRightMargin;
    
    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:1 animations:^{
        _imgViewBG.layer.transform = transformBG;
    }completion:nil];
    
    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:1 animations:^{
        contMainController.frame = rectNewForMainContainer;
        contMainController.layer.transform = transform;
        contSideMenuController.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        if([_delegate respondsToSelector:@selector(sidebarDidChangedItsState:)]){
            [_delegate sidebarDidChangedItsState:YES];
        }
    }];
}
-(void)closeSidebar{
    
    if([_delegate respondsToSelector:@selector(sidebarWillChangeItsState:)]){
        [_delegate sidebarWillChangeItsState:NO];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kSidebarNotificationWillClose object:nil];
    CATransform3D transform = CATransform3DIdentity;
    _isSidebarOpened = NO;

    CGRect rectNewForMainContainer =  contMainController.frame;
    rectNewForMainContainer.origin.x = 0;
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:1 animations:^{
        contMainController.frame =self.view.bounds;
        _imgViewBG.layer.transform = origionalTransformBG;
        contMainController.layer.transform = transform;
        contMainController.transform =CGAffineTransformIdentity;
        CGAffineTransform viewTransform = CGAffineTransformTranslate(contSideMenuController.transform, -(contSideMenuController.frame.size.width), 0);
        contSideMenuController.transform = viewTransform;
    } completion:^(BOOL finished) {
        if([_delegate respondsToSelector:@selector(sidebarDidChangedItsState:)]){
            [_delegate sidebarDidChangedItsState:NO];
        }
    }];
}
-(void)toggleSidebar{
    if(_isSidebarOpened){
        [self closeSidebar];
    }else{
        [self openSidebar];
    }
}


//-(void)animateSubViewsForState:(BOOL)isOpened{
//    NSInteger intCounter = 0;
//    for (UIView *aView in self.view.subviews) {
//        if(aView == contMainController){
//            continue;
//        }
//        intCounter++;
//        [UIView animateWithDuration:0.4 delay:intCounter * 0.2 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:1 animations:^{
//            if(isOpened){
//                aView.transform = CGAffineTransformIdentity;
//            }else{
//                aView.transform =CGAffineTransformTranslate(aView.transform, -20, 0);
//            }
//        } completion:^(BOOL finished) {
//            
//        }];
//    }
//}

@end
