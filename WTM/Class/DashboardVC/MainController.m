//
//  MainController.m
//  WTM
//
//   01/02/15.
//
//

#import "MainController.h"
#import "MyProfile.h"
#import "ViewController.h"
#import "PreviewVC.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface MainController ()
{
    PreviewVC *previewVC;
    UIVisualEffectView *visualEffectView;
    NSDictionary *aDictMeetInfoToPass;
}
@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDel.mainController =self;
    [(DashboardVC*)self.sideMenuController setDelegate:self];
    
//    [self addBlurryBG];
    // Do any additional setup after loading the view.
}

-(void)addBlurryBG{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        visualEffectView.tintColor = [UIColor colorWithRed:62/255.0 green:65/255.0 blue:76/255.0 alpha:0.9];
        visualEffectView.frame = self.topbar.bounds;
        visualEffectView.alpha = 0.8;
        [self.topbar insertSubview:visualEffectView atIndex:0];
        self.topbar.backgroundColor = [UIColor clearColor];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Actions

- (IBAction)btnMenuAction:(id)sender {
    
    if(![_navigationDelegate respondsToSelector:@selector(mainControllerNavigationMenuShouldToggleSidebar)] || [_navigationDelegate mainControllerNavigationMenuShouldToggleSidebar]){
        [self toggleSidebar];
    }
    
    if([_navigationDelegate respondsToSelector:@selector(mainControllerNavigationMenuButtonDidTappedWithObject:)]){
        [_navigationDelegate mainControllerNavigationMenuButtonDidTappedWithObject:self];
    }
}

- (IBAction)btnRightButtonAction:(id)sender {
    if([_navigationDelegate respondsToSelector:@selector(mainControllerNavigationRightButtonDidTappedWithObject:)]){
        [_navigationDelegate mainControllerNavigationRightButtonDidTappedWithObject:self];
    }
}

- (IBAction)btnRightMostButtonAction:(id)sender {
    if([_navigationDelegate respondsToSelector:@selector(mainControllerNavigationRightMostButtonDidTappedWithObject:)]){
        [_navigationDelegate mainControllerNavigationRightMostButtonDidTappedWithObject:self];
    }
}

#pragma mark - Dashboard Delegate Methods
-(void)dashboard:(id)dashboard DidSelectMenu:(MenuItems)menuSelected{
    switch (menuSelected) {
        case kMenuMyMeets:{
            UINavigationController *meetsNavigation = [self.storyboard instantiateViewControllerWithIdentifier:@"MeetsNavigation"];
            ViewController *viewMeetsController = [meetsNavigation.viewControllers firstObject];
            viewMeetsController.meetListType = kMeetsMyMeets;
            [self addControllerToMainController: viewMeetsController controllerToAdd:meetsNavigation];
            break;
        }
        case kMenuFindMeets:{
            UINavigationController *meetsNavigation = [self.storyboard instantiateViewControllerWithIdentifier:@"MeetsNavigation"];
            ViewController *viewMeetsController = [meetsNavigation.viewControllers firstObject];
            viewMeetsController.meetListType = kMeetsFindMeets;
            [self addControllerToMainController: viewMeetsController controllerToAdd:meetsNavigation];
            
            break;
        }        case kMenuIAmAttending:{
            UINavigationController *meetsNavigation = [self.storyboard instantiateViewControllerWithIdentifier:@"MeetsNavigation"];
            ViewController *viewMeetsController = [meetsNavigation.viewControllers firstObject];
            viewMeetsController.meetListType = kMeetsIAmAttending;
            [self addControllerToMainController: viewMeetsController controllerToAdd:meetsNavigation];
            
            break;
        }        case kMenuPhotostream:
        {
            UINavigationController *meetsNavigation = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoNavigation"];
            PhotoStreamVC   *viewMeetsController = [meetsNavigation.viewControllers firstObject];
            [self addControllerToMainController: viewMeetsController controllerToAdd:meetsNavigation];
            break;
        }
        case kMenuSettings:
            break;
            
        default:
            break;
    }
    [self closeSidebar];
}
-(void)dashboardDidTappedToViewProfile:(id)dashboard{
    UINavigationController *aProfileNav = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfileNavigation"];
    MyProfile *profileVC = [aProfileNav.viewControllers firstObject];
    profileVC.profileDetails = [PFUser currentUser];
    [self addControllerToMainController:profileVC controllerToAdd:aProfileNav];
    [self closeSidebar];
}

-(void)addControllerToMainController:(UIViewController<MainControllerNavigationDelegate,MainControllerTopbarDatasource>*)controller controllerToAdd:(UIViewController*)controllerToAdd{
    self.navigationDelegate =controller;
    self.topbarDatasource = controller;
    [self addMainController:controllerToAdd withAnimation:YES];
    
}

-(void)setTopbarDatasource:(id<MainControllerTopbarDatasource>)topbarDatasource{
    _topbarDatasource =  topbarDatasource;
    [self checkForTopbarVisibilty];
}
-(void)checkForTopbarVisibilty{
    if([_topbarDatasource respondsToSelector:@selector(mainControllerTitleForScreen)]){
        self.lblTitle.text = [_topbarDatasource mainControllerTitleForScreen];
    }
    
    if([_topbarDatasource respondsToSelector:@selector(mainControllerShouldShowTopbar)]){
        BOOL shouldShowTopbar = [_topbarDatasource mainControllerShouldShowTopbar];
        self.topbar.hidden = !shouldShowTopbar;
        if(shouldShowTopbar){
            BOOL aResponds = [_topbarDatasource respondsToSelector:@selector(mainControllerTopbarShouldTransperant)] ;
            if(aResponds && [_topbarDatasource mainControllerTopbarShouldTransperant]){
                [UIView animateWithDuration:0.3 animations:^{
                    self.topbar.backgroundColor = kTopbarTransperantBGColor;
                }];
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    self.topbar.backgroundColor = kTopbarBGColor;
                }];
            }
            [self checkForIconsAndVisibilityOfTopbarButtons];
        }
    }
}
-(void)checkForIconsAndVisibilityOfTopbarButtons{
    
    if([_topbarDatasource respondsToSelector:@selector(mainControllerShouldShowMenu)]){
        self.btnMenu.hidden = ![_topbarDatasource mainControllerShouldShowMenu];
    }
    
    if([_topbarDatasource respondsToSelector:@selector(mainControllerShouldShowRightButton)]){
        self.btnRight.hidden = ![_topbarDatasource mainControllerShouldShowRightButton];
    }
    
    if([_topbarDatasource respondsToSelector:@selector(mainControllerShouldShowRightMostButton)]){
        self.btnRightMost.hidden = ![_topbarDatasource mainControllerShouldShowRightMostButton];
    }
    
    if([_topbarDatasource respondsToSelector:@selector(mainControllerIconForMenu)]){
        UIImage *aImg =[_topbarDatasource mainControllerIconForMenu];
        if([aImg isKindOfClass:[NSString class]]){
            [self.btnMenu setTitle:(NSString*)aImg forState:UIControlStateNormal];
            [self.btnMenu setImage:nil forState:UIControlStateNormal];
        }else{
            [self.btnMenu setTitle:@"" forState:UIControlStateNormal];
            [self.btnMenu setContentEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
            [self.btnMenu setImage:aImg forState:UIControlStateNormal];
        }
        
    }else{
        [self.btnMenu setTitle:@"" forState:UIControlStateNormal];
        [self.btnMenu setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self.btnMenu setImage:[UIImage imageNamed:@"menu_icon.png"] forState:UIControlStateNormal];
    }
    
    if([_topbarDatasource respondsToSelector:@selector(mainControllerIconForRightButton)]){
        UIImage *aImg =[_topbarDatasource mainControllerIconForRightButton];
        if([aImg isKindOfClass:[NSString class]]){
            [self.btnRight setTitle:(NSString*)aImg forState:UIControlStateNormal];
            [self.btnRight setImage:nil forState:UIControlStateNormal];
        }else{
            [self.btnRight setTitle:@"" forState:UIControlStateNormal];
            [self.btnRight setImage:aImg forState:UIControlStateNormal];
        }
    }
    
    if([_topbarDatasource respondsToSelector:@selector(mainControllerIconForRightMostButton)]){
        UIImage *aImg =[_topbarDatasource mainControllerIconForRightMostButton];
        if([aImg isKindOfClass:[NSString class]]){
            [self.btnRightMost setTitle:(NSString*)aImg forState:UIControlStateNormal];
            [self.btnRightMost setImage:nil forState:UIControlStateNormal];
        }else{
            [self.btnRightMost setTitle:@"" forState:UIControlStateNormal];
            [self.btnRightMost setImage:aImg forState:UIControlStateNormal];
        }        }
}

#pragma mark - Preview Screen Overlay
-(void)showImagePreviewOverlay:(PFObject*)info cellObject:(CGRect)cellRect delegate:(id)delegate{
    previewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PreviewVC"];
    previewVC.delegate =delegate;
    [self addChildViewController:previewVC];
    [self.view addSubview:previewVC.view];
    

    [previewVC loadPreviewScreenWithInfo:info refRect:cellRect];
   
    
}

-(void)showMeetDetailScreenWithObject:(NSDictionary*)aDictMeetInfo{
    [self dashboard:self DidSelectMenu:kMenuFindMeets];
}

@end
