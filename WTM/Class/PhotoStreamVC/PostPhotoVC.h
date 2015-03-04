//
//  PostPhotoVC.h
//  WTM
//
//  Created by Jwalin Shah on 21/02/15.
//
//

#import <UIKit/UIKit.h>
#import "SelectCategoriesVC.h"
#import "ViewController.h"

@interface PostPhotoVC : UIViewController<SelectCategoriesDelegate,MeetPhotoDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
      SelectCategoriesVC         *selectCategoriesVC;
    PFObject *objMeet;
}
@end
