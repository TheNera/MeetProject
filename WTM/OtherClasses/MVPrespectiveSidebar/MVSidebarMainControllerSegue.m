//
//  MVSidebarMainControllerSegue.m
//  ParseStarterProject
//
//  Created by indianic on 29/01/15.
//
//

#import "MVSidebarMainControllerSegue.h"
#import "MVPrespectiveSidebar.h"
@implementation MVSidebarMainControllerSegue
-(void)perform{
    MVPrespectiveSidebar *sidebarContainer =[self sourceViewController];
    sidebarContainer.mainController = [self destinationViewController];
}
@end
