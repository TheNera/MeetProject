//
//  ViewController.m
//  WTM
//
//  Created by Prashant Bhayani on 20/01/15.
//  Copyright (c) 2015 Prashant. All rights reserved.
//

#import "ViewController.h"
#import "AddMeetVC.h"
#import "Utility.h"
#import "PostPhotoVC.h"
#import "ColorButton.h"
#define kButtonTitleDetail        @"Detail"
#define kButtonTitleGoing       @"I'm Going"
#define kButtonTitleShare        @"Share"
#define kButtonTitleUnattend  @"Un-attend"

@interface ViewController ()
{
    NSMutableArray *mutArrMeetsDatasource;
    BOOL shouldConsiderNow;
    BOOL shouldShowActivity;
    CGRect rectInitSaveFilter,rectInitFilterButton,rectInitFilterContainer,rectInitFilters;
}
@property (weak, nonatomic) IBOutlet UIButton *btnFilter;
@property (weak, nonatomic) IBOutlet UIView *viewFilter;
@property (weak, nonatomic) IBOutlet UIView *viewFilterContainer;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnSignup;
@property (weak, nonatomic) IBOutlet UITableView *tblMeetList;
@property (weak, nonatomic) IBOutlet UIView *viewNoMeet;
@property (weak, nonatomic) IBOutlet ColorButton *btnSave;
@property (weak, nonatomic) IBOutlet UISlider *sliderRadius;
@property (weak, nonatomic) IBOutlet UILabel *lblMaxRadius;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectedCategories;
@property (weak, nonatomic) IBOutlet UITextField *txtFilterDate;
@property (strong, nonatomic) IBOutlet UIView *viewDatePickerContainer;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loginStateChangeHandler:nil];
    
    if (_isSelectMeet) {
        
        UIButton  *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
        [backButton setFrame:CGRectMake(0, 0, 40, 40)];
        [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [backButton setExclusiveTouch:YES];
        [backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
        
        UIBarButtonItem *btnLogClear = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        _viewFilter.hidden = NO;
        self.navigationItem.leftBarButtonItem = btnLogClear;
        self.title =  @"Select a Meet";
        _tblMeetList.contentInset = UIEdgeInsetsMake(104, 0, 0, 0);
    }
    
    shouldShowActivity = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginStateChangeHandler:) name:@"loginStateChange" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(serviceAPICall) name:@"locationUpdated" object:nil];
    
    _tblMeetList.delegate=self;
    _tblMeetList.dataSource=self;
    [self.view bringSubviewToFront:_btnLogin];
    [self.view bringSubviewToFront:_btnSignup];
    mutArrMeetsDatasource = [NSMutableArray array];
    _txtFilterDate.inputView =_viewDatePickerContainer;
    // Do any additional setup after loading the view, typically from a nib.
    rectInitFilterButton = _btnFilter.frame;
    rectInitFilterContainer= _viewFilterContainer.frame;
    rectInitFilters= _viewFilter.frame;
    rectInitSaveFilter = _btnSave.frame;
    _btnSave.layer.cornerRadius = _btnSave.frame.size.height*0.5;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    appDel.mainController.topbarDatasource =  self;
    appDel.mainController.navigationDelegate = self;
    //    [self performSelector:@selector(serviceAPICall) withObject:nil afterDelay:5];
    if (!isFilterOpen)
    {
        [self closeFilterView:NO];
        [self serviceAPICall];
    }
    
    if([appDel dictPayloadMeetInfo]){
        [self openMeetDetailWithId:appDel.dictPayloadMeetInfo[@"meetId"]];
        appDel.dictPayloadMeetInfo =nil;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - Create Meet
- (IBAction)btnCreateAction:(id)sender {
    AddMeetVC *addMeetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddMeetVC"];
    [self presentViewController:addMeetVC animated:YES completion:nil];
}
#pragma mark - Parse Methods
-(void)serviceAPICall
{
    if(shouldShowActivity){
        [[SHKActivityIndicator currentIndicator] displayActivity:@"Loading..."];
        shouldShowActivity = NO;
    }
    
    switch (_meetListType) {
        case kMeetsFindMeets:
            [self getAllMeetsWith:nil radius:NSNotFound categories:nil];
            break;
        case kMeetsMyMeets:
            [self getMyMeets];
            break;
        case kMeetsIAmAttending:
            [self getMeetIamAttending];
        case kMeetAllMeets:
            [self getAllMeetsWith:nil radius:NSNotFound categories:nil];
            break;
        default:
            break;
    }
}

-(void)getMyMeets{
    PFGeoPoint *geoPoint  = [PFGeoPoint geoPointWithLocation: appDel.myLocation];
    NSMutableDictionary *aDict = [NSMutableDictionary dictionary] ;
    if(geoPoint)
    {
        [aDict setObject:geoPoint forKey:@"location"];
    }
    if ([PFUser currentUser]) {
        [aDict setObject:[PFUser currentUser].objectId forKey:@"userId"];
    }
    [PFCloud  callFunctionInBackground:@"getMeetsOfUser" withParameters:aDict block:^(id object, NSError *error) {
        if(error){
            return;
        }
        shouldConsiderNow = YES;
        if([object[@"result"] count]>0){
            [mutArrMeetsDatasource removeAllObjects];
            [self generateSortedDatasource: [object objectForKey:@"result"]];
            [_tblMeetList reloadData];
        }
        [[SHKActivityIndicator currentIndicator]hide];
    }];
}

-(void)generateSortedDatasource:(NSMutableArray*)array{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:NO];
    NSSortDescriptor *sortDescriptorTwo = [NSSortDescriptor sortDescriptorWithKey:@"Distance" ascending:YES];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:@[sortDescriptor,sortDescriptorTwo]];
    [mutArrMeetsDatasource removeAllObjects];
    mutArrMeetsDatasource = nil;
    mutArrMeetsDatasource = [NSMutableArray arrayWithArray:sortedArray];
    sortedArray = nil;
    array = nil;
}

