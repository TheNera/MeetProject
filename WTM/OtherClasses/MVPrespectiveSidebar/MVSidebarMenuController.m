//
//  MVSidebarMenuController.m
//  ParseStarterProject
//
//  Created by indianic on 29/01/15.
//
//

#import "MVSidebarMenuController.h"
#import "MVPrespectiveSidebar.h"

@implementation MVSidebarMenuControllerSegue
-(void)perform{
    MVPrespectiveSidebar *sidebarContainer =[self sourceViewController];
    sidebarContainer.mainController = [self destinationViewController];
}
@end
