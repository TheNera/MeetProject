//
//  MeetDetailVCViewController.m
//  WTM
//
//   04/02/15.
//
//
#import <MapKit/MapKit.h>
#import "MeetDetailVC.h"
#import "AddressCell.h"
#import "DateDistanceCell.h"
#import "TagsDescriptionCell.h"
#import "PeopleCell.h"
#import "PhotostreamCell.h"
#import "Utility.h"
#import "IMGoingOverlay.h"
#import "IMLoginOverlay.h"
#import "UIImageView+WebCache.h"

#define kCellIdCover @"CoverPageCell"
#define kCellIdAddress @"AddressCell"
#define kCellIdDate @"DateAndDistanceCell"
#define kCellIdPhotos @"PhotostreamCell"
#define kCellIdPeople @"PeopleCell"
#define kCellIdTags @"TagAndDescriptionCell"

#define kIndexCover        0
#define kIndexAddress    1
#define kIndexDate          2
#define kIndexTags          3
#define kIndexPeople      4
#define kIndexPhotos      5


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


@interface MeetDetailVC () <MainControllerNavigationDelegate,MainControllerTopbarDatasource>
{
    IMGoingOverlay *overLay;
    IMLoginOverlay *loginOverlay;
}
@end



@implementation MeetDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tblDetails.delegate=self;
    _tblDetails.dataSource=self;
    
    if(_meetObject){
        [_tblDetails reloadData];
        [self showBottomButtons];
    }else{
        NSLog(@"Meet Detail Called...");
        NSMutableDictionary *aMutDictParam = [NSMutableDictionary dictionary];
        [aMutDictParam setObject:[PFUser currentUser].objectId forKey:@"userId"];
        [aMutDictParam setObject:_strMeetId forKey:@"meetId"];
        [aMutDictParam setObject:[PFGeoPoint geoPointWithLocation:appDel.myLocation] forKey:@"userLocation"];
        
        [PFCloud callFunctionInBackground:@"getMeetDetail" withParameters:aMutDictParam block:^(id object, NSError *error) {
            _meetObject = object[@"Object"] ;
            _distance = [object[@"Distance"] doubleValue];
            _strAttendeeId = object[@"attendeeId"];
            _isAttending = [object[@"isAttending"] boolValue];
            [_tblDetails reloadData];
            [self showBottomButtons];
            [self getAttendeesAPI];
            [self getPhotostreamAPI];
        }];
    }
}