-(void)getAllMeetsWith:(NSDate*)date radius:(NSInteger)intRadius categories:(NSArray*)arrCategories
{
    NSMutableDictionary *aDict = [NSMutableDictionary dictionary] ;
    if(mutDictLocationInfo[@"location"])
    {
        [aDict setObject:mutDictLocationInfo[@"location"] forKey:@"location"];
    }
    else
    {
        [aDict setObject:[PFGeoPoint geoPointWithLocation: appDel.myLocation] forKey:@"location"];
    }
    if ([PFUser currentUser] && _meetListType!=kMeetAllMeets)
    {
        [aDict setObject:[PFUser currentUser].objectId forKey:@"userId"];
    }
    
    [aDict setObject:[NSNumber numberWithInteger:intRadius==NSNotFound?250:intRadius] forKey:@"filterRadius"];
    if(date)
        [aDict setObject:[appDel convertDateToUTC:date] forKey:@"filterDate"];
    NSLog(@"%@",aDict);
    
    [PFCloud  callFunctionInBackground:@"getAllMeetsForUser" withParameters:aDict block:^(id object, NSError *error) {
        if(error){
            return;
        }
        [mutArrMeetsDatasource removeAllObjects];
        if([object[@"result"] count]>0)
        {

            NSMutableArray *aMutArrFilterMeets = [self filterMeetsByCategories:object[@"result"]];
            [self generateSortedDatasource:aMutArrFilterMeets];

        }
        [_tblMeetList reloadData];
        [[SHKActivityIndicator currentIndicator]hide];
    }];
}
-(NSMutableArray *)filterMeetsByCategories:(id)objects
{
    NSMutableArray *aMutArrCategory = [NSMutableArray array];
    if (selectedCategory.count ==0) {
        return  objects;
    }
    for (NSString *aStrCategory in selectedCategory) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([evaluatedObject[@"Object"][@"categories"] rangeOfString:aStrCategory].location == NSNotFound){
                return NO;
            }
            else
                return YES;
        }];
        NSArray *arrMeet =[objects filteredArrayUsingPredicate:predicate];
        if (arrMeet.count>0) {
            
            [aMutArrCategory addObjectsFromArray:arrMeet];
        }
        
    }
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:aMutArrCategory];
    NSSet *uniqueStates = [orderedSet set];
    [aMutArrCategory removeAllObjects];
    [aMutArrCategory addObjectsFromArray:[uniqueStates allObjects]];
    return aMutArrCategory;
}
-(void)getMeetIamAttending
{
    PFGeoPoint *geoPoint  = [PFGeoPoint geoPointWithLocation: appDel.myLocation];
    NSDictionary *aDict = [NSDictionary dictionaryWithObjectsAndKeys:[PFUser currentUser].objectId,@"userId",geoPoint,@"location",nil];
    
    [PFCloud  callFunctionInBackground:@"getUserAttendingMeets" withParameters:aDict block:^(id object, NSError *error) {
        if(error){
            return;
        }
        if([object isKindOfClass:[NSDictionary class]] && [object objectForKey:@"result"]){
            [mutArrMeetsDatasource removeAllObjects];
            [self generateSortedDatasource: [object objectForKey:@"result"]];
            [_tblMeetList reloadData];
        }
        [[SHKActivityIndicator currentIndicator]hide];
    }];
    
}

