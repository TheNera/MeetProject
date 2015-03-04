//
//  AddMeetVC.m
//  WTM
//
//   27/01/15.

//

#import "AddMeetVC.h"
#import "SHKActivityIndicator.h"

#define kKeyName @"title"
#define kKeyLatlong @"location"
#define kKeyTags @"categories"
#define kKeyDescription @"description"
#define kKeyTotalPeople @"people"
#define kKeyTotalPhotos @"photos"
#define kKeyTitle                @"title"
#define kKeyAddress         @"address"
#define kKeyDate                @"startDate"
#define kKeyCoverPage      @"coverImage"
#define kKeyDistance          @"distance"
#define kKeyEndDate   @"endDate"

@interface AddMeetVC (){
    UIActionSheet *actionSheet;
    UIAlertController *alertController;
    UIImagePickerController *imgPicker;
    
}
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtDateTime;
@property (weak, nonatomic) IBOutlet UILabel *lblCategories;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UITextView *txtVwDescription;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *TPScrollView;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIImageView *imgCoverPhoto;
@property (weak, nonatomic) IBOutlet UIView *vwPickerContainer;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *txtEndDate;
@property (weak, nonatomic) IBOutlet UIButton *btnPostOrDone;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation AddMeetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_TPScrollView contentSizeToFit];

    _datePicker.minimumDate = [NSDate date];
    _txtDateTime.inputView = _vwPickerContainer;
    _txtEndDate.inputView = _vwPickerContainer;
    _btnDelete.selected = YES;

    if (_editMeetObject)
    {
        [_btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
        [self setMeetData];

        _lblTitle.text = @"Edit Meet";
        [_btnPostOrDone setTitle:@"Done" forState:UIControlStateNormal];
        
    }else{
        _btnDelete.backgroundColor = [UIColor colorWithRed:71/255.0 green:189/255.0 blue:217/255.0 alpha:1.0];
        [_btnDelete setTitle:@"Post" forState:UIControlStateNormal];
    }
    //    [_TPScrollView setContentSize:CGSizeMake(self.view.frame.size.width, 697)];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    appDel.mainController.navigationDelegate = self;
//    appDel.mainController.topbarDatasource = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setMeetData
{
    _txtTitle.text = _editMeetObject[kKeyTitle];
    _txtDateTime.text = [[AppDelegate dateFormatter] stringFromDate:_editMeetObject[kKeyDate]];
    _txtEndDate.text  = [[AppDelegate dateFormatter]stringFromDate:_editMeetObject[kKeyEndDate]];
    _txtVwDescription.text = _editMeetObject[kKeyDescription];
    _lblCategories.text = _editMeetObject[kKeyTags];
    _lblLocation.text = _editMeetObject[kKeyAddress];
    [_imgCoverPhoto sd_setImageWithURL:[NSURL URLWithString:_editMeetObject[kKeyCoverPage]] placeholderImage:nil];
    _imgCoverPhoto.contentMode = UIViewContentModeScaleAspectFill;
    mutDictLocationInfo = [NSMutableDictionary dictionaryWithObjects:@[_editMeetObject[kKeyAddress],_editMeetObject[kKeyLatlong]] forKeys:@[@"address",@"location"]];
    startDate = _editMeetObject[kKeyDate];
    endDate = _editMeetObject[kKeyEndDate];
    [_btnDelete setTitle:@"Delete Post" forState:UIControlStateSelected ];
    
}
#pragma mark - Actions
- (IBAction)selectLocationAction:(UITapGestureRecognizer *)sender {
    NSMutableDictionary *aSelectedLocation;
    [self presentLocationSelectionScreen:aSelectedLocation];
}

- (IBAction)selectCategoryAction:(UITapGestureRecognizer *)sender
{
    NSMutableArray *aSelectedCategories;
    [self presentSelectCategoriesScreenWithSelectedList:aSelectedCategories];
}

- (IBAction)btnDeleteAction:(id)sender
{
    if(_editMeetObject)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"WTM" message:@"Are you sure? Do you want to delete this meet?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        alert.tag = 100;
        [alert show];
    }
    else
        [self postMeet];
}

- (IBAction)btnPostAction:(UIButton *)sender
{
    
}



