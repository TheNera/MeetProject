//
//  NEPicPickerButton.h
//  WTM
//
//  Created by Jwalin on 22/02/15.
//
//

#import <UIKit/UIKit.h>

@protocol NEPicPickerButton <NSObject>
-(void)pickPickerButtondidSelectedIOriginalImage:(UIImage*)image editedImage:(UIImage*)editedImage;
-(void)pickPickerButtondidCancelled;
@end

@interface NEPicPickerButton : UIButton{
    UIActionSheet *actionSheet;
    UIAlertController *alertController;
    UIImagePickerController *imgPicker;
    UIViewController *aController;
}

@property(nonatomic,strong)id<NEPicPickerButton>delegate;
@end