-(void)getMeetAttendingListFromParse:(NSPredicate *)predicate
{
    PFQuery *query = [ PFQuery queryWithClassName:@"Meets" predicate:predicate];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [mutArrMeetsDatasource removeAllObjects];
        [ mutArrMeetsDatasource addObjectsFromArray: objects];
        [_tblMeetList reloadData];
        
    } ];
    
}

#pragma mark - TableView Delegates and Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(shouldConsiderNow && _meetListType==kMeetsMyMeets && mutArrMeetsDatasource.count==0){
        _viewNoMeet.hidden =NO;
        _tblMeetList.hidden = YES;
    }else{
        _viewNoMeet.hidden = YES;
        _tblMeetList.hidden = NO;
    }
    return mutArrMeetsDatasource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MeetTableViewCell *meetCell =[tableView dequeueReusableCellWithIdentifier:@"MeetCell"];
    NSDictionary *aDict = [mutArrMeetsDatasource objectAtIndex:indexPath.row];
    
    meetCell.meetInfo = [aDict objectForKey:@"Object"];
    meetCell.distance = [[aDict objectForKey:@"Distance"] doubleValue];
    meetCell.delegate = self;
    return meetCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isFilterOpen = NO;
    NSDictionary *aDict =  [mutArrMeetsDatasource objectAtIndex:indexPath.row];
    if (_isSelectMeet)
    {
        [_delegate getSelectedMeet: aDict[@"Object"]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {

        [self openMeetDetail:aDict];
//        
//        PFObject *aObject = aDict[@"Object"];
//        [self openMeetDetailWithId:aObject.objectId];
    }
}

-(void)openMeetDetail:(NSDictionary*)aDict{
    if(!aDict){
        return;
    }
    MeetDetailVC *objMeetDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MeetDetailVC"];
    objMeetDetailVC.meetObject = aDict[@"Object"];
    objMeetDetailVC.distance =[aDict[@"Distance"] floatValue];
    objMeetDetailVC.strAttendeeId = aDict[@"attendeeId"];
    objMeetDetailVC.isAttending = [aDict[@"isAttending"] boolValue];
    [self.navigationController pushViewController:objMeetDetailVC animated:YES];
}
-(void)openMeetDetailWithId:(NSString*)strId{
    MeetDetailVC *objMeetDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MeetDetailVC"];
    objMeetDetailVC.strMeetId = strId;
    [self.navigationController pushViewController:objMeetDetailVC animated:YES];
}
#pragma mark SwipeableCell methods
-(NSArray*) swipeTableCell:(MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*) swipeSettings expansionSettings:(MGSwipeExpansionSettings*) expansionSettings
{
    if (_isSelectMeet) {
        return nil;
    }
    cell.leftSwipeSettings.transition = MGSwipeTransitionClipCenter;
    cell.rightSwipeSettings.transition = MGSwipeTransitionClipCenter;
    if (direction == MGSwipeDirectionLeftToRight)
    {
        
        if (![self checkUserAttendanceInMeet:cell])
        {
            return [self createLeftButtons:0 forCell:cell];
        }
        else
        {
            return    [self createLeftButtons:1 forCell:cell];
        }
    }
    else
    {
        return     [self createRightButtons:1];
    }
    return nil;
}
-(NSArray *) createLeftButtons: (int) number  forCell:(MGSwipeTableCell*)cell
{
    NSMutableArray * result = [NSMutableArray array];
    UIColor * colors[1] = {  [UIColor colorWithRed:47.0/255.0 green:159.0/255.0 blue:177.0/255.0 alpha:1.0]};
    UIImage * icons[1] = {[UIImage imageNamed:@"footer_im_going_icon.png"]};
    NSString *aStrTitle ;
    
    
    if( [PFUser currentUser] && [self isMeetCompletedForCell:cell]){
        aStrTitle = kButtonTitleDetail;
    }else{
        switch (_meetListType) {
            case kMeetsFindMeets:
            {
                if (number == 1)
                {
                    aStrTitle = kButtonTitleUnattend;
                }
                else
                {
                    aStrTitle = kButtonTitleGoing;
                }
                
                break;
            }
            case kMeetsIAmAttending:{
                if (number == 1)
                {
                    aStrTitle = kButtonTitleUnattend;
                }
                else
                {
                    aStrTitle = kButtonTitleGoing;
                }
                break;
            }
            case kMeetsMyMeets:{
                aStrTitle = kButtonTitleDetail;
                break;
            }
            default:
                break;
        }
    }
    MGSwipeButton * button = [MGSwipeButton buttonWithTitle:aStrTitle icon:icons[0] backgroundColor:colors[0] padding:5.0 callback:^BOOL(MGSwipeTableCell * sender){
        NSLog(@"Convenience callback received (left).");
        return YES;
    }];
    [result addObject:button];
    return result;
}


-(NSArray *) createRightButtons: (int) number
{
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[1] = {kButtonTitleShare};
    UIImage * icons[1] = {[UIImage imageNamed:@"footer_share_icon.png"]};
    UIColor * colors[1] = {[UIColor colorWithRed:62/255.0 green:64.0/255.0 blue:80.0/255.0 alpha:1.0]};
    for (int i = 0; i < number; ++i)
    {
        
        
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] icon:icons[0] backgroundColor:colors[0] padding:15 callback:^BOOL(MGSwipeTableCell * sender){
            NSLog(@"Convenience callback received (right).");
            return YES;
        }];
        
        [result addObject:button];
    }
    return result;
}