- (IBAction)btnCancelPickerAction:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)btnDonePickerAction:(id)sender
{
    if ([_txtDateTime isEditing])
    {
        _txtDateTime.text =[[AppDelegate dateFormatter] stringFromDate: _datePicker.date];
        startDate = _datePicker.date;
    }
    else
    {
        _txtEndDate.text = [[AppDelegate dateFormatter] stringFromDate:_datePicker.date];
        endDate  = _datePicker.date;
    }
    
    [self.view endEditing:YES];
}

#pragma mark - AlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 100 && buttonIndex ==1){
        [[SHKActivityIndicator currentIndicator] displayActivity:@"Deleting..."];
        [_editMeetObject deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self dismissViewControllerAnimated:YES completion:nil];
//            [self.navigationController popToRootViewControllerAnimated:YES];
            [[SHKActivityIndicator currentIndicator]hide];
        }];
    }

}

#pragma mark Parse Methods
-(void)uploadDataOnParse:(NSString*)strImagePath withParseObject:(PFObject*)object
{
    if (strImagePath) {
        object[@"coverImage"] = strImagePath;
    }
    _editMeetObject = object;
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [appDel showAlertwithMessage:_editMeetObject?@"Updated successfully.":@"Posted successfully."];
            if(_delegate && _editMeetObject){
                [_delegate meetDidEditedWithNewData:object];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
//            [self.navigationController popViewControllerAnimated:YES];
        }
        [[SHKActivityIndicator currentIndicator]hide];
    }];
}
#pragma mark Fields validation
-(BOOL)validateFields
{
    if ([_txtTitle.text length]==0) {
        [appDel showAlertwithMessage:@"Please enter Title for Meet"];
        return NO;
    }else if ([_txtDateTime.text length]==0) {
        [appDel showAlertwithMessage:@"Please enter Start Date and Time."];
        return NO;
    }else if ([_lblCategories.text length]==0){
        [appDel showAlertwithMessage:@"Add atleast one category."];
        return NO;
    }
    else if ([_txtVwDescription.text length]==0){
        [appDel showAlertwithMessage:@"Add description for Meet."];
        return NO;
    }
    return YES;
}

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

