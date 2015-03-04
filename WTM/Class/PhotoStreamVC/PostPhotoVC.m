//
//  PostPhotoVC.m
//  WTM
//
//  Created by Jwalin Shah on 21/02/15.
//
//

#import "PostPhotoVC.h"
#import "NEPicPickerButton.h"
#import "NSString+Validation.h"
@interface PostPhotoVC()<NEPicPickerButton>{
    UIImagePickerController *imgPicker;
    UIAlertController *alertController;
    UIActionSheet *actionSheet;
}
@property (weak, nonatomic) IBOutlet NEPicPickerButton *btnSelectImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPhoto;
@property (weak, nonatomic) IBOutlet UITextField *txtMeetName;
@property (weak, nonatomic) IBOutlet UITextField *txtCategories;
@property (weak, nonatomic) IBOutlet UITextView *txtViewDetail;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *TpScrollView;

@end

@implementation PostPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _btnSelectImage.delegate = self;
    [_TpScrollView contentSizeToFit];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Methods
- (IBAction)btnSelectPhotoAction:(id)sender {
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
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    #endif
    {
        actionSheet = [[UIActionSheet alloc]initWithTitle:@"WTM" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo"@"Camera Roll",@"Choose From Library", nil];
        [actionSheet showInView:self.view];
    }
}


- (IBAction)btnSelectCategory:(id)sender {
    [self presentSelectCategoriesScreen];
}
- (IBAction)btnGetMeet:(id)sender {
    ViewController *objMeetList = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    self.navigationController.navigationBarHidden  = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
//    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
    objMeetList.delegate = self;
    objMeetList.isSelectMeet = YES;
    objMeetList.meetListType = kMeetAllMeets;
    [self.navigationController pushViewController:objMeetList animated:YES];
}

- (IBAction)btnPostPhoto:(id)sender {
    [self postPhoto];
}
- (IBAction)btnCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - MeetSelect Delegate
-(void)getSelectedMeet:(PFObject *)meetObject
{
    objMeet = meetObject;
    _txtMeetName.text = meetObject[@"title"];
}
-(void)postPhoto{
//    objMeet = [PFObject objectWithoutDataWithClassName:@"Meets" objectId:@"eJIiMFPVJW"];
    
    if([self validateFields]){
        [[SHKActivityIndicator currentIndicator]show];
        NSData *aDataImg = UIImageJPEGRepresentation(_imgViewPhoto.image, 0.3);
        PFFile *aFileImage = [PFFile fileWithData:aDataImg];
        [aFileImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded){

                //Get Path and Store it in Photostream Class
                NSString *aStrUrl = aFileImage.url;
                NSLog(@"Photo Uploaded.. %@",aStrUrl);
                PFObject *aObjectToSave = [PFObject objectWithClassName:@"Photostream"];
                [aObjectToSave setObject:aStrUrl forKey:@"image"];

                [aObjectToSave setObject:objMeet forKey:@"meet"];
                [aObjectToSave setObject:[PFUser currentUser] forKey:@"user"];
                [aObjectToSave setObject:[appDel convertDateToUTC:[NSDate date]] forKey:@"date"];
                [aObjectToSave setObject:_txtViewDetail.text forKey:@"description"];
                [aObjectToSave setObject:_txtCategories.text forKey:@"categories"];
                
                [aObjectToSave saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(succeeded)
                        [appDel showAlertwithMessage:@"Photo posted successfully."];
                    else{
                        [appDel showAlertwithMessage:@"Sorry, unable to post this Photo, try later."];
                    }
                    [[SHKActivityIndicator currentIndicator]hide];
                }];
                
            }else{
                    [[SHKActivityIndicator currentIndicator]hide];
                    [appDel showAlertwithMessage:@"Sorry, unable to post this Photo, try later."];
            }
        }];
    }
}

-(BOOL)validateFields{
    if(!_imgViewPhoto.image){
        [appDel showAlertwithMessage:@"Please select an Image for Meet."];
        return NO;
    }else if (!objMeet){
        [appDel showAlertwithMessage:@"Please select a Meet."];
        return NO;
    }else if (![_txtCategories.text isValidString]){
        [appDel showAlertwithMessage:@"Please select at least one Category."];
        return NO;
    }
    return YES;
}
#pragma mark -  Select Categories Delegates and Presenting It
-(void)selectCategoriesDidCancelled{
    // Called when user taps Cancel in Categories screen
}
-(void)selectCategoriesDidFinishedWithCategories:(NSArray *) arrCategories{
    if (arrCategories.count>0)
    {
        _txtCategories.text = [[arrCategories valueForKey:@"categoryName"] componentsJoinedByString:@","];
    }else{
        _txtCategories.text =@"";
    }
}
-(void)presentSelectCategoriesScreen{
    if(selectCategoriesVC){
        [selectCategoriesVC dismissViewControllerAnimated:NO completion:^{
            selectCategoriesVC = nil;
        }];
    }
    selectCategoriesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectCategoriesVC"];
    selectCategoriesVC.delegate =self;
    selectCategoriesVC.strSelectedCategory = _txtCategories.text;
    [self presentViewController:selectCategoriesVC animated:YES completion:nil];
}


#pragma mark - ActionSheet
-(void)actionSheetCamera{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self presentViewController:imgPicker animated:YES completion:nil];
    }
    
}
-(void)actionSheetCameraRoll{
    imgPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imgPicker animated:YES completion:nil];
}
-(void)actionSheetLibrary{
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imgPicker animated:YES completion:nil];
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
#pragma mark - PicPickerDelegate
-(void)pickPickerButtondidSelectedIOriginalImage:(UIImage *)image editedImage:(UIImage *)editedImage{
    _imgViewPhoto.image = image;
    _imgViewPhoto.contentMode = UIViewContentModeScaleAspectFill;
    [_btnSelectImage setImage:nil forState:UIControlStateNormal];
}
-(void)pickPickerButtondidCancelled{

}
#pragma mark - UIimagePicker Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imgInfo = info[UIImagePickerControllerOriginalImage];
    _imgViewPhoto.image = imgInfo;
    _imgViewPhoto.contentMode = UIViewContentModeScaleAspectFill;
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_btnSelectImage setImage:nil forState:UIControlStateNormal];
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - MainController Delegates
-(BOOL)mainControllerShouldShowTopbar{
    return YES;
}
-(BOOL)mainControllerShouldShowMenu{
    return YES;
}
-(BOOL)mainControllerShouldShowRightMostButton{
    return YES;
}
-(BOOL)mainControllerShouldShowRightButton{
    return NO;
}

-(BOOL)mainControllerNavigationMenuShouldToggleSidebar{
    return NO;
}
-(id)mainControllerIconForMenu{
    return @"Cancel";
}
-(id)mainControllerIconForRightMostButton{
    return @"Post";
}
-(NSString*)mainControllerTitleForScreen
{
    return @"Post Meet";
}
-(void)mainControllerNavigationMenuButtonDidTappedWithObject:(id)object{
    [self.view endEditing:YES];

//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)mainControllerNavigationRightMostButtonDidTappedWithObject:(id)object{
    [self postPhoto];
}


@end