-(void)swipeTableCell:(MGSwipeTableCell *)cell didChangeSwipeState:(MGSwipeState)state gestureIsActive:(BOOL)gestureIsActive
{
    
}


-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion
{
    if (![self checkUserLogin]) {
        return NO;
    }
    NSIndexPath *aIndexPath = [_tblMeetList indexPathForCell:cell];
    NSMutableDictionary *aDictMeetInfo = [mutArrMeetsDatasource objectAtIndex:aIndexPath.row];
    
    //I am going/ Unattend
    if (direction == MGSwipeDirectionLeftToRight)
    {
        
        if(_meetListType==kMeetsMyMeets || [self isMeetCompletedForCell:cell]){
            MeetDetailVC *objMeetDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MeetDetailVC"];
            NSDictionary *aDict =  [mutArrMeetsDatasource objectAtIndex:aIndexPath.row];
            objMeetDetailVC.meetObject = aDict[@"Object"];
            objMeetDetailVC.distance =[aDict[@"Distance"] floatValue];
            objMeetDetailVC.strAttendeeId = aDict[@"attendeeId"];
            objMeetDetailVC.isAttending = [aDict[@"isAttending"] boolValue];
            [self.navigationController pushViewController:objMeetDetailVC animated:YES];
            return YES;
        }
        __block BOOL isAttending = [aDictMeetInfo[@"isAttending"] boolValue];
        if(isAttending){
            [aDictMeetInfo setObject:[NSNumber numberWithBool:NO] forKey:@"isAttending"];
        }else{
            [aDictMeetInfo setObject:[NSNumber numberWithBool:YES] forKey:@"isAttending"];
        }
        
        [[Utility sharedInstance] setAttendingStatus:!isAttending forMeet:aDictMeetInfo[@"Object"] attendeeId:aDictMeetInfo[@"attendeeId"] completion:^(NSString * strObjectId){
            NSLog(@"Attendee Id - %@",strObjectId);
            //            _strAttendeeId =strObjectId;
            isAttending = !isAttending;
            
            if(isAttending){
                overlay =  [IMGoingOverlay showOverlayForMeet:aDictMeetInfo[@"Object"] withRefVC:self];
            }
        }];
        MGSwipeButton *aButton = [cell.leftButtons objectAtIndex:index];
        [aButton setTitle:isAttending?kButtonTitleGoing:kButtonTitleUnattend forState:UIControlStateNormal];
        
        
    }
    else
    {//Share
        [[Utility sharedInstance]shareMeet:aDictMeetInfo[@"Object"] viewController:self];
    }
    return YES;
}
-(BOOL)isMeetCompletedForCell:(UITableViewCell*)cell
{
    NSIndexPath *aIndexPath = [_tblMeetList indexPathForCell:cell];
    PFObject *aObject = [[mutArrMeetsDatasource objectAtIndex:aIndexPath.row] objectForKey:@"Object"];
    NSDate *aEndDate = [aObject objectForKey:@"endDate"];
    if([[Utility sharedInstance]isDate:aEndDate InPastToDate:[NSDate date]]){
        return YES;
    }
    return NO;
}

