//
//  NEPicPickerButton.m
//  WTM
//
//  Created by Jwalin on 22/02/15.
//
//

#import "NEPicPickerButton.h"

@implementation NEPicPickerButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    [self addTarget:self action:@selector(performPicSelection:) forControlEvents:UIControlEventTouchUpInside];
    UIViewController *aController = [self viewController];
  
}
-(IBAction)performPicSelection:(id)sender{
    
    imgPicker = [[UIImagePickerController alloc]init];
    imgPicker.delegate = self;
#ifdef __IPHONE_8_0
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        alertController =[UIAlertController alertControllerWithTitle:@"WTM" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                       {
                                           [self actionSheetCamera];
                                       }];
        
        UIAlertAction *actionCameraRoll = [UIAlertAction actionWithTitle:@"Camera Roll" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                           {
                                               [self actionSheetCameraRoll];
                                           }];
        
        UIAlertAction *actionLibrary = [UIAlertAction actionWithTitle:@"Choose From Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                        {
                                            [self actionSheetLibrary];
                                        }];
        
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                       {
                                       }];
        
        [alertController addAction:actionCamera];
        [alertController addAction:actionCameraRoll];
        [alertController addAction:actionLibrary];
        [alertController addAction:actionCancel];
      [aController presentViewController:alertController animated:YES completion:nil];
        
    }
    else
#endif
    {
        actionSheet = [[UIActionSheet alloc]initWithTitle:@"WTM" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo"@"Camera Roll",@"Choose From Library", nil];
        [actionSheet showInView:aController.view];
    }
}



-(void)postPhoto{
    
}

- (UIViewController*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    
    return nil;
}

#pragma mark - ActionSheet
-(void)actionSheetCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [aController presentViewController:imgPicker animated:YES completion:nil];
    }
    
}
-(void)actionSheetCameraRoll{
    imgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [aController presentViewController:imgPicker animated:YES completion:nil];
}
-(void)actionSheetLibrary{
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [aController presentViewController:imgPicker animated:YES completion:nil];
}

#pragma UIActonSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self actionSheetCamera];
            break;
        case 1:
            [self actionSheetCameraRoll];
            break;
        case 2:
            [self actionSheetLibrary];
            break;
        default:
            [self actionSheetLibrary];
            break;
    }
    imgPicker.delegate = self;
}

#pragma mark - UIimagePicker Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imgInfo = info[UIImagePickerControllerOriginalImage];
    UIImage *imgEdied = info[UIImagePickerControllerEditedImage];
    
    if([_delegate respondsToSelector:@selector(pickPickerButtondidSelectedIOriginalImage:editedImage:)]){
        [_delegate pickPickerButtondidSelectedIOriginalImage:imgInfo editedImage:imgEdied];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if([_delegate respondsToSelector:@selector(pickPickerButtondidCancelled)]){
        [_delegate pickPickerButtondidCancelled];
    }
}

@end