-(void)showBottomButtons{
    
    //Based on User Logged in and Creator of Meet
    if([[ PFUser currentUser].objectId isEqualToString:_meetObject[@"userId"]]){
        //Meet is Created by logged In user.
        [_btnGoing setTitle:@"Delete Meet" forState:UIControlStateNormal];
        _btnEdit.hidden = NO;
    }else{
        //Meet is Not created by Logged in user.
        _btnEdit.hidden = YES;
        CGRect rectShare = _btnShare.frame;
        rectShare.origin.x = self.view.frame.size.width*0.5;
        rectShare.size.width = self.view.frame.size.width*0.5;
        _btnShare.frame = rectShare;
        
        CGRect rectGoing = _btnGoing.frame;
        rectGoing.size.width = self.view.frame.size.width*0.5;
        _btnGoing.frame =rectGoing;
    }
    
    // Based on isAttending Flag
    if(_isAttending){
        [_btnGoing setTitle:@"Un-Attend" forState:UIControlStateNormal];
    }else
    {
        [_btnGoing setTitle:@"I'm Going" forState:UIControlStateNormal];
    }
    if([[ PFUser currentUser].objectId isEqualToString:_meetObject[@"userId"]]){
        //Meet is Created by logged In user.
        [_btnGoing setImage:nil forState:UIControlStateNormal];
        [_btnGoing setTitle:@"Delete" forState:UIControlStateNormal];
    }
    _viewBtnPanel.hidden =NO;
    NSDate *aEndDate = [_meetObject objectForKey:@"endDate"];
    if([[Utility sharedInstance]isDate:aEndDate InPastToDate:[NSDate date]]){
        _viewBtnPanel.hidden = YES;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    appDel.mainController.navigationDelegate =self;
    appDel.mainController.topbarDatasource =self;
    if(_meetObject){
        [self getAttendeesAPI];
        [self getPhotostreamAPI];
    }
}

-(void)getAttendeesAPI{
    NSLog(@"Attendees for: %@",_meetObject.objectId);
    [[Utility sharedInstance]getAttendeesForMeetId:_meetObject.objectId userId:[PFUser currentUser].objectId completion:^(id object) {
        if(object && [object isKindOfClass:[NSArray class]]){
            _mutArrPeople = [NSMutableArray arrayWithArray:object];
            [self setPeoples:_mutArrPeople];
        }
    }];
}

-(void)getPhotostreamAPI{
    NSLog(@"Photostream for: %@",_meetObject.objectId);
    [[Utility sharedInstance]getGallaryForMeetId:_meetObject.objectId userId:nil completion:^(id objects)  {
        [self setPhotostreamDatasource:objects];
    }];
    
    
}
#pragma mark - Actions
- (IBAction)btnImGoingAction:(UIButton*)sender {
    if ([sender.titleLabel.text isEqualToString:@"Delete"])
    {
        [_meetObject deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [appDel showAlertwithMessage:@"Meet Deleted Successfully"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
    }
    else
    {
        if(![PFUser currentUser]){
            loginOverlay = [IMLoginOverlay showOverlayForMeet:nil withRefVC:self];
            return;
        }
        [[Utility sharedInstance]setAttendingStatus:!_isAttending forMeet:_meetObject attendeeId:_strAttendeeId completion:^(NSString * strObjectId){
            NSLog(@"Attendee Id - %@",strObjectId);
            _strAttendeeId =strObjectId;
            _isAttending = !_isAttending;
            [self showBottomButtons];
            if(_isAttending){
                overLay =  [IMGoingOverlay showOverlayForMeet:_meetObject withRefVC:self];
            }
        }];
    }
}
- (IBAction)btnShareAction:(UIButton*)sender {
    
    [[Utility sharedInstance]shareMeet:_meetObject viewController:self];
}
- (IBAction)btnEditAction:(id)sender
{
    AddMeetVC *addMeetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddMeetVC"];
    addMeetVC.editMeetObject = _meetObject;
    addMeetVC.delegate = self;
    
    [self presentViewController:addMeetVC animated:YES completion:nil];
//    [self.navigationController pushViewController:addMeetVC animated:YES];
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void)meetDidEditedWithNewData:(PFObject *)object{
    _meetObject =  object;
    PFGeoPoint *point = object[@"location"];
    NSInteger intDistance = [appDel getDistanceBetween:appDel.myLocation.coordinate andFromLocation:CLLocationCoordinate2DMake(point.latitude, point.longitude)];
    _distance = intDistance*0.000621371;
    [_tblDetails reloadData];
    [self showBottomButtons];
}
-(IBAction)locateTheMeet:(id)sender{
    
    NSURL *aUrl = [NSURL URLWithString:@"comgooglemaps://"];
    PFGeoPoint *aPnt = [_meetObject objectForKey:@"location"];
    if([[UIApplication sharedApplication] canOpenURL:aUrl]){
        
        NSString *aStr = [NSString stringWithFormat:@"comgooglemaps://?saddr=%f,%f&daddr=%f,%f&directionsmode=transit",appDel.myLocation.coordinate.latitude,appDel.myLocation.coordinate.longitude,aPnt.latitude,aPnt.longitude];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:aStr]];
    }else{
        
        CLLocationCoordinate2D aLocation =   CLLocationCoordinate2DMake(aPnt.latitude, aPnt.longitude);
        MKPlacemark* place = [[MKPlacemark alloc] initWithCoordinate:aLocation  addressDictionary: nil];
        MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark: place];
        destination.name = _meetObject[@"title"];
        NSArray* items = [[NSArray alloc] initWithObjects: destination, nil];
        NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 MKLaunchOptionsDirectionsModeDriving,
                                 MKLaunchOptionsDirectionsModeKey, nil];
        [MKMapItem openMapsWithItems: items launchOptions: options];
        
    }
}
#pragma mark - TableView Delegate and Datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_meetObject){
        return 6;
    }else{
        return 0;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *aCell;
    switch (indexPath.row) {
        case kIndexCover:{
            aCell = [tableView dequeueReusableCellWithIdentifier:kCellIdCover];
            
            UIImageView *aCoverImage =(UIImageView*) [aCell viewWithTag:100];
            imgViewCover = aCoverImage;
            CGRect rectCoverImage = CGRectMake(0, 0, aCell.frame.size.width, 252.0);
            aCoverImage.frame =rectCoverImage;
            aCoverImage.backgroundColor = [UIColor whiteColor];
            NSString *aStrCoverPath = _meetObject[kKeyCoverPage];
            [aCoverImage sd_setImageWithURL:[NSURL URLWithString:aStrCoverPath] placeholderImage:[UIImage imageNamed:@"coverPlaceholder.png"]];
            break;
        }
        case kIndexAddress:{
            AddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:kCellIdAddress];
            PFGeoPoint *pntOfLocation = _meetObject[kKeyLatlong];
            [addressCell setTitle:_meetObject[kKeyTitle] place:_meetObject[kKeyAddress] location:CLLocationCoordinate2DMake(pntOfLocation.latitude, pntOfLocation.longitude)];
            aCell =addressCell;
            break;
        }
        case kIndexDate:{
            DateDistanceCell *dateDistanceCell = [tableView dequeueReusableCellWithIdentifier:kCellIdDate];
            PFGeoPoint *pntOfLocation = _meetObject[kKeyLatlong];
            
            dateDistanceCell.startDate = _meetObject[kKeyDate];
            dateDistanceCell.location = CLLocationCoordinate2DMake(pntOfLocation.latitude, pntOfLocation.longitude);
            aCell = dateDistanceCell;
            break;
        }
        case kIndexTags:{
            TagsDescriptionCell *tagsCell = [tableView dequeueReusableCellWithIdentifier:kCellIdTags];
            [tagsCell setTags:_meetObject[kKeyTags] andDescription:_meetObject[kKeyDescription]];
            aCell =tagsCell;
            break;
        }
        case kIndexPhotos:{
            PhotostreamCell*photosCell = [tableView dequeueReusableCellWithIdentifier:kCellIdPhotos];
            photosCell.mutArrPhotos = _mutPhotostream;
            aCell = photosCell;
            break;
        }
        case kIndexPeople:{
            PeopleCell *peopleCell = [tableView dequeueReusableCellWithIdentifier:kCellIdPeople];
            peopleCell.mutArrPeople = _mutArrPeople;
            aCell = peopleCell;
            break;
        }
        default:
            break;
    }
    
    return aCell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case kIndexCover:{
            return 252.0;
            break;
        }
        case kIndexAddress:{
            return 87.0;
            break;
        }
        case kIndexDate:{
            return 85.0;
            break;
        }
        case kIndexTags:{
            
            NSString *aStrTag = _meetObject[kKeyTags];
            NSString *aStrDescription = _meetObject[kKeyDescription];
            
            CGRect rectTags = [aStrTag boundingRectWithSize:CGSizeMake(286.0, 9999) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:kTagsFontName size:kTagsFontSize]} context:nil];
            
            CGRect rectDescription = [aStrDescription boundingRectWithSize:CGSizeMake(286.0, 9999) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:kDescriptionFontName size:kDescriptionFontSize]} context:nil];
            return rectTags.size.height + rectDescription.size.height + 44.0;
            break;
        }
        case kIndexPhotos:{
            float flRow = _mutPhotostream.count/4.0;
            NSInteger noOfRow = ceil(flRow);
            return 55+(noOfRow*70);
            break;
        }
        case kIndexPeople:{
            return 88.0;
            break;
        }
        default:
            return 44.0;
            break;
    }
}