-(BOOL)checkUserAttendanceInMeet:(MGSwipeTableCell*)cell
{
    NSIndexPath *index =[_tblMeetList indexPathForCell:cell];
    NSDictionary *aDictMeetInfo = [mutArrMeetsDatasource objectAtIndex:index.row];
    return [aDictMeetInfo[@"isAttending"] boolValue];
}
-(void)loginStateChangeHandler:(NSNotification*)notification{
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"isLoggedIn"]){
        _btnLogin.hidden=YES;
        _btnSignup.hidden = YES;
        _tblMeetList.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }else{
        _btnLogin.hidden=NO;
        _btnSignup.hidden = NO;
        _tblMeetList.contentInset = UIEdgeInsetsMake(64, 0, 50, 0);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)checkUserLogin
{
    if ([PFUser currentUser]) {
        return YES;
    }
    else
    {
        overlayLogin = [IMLoginOverlay showOverlayForMeet:nil withRefVC:self];
        return NO;
    }
}

#pragma mark - Main Controller Delegate and Datasource

-(BOOL)mainControllerShouldShowMenu{
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"isLoggedIn"];
}
-(BOOL)mainControllerShouldShowRightButton{
    if (![PFUser currentUser])
    {
        return NO;
    }
    return YES;
}
-(BOOL)mainControllerShouldShowRightMostButton{
    if (![PFUser currentUser])
    {
        return NO;
    }
    return YES;
}

-(BOOL)mainControllerShouldShowTopbar{
    return YES;
}

//-(id)mainControllerIconForMenu{
//    return [UIImage imageNamed:@"menu_icon.png"];
//}
-(id)mainControllerIconForRightButton{
    return [UIImage imageNamed:@"calender.png"];
}
-(id)mainControllerIconForRightMostButton{
    return [UIImage imageNamed:@"camera.png"];
}

-(NSString*)mainControllerTitleForScreen{
    switch (_meetListType) {
        case kMeetsFindMeets:
        {
            _viewFilter.hidden = NO;
            _tblMeetList.contentInset = UIEdgeInsetsMake(104, 0, 0, 0);
            return @"FIND MEETS";
            break;
        }
        case kMeetsMyMeets:
            return @"MY MEETS";
            break;
        case kMeetsIAmAttending:
            return @"I'M ATTENDING";
            break;
        default:
            break;
    }
    return @"";
}
-(void)mainControllerNavigationRightMostButtonDidTappedWithObject:(id)object{
    isFilterOpen = NO;

    PostPhotoVC *postPhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PostPhotoVC"];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:postPhotoVC];
    [self presentViewController:navController animated:YES completion:nil];
    
}
-(void)mainControllerNavigationRightButtonDidTappedWithObject:(id)object{
    isFilterOpen = NO;

    AddMeetVC *addMeetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddMeetVC"];
    [self presentViewController:addMeetVC animated:YES completion:nil];
    
}

