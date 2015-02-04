//
//  ViewController.m
//  WTM
//
//  Created by Prashant Bhayani on 20/01/15.
//  Copyright (c) 2015 Prashant. All rights reserved.
//

#import "ViewController.h"
#import "AddMeetVC.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnSignup;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDel.mainController.topbarDatasource =  self;
    appDel.mainController.navigationDelegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginStateChangeHandler:) name:@"loginStateChange" object:nil];
    [self loginStateChangeHandler:nil];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)loginStateChangeHandler:(NSNotification*)notification{
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isLoggedIn"]){
        _btnLogin.hidden=YES;
        _btnSignup.hidden = YES;
    }else{
        _btnLogin.hidden=NO;
        _btnSignup.hidden = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    appDel.mainController.topbarDatasource =  self;
    appDel.mainController.navigationDelegate = self;
}

#pragma mark - Main Controller Delegate and Datasource

-(BOOL)mainControllerShouldShowMenu{
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"isLoggedIn"];    
}
-(BOOL)mainControllerShouldShowRightButton{
    return YES;
}
-(BOOL)mainControllerShouldShowRightMostButton{
    return YES;
}

-(BOOL)mainControllerShouldShowTopbar{
    return YES;
}

-(id)mainControllerIconForMenu{
    return [UIImage imageNamed:@"menu_icon.png"];
}
-(id)mainControllerIconForRightButton{
    return [UIImage imageNamed:@"calender.png"];
}
-(id)mainControllerIconForRightMostButton{
    return [UIImage imageNamed:@"camera.png"];
}

-(NSString*)mainControllerTitleForScreen{
    switch (_meetListType) {
        case kMeetsFindMeets:
            return @"FIND MEETS";
            break;
        case kMeetsMyMeets:
            return @"MY MEETS";
            break;
        case kMeetsIAmAttending:
            return @"I'M ATTENDING";
            break;
        default:
            break;
    }

}
-(void)mainControllerNavigationRightMostButtonDidTappedWithObject:(id)object{
    
}
-(void)mainControllerNavigationRightButtonDidTappedWithObject:(id)object{
    AddMeetVC *addMeetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddMeetVC"];
    [self.navigationController pushViewController:addMeetVC animated:YES];
//    [appDel.mainController addMainController:addMeetVC withAnimation:YES];
}
@end