#pragma mark - Scroll View
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float yOffset =scrollView.contentOffset.y;
    if(yOffset<0){
        imgViewCover.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, yOffset);
        imgViewCover.transform = CGAffineTransformScale(imgViewCover.transform, 1+(-1)*(yOffset/125.0), 1+(-1)*(yOffset/125.0));
    }
    else
        imgViewCover.transform = CGAffineTransformIdentity;
}
#pragma mark - Settter
-(void)setPeoples:(NSMutableArray*)mutArrPeoples{
    PeopleCell *aCell =(PeopleCell*) [_tblDetails cellForRowAtIndexPath:[NSIndexPath indexPathForItem:(long)kIndexPeople inSection:0]];
    aCell.mutArrPeople = mutArrPeoples;
    //    [_tblDetails reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:(long)kCellIdPeople inSection:0] ] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)setPhotostreamDatasource:(NSMutableArray*)mutArrPhotos{
    _mutPhotostream = mutArrPhotos;
    PhotostreamCell *aCell = (PhotostreamCell*)[_tblDetails cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(long)kIndexPhotos inSection:0]];
    aCell.mutArrPhotos = mutArrPhotos;
}

#pragma mark - Main Controller Delegate and datasource

-(BOOL)mainControllerShouldShowMenu{
    return YES;
}
-(BOOL)mainControllerShouldShowRightButton{
    return NO;
}
-(BOOL)mainControllerShouldShowRightMostButton{
    return NO;
}
-(id)mainControllerIconForMenu{
    return [UIImage imageNamed:@"back_arrow.png"];
}
-(BOOL)mainControllerShouldShowTopbar{
    return YES;
}
-(BOOL)mainControllerTopbarShouldTransperant{
    return YES;
}

-(void)mainControllerNavigationMenuButtonDidTappedWithObject:(id)object{
    [self.navigationController popViewControllerAnimated:YES];
}
-(BOOL)mainControllerNavigationMenuShouldToggleSidebar{
    return NO;
}
-(NSString*)mainControllerTitleForScreen{
    return @"";
}
@end