-(void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark ------
#pragma mark - Filter Section
#pragma mark ------
- (IBAction)btnFilterAction:(id)sender {
    [self openFilterView:YES];
}
- (IBAction)btnSaveAction:(id)sender {
    [self closeFilterView:YES];
    [self getAllMeetsWith:selectedDate radius:_sliderRadius.value categories:selectedCategory];
}
- (IBAction)sliderDidChangeAction:(UISlider*)sender {
    _lblMaxRadius.text = [NSString stringWithFormat:@"%d mi",(int)sender.value];
}
#define kDurationTransition 0.4
-(void)closeFilterView:(BOOL)shouldAnimate{
    _btnFilter.hidden = NO;
    [UIView animateWithDuration:shouldAnimate?kDurationTransition:0.0 animations:^{
        _btnFilter.alpha = 1.0;
        _btnSave.alpha = 0.0;
        
        CGRect rectCloseFilterBtn = rectInitFilterButton;
        rectCloseFilterBtn.origin.y = 0;
        
        CGRect rectCloseFilterContainer = rectInitFilterContainer;
        rectCloseFilterContainer.origin.y =  -(rectCloseFilterContainer.size.height-rectCloseFilterBtn.size.height);
        
        CGRect rectClosefilter = rectInitFilters;
        rectClosefilter.size.height=rectCloseFilterBtn.size.height;
        
        
        _viewFilter.backgroundColor = [UIColor clearColor];
        _viewFilterContainer.frame = rectCloseFilterContainer;
        _btnFilter.frame = rectCloseFilterBtn;
        
    } completion:^(BOOL finished) {
        CGRect rectClosefilter = rectInitFilters;
        rectClosefilter.size.height=_btnFilter.frame.size.height;
        _btnSave.hidden = YES;
        _viewFilter.frame = rectClosefilter;
    }];
}
-(void)openFilterView:(BOOL)shouldAnimate{
    isFilterOpen= YES;
    _btnSave.hidden = NO;
    _viewFilter.frame =rectInitFilters;
    [UIView animateWithDuration:kDurationTransition animations:^{
        _btnFilter.alpha = 0.0;
        _btnSave.alpha = 1.0;
        _viewFilter.backgroundColor = [UIColor colorWithRed:35/255.0 green:40/255.0 blue:48/255.0 alpha:0.8];
        NSLog(@"Button : %@, Container : %@",NSStringFromCGRect(rectInitFilterButton),NSStringFromCGRect(rectInitFilterContainer));
        _viewFilterContainer.frame = rectInitFilterContainer;
        _btnFilter.frame = rectInitFilterButton;
        
    } completion:^(BOOL finished) {
        _btnFilter.hidden = YES;
    }];
}
- (IBAction)tapToOpenCategories:(id)sender {
    [self presentSelectCategoriesScreen];
}
#pragma mark -  Select Categories Delegates and Presenting It
-(void)selectCategoriesDidCancelled{
    // Called when user taps Cancel in Categories screen
}
-(void)selectCategoriesDidFinishedWithCategories:(NSArray *) arrCategories{
    if (arrCategories.count>0)
    {
        selectedCategory = [arrCategories valueForKey:@"categoryName"];
        _lblSelectedCategories.text = [[arrCategories valueForKey:@"categoryName"] componentsJoinedByString:@","];
    }else{
        selectedCategory = nil;
        _lblSelectedCategories.text =@"";
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
    selectCategoriesVC.strSelectedCategory = _lblSelectedCategories.text;
    [self presentViewController:selectCategoriesVC animated:YES completion:nil];
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
    _lblFilterLocation.text = locationInfo[@"address"];
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
- (IBAction)tapToSelectLocation:(id)sender {
    [self presentLocationSelectionScreen:mutDictLocationInfo];
    
    
}
- (IBAction)btnCancel:(id)sender {
    [self.view endEditing:YES];
    
}
- (IBAction)btnDoneClicked:(id)sender {
    selectedDate = _datePicker.date;
    _txtFilterDate.text =[[AppDelegate dateFormatter] stringFromDate: _datePicker.date];
    [self.view endEditing:YES];
    
}


@end