- (IBAction)selectImageAction:(UITapGestureRecognizer *)sender
{
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

#pragma mark - UIimagePicker Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imgInfo = info[UIImagePickerControllerOriginalImage];
    _imgCoverPhoto.image = imgInfo;
    _imgCoverPhoto.contentMode = UIViewContentModeScaleAspectFill;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Select Location Delegates and Presenting It
-(void)selectLocationDidCancelled{
    // Called When user taps cancel in Location Selection screen.
}
-(void)selectLocationDidFinishedWithLocationInfo:(NSDictionary *)locationInfo{
    if(mutDictLocationInfo){
        [mutDictLocationInfo removeAllObjects];
        mutDictLocationInfo = nil;
    }
    _lblLocation.text = locationInfo[@"address"];
    mutDictLocationInfo = [NSMutableDictionary dictionaryWithDictionary:locationInfo];
    
    locationInfo = nil;
}
-(void)presentLocationSelectionScreen:(NSMutableDictionary*)selectedLocation{
    if(selectLocationVC){
        [selectLocationVC dismissViewControllerAnimated:NO completion:^{
            selectLocationVC = nil;
        }];
    }
    
    selectLocationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MapVC"];
    selectLocationVC.selectedLocation =selectedLocation;
    selectLocationVC.delegate=self;
    [self presentViewController:selectLocationVC animated:YES completion:nil];
}

#pragma mark -  Select Categories Delegates and Presenting It
-(void)selectCategoriesDidCancelled{
    // Called when user taps Cancel in Categories screen
}
-(void)selectCategoriesDidFinishedWithCategories:(NSArray *) arrCategories{
    if (arrCategories.count>0)
    {
        _lblCategories.text = [[arrCategories valueForKey:@"categoryName"] componentsJoinedByString:@","];
    }else{
        _lblCategories.text =@"";
    }
}
-(void)presentSelectCategoriesScreenWithSelectedList:(NSMutableArray*)selectedCategories{
    if(selectCategoriesVC){
        [selectCategoriesVC dismissViewControllerAnimated:NO completion:^{
            selectCategoriesVC = nil;
        }];
    }
    selectCategoriesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectCategoriesVC"];
    selectCategoriesVC.delegate =self;
    selectCategoriesVC.mutArrSelectedCategories = mutArrCategories;
    selectCategoriesVC.strSelectedCategory = _lblCategories.text;
    [self presentViewController:selectCategoriesVC animated:YES completion:nil];
}

- (IBAction)btnCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnPostOrDone:(id)sender {
    [self postMeet];
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
    if (_editMeetObject) {
        return @"Done";
    }
    return @"Post";
}
-(NSString*)mainControllerTitleForScreen
{
    if (_editMeetObject) {
        return @"Edit Meet";
    }
    return @"Create Meet";
}
-(void)mainControllerNavigationMenuButtonDidTappedWithObject:(id)object{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}
-(void)mainControllerNavigationRightMostButtonDidTappedWithObject:(id)object{
    [self postMeet];
}

-(void)postMeet
{
    PFObject *PobjMeet = [PFObject objectWithClassName:@"Meets"];
    
    if (_editMeetObject) {
        PobjMeet = _editMeetObject;
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *nowComponents = [NSDateComponents new];
    if (![self validateFields])
    {
        return;
    }
    if (_editMeetObject) {
        [[SHKActivityIndicator currentIndicator] displayActivity:@"Updating..."];
    }
    else
    {
        [[SHKActivityIndicator currentIndicator] displayActivity:@"Posting..."];
        
    }
    startDate = [appDel convertDateToUTC:startDate];
    PobjMeet [@"title"] = _txtTitle.text;
    PobjMeet[@"description"] = _txtVwDescription.text;
    PobjMeet[@"startDate"] = startDate;
    PobjMeet[@"categories"] = _lblCategories.text;
    
    if (_txtEndDate.text.length > 0)
    {
        endDate = [appDel convertDateToUTC:endDate];
        PobjMeet[@"endDate"] = endDate;
    }
    else
    {
        [calendar setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"]];
        nowComponents.day = 1;
        
        NSDate *nextdate = [calendar dateByAddingComponents:nowComponents
                                                     toDate: startDate
                                                    options:0];
        nextdate =  [calendar dateBySettingHour:0 minute:0 second:0 ofDate:nextdate options:0];
        PobjMeet[@"endDate"] = nextdate;
        
    }
    if (mutDictLocationInfo)
    {
        PobjMeet[@"location"] = mutDictLocationInfo[@"location"];
        PobjMeet[@"address"] = mutDictLocationInfo[@"address"];
    }
    
    nowComponents.day = 1;
    NSDate *nextdate = [calendar dateByAddingComponents:nowComponents
                                                 toDate: startDate
                                                options:0];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Meets"];
    BOOL hasLocationDateChanged = NO;
    if (!_editMeetObject)
    {
        [query whereKey:@"address" equalTo:_lblLocation.text];
        [query whereKey:@"startDate"  greaterThanOrEqualTo:startDate];
        [query whereKey:@"startDate"lessThanOrEqualTo:nextdate];
        hasLocationDateChanged = YES;
    }
    else  if (![_lblLocation.text isEqualToString:_editMeetObject[kKeyAddress]] || ![startDate isEqualToDate:_editMeetObject[kKeyDate]] || ![endDate isEqualToDate:_editMeetObject[kKeyEndDate]])
    {
        [query whereKey:@"address" equalTo:_lblLocation.text];
        [query whereKey:@"startDate"  greaterThanOrEqualTo:startDate];
        [query whereKey:@"startDate"lessThanOrEqualTo:nextdate];
        hasLocationDateChanged = YES;
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!hasLocationDateChanged || objects.count == 0)
        {
            if (_imgCoverPhoto.image) {
                NSData *aDataJpeg = UIImageJPEGRepresentation(_imgCoverPhoto.image, 0.7);
                NSString *aStrFileName = [[self randomStringWithLength:7] stringByAppendingString:@".jpg"];
                
                PFFile *imageFile = [PFFile fileWithName:aStrFileName   data:aDataJpeg];
                if ([PFUser currentUser]) {
                    PobjMeet[@"user"] = [PFUser currentUser];
                    PobjMeet[@"userId"] = [PFUser currentUser].objectId;
                }
                [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [self uploadDataOnParse:imageFile.url withParseObject:PobjMeet];
                }];
            }
            else
                [self uploadDataOnParse:nil withParseObject:PobjMeet];
        }
        else{
            [appDel showAlertwithMessage:@"There is already a meet added to this location"];
            [[SHKActivityIndicator currentIndicator]hide];
        }
    }];
    
   
}


@end
