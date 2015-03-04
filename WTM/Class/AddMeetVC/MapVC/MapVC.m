//
//  MapVC.m
//  ParseStarterProject
//
//
//

#import "MapVC.h"

#define kAPIKey @"AIzaSyDx76torLMSXSGUYxUysD1TQ_mLi4PJjLY"

@interface MapVC (){
    GMSMarker *aMarker;
}
@property (weak, nonatomic) IBOutlet MVPlaceSearchTextField *txtFieldSearch;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@end

@implementation MapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _mapView.delegate = self;
    _txtFieldSearch.placeSearchDelegate=self;
    //    _txtFieldSearch.delegate=self;
    _txtFieldSearch.strApiKey=kAPIKey;
    _mapView.userInteractionEnabled =  YES;
    mutDicLocation = [NSMutableDictionary dictionary];
    _txtFieldSearch.layer.cornerRadius = 3.0;
    _txtFieldSearch.layer.masksToBounds = YES;
    _txtFieldSearch.leftView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 25, _txtFieldSearch.frame.size.height)];
    _txtFieldSearch.leftViewMode = UITextFieldViewModeAlways;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)placeSearchResponseForSelectedPlace:(NSMutableDictionary*)responseDict{
    NSDictionary *aDictLocation=[[[responseDict objectForKey:@"result"] objectForKey:@"geometry"] objectForKey:@"location"];
    double latitude=[[aDictLocation objectForKey:@"lat"] doubleValue];
    double longitude=[[aDictLocation objectForKey:@"lng"] doubleValue];
    [mutDicLocation setObject:[PFGeoPoint geoPointWithLatitude:latitude longitude:longitude] forKey:@"location"];

    [self addMarkerAtLocation:CLLocationCoordinate2DMake(latitude,longitude)];
    _mapView.selectedMarker=aMarker;
    [self animateToLocation:latitude and:longitude];
    
}
-(void)placeSearchWillShowResult{
    
}
-(void)placeSearchWillHideResult{
    
}

#pragma mark - Custom Methods

-(void)animateToLocation:(double)latitude and:(double)longitude{
    
    float currentZoom=_mapView.camera.zoom;
    float duration;
    
    float differance=15-currentZoom;
    duration=differance>5?3.f:1.f;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];  // 3 second animation
    GMSCameraUpdate *cameraUpdate=[GMSCameraUpdate setTarget:CLLocationCoordinate2DMake(latitude, longitude) zoom:15];
    [_mapView animateWithCameraUpdate:cameraUpdate];
    [_mapView animateToViewingAngle:10];
    [CATransaction commit];
    
}
//===================================================================================
// Add PlaceMark at Co-ordinate passed as Param
//===================================================================================
-(void)addMarkerAtLocation:(CLLocationCoordinate2D)coordinate{
    if(!aMarker){
        aMarker = [[GMSMarker alloc] init];
        aMarker.appearAnimation = kGMSMarkerAnimationPop;
        aMarker.flat = NO;
        aMarker.draggable = YES;
        aMarker.groundAnchor = CGPointMake(0.43, 1.0);
        aMarker.map = _mapView;
        aMarker.icon=[UIImage imageNamed:@"pin_icon.png"];
    }
    aMarker.position = coordinate;
    
}

#pragma mark - Google Map delegates

//===================================================================================
// get Location on Long Pressed location on Map
//===================================================================================
-(void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [mutDicLocation setObject:[PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude] forKey:@"location"];
    [self addMarkerAtLocation:coordinate];
    [self loadAddressWithLat:coordinate.latitude Long:coordinate.longitude];
}
//===================================================================================
// Beging Dragging Pin
//===================================================================================
-(void)mapView:(GMSMapView *)mapView didBeginDraggingMarker:(GMSMarker *)marker{
    [UIView animateWithDuration:0.3 animations:^{
        aMarker.groundAnchor = CGPointMake(0.43, 1.5);
    }];
}
//===================================================================================
// Ends Dragging Pin
//===================================================================================
-(void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker{
    [UIView animateWithDuration:0.2 animations:^{
        aMarker.groundAnchor = CGPointMake(0.43, 1.0);
    }];
    
}


#pragma mark - GeoCoders Method

//===================================================================================
// Fetches the Location name(formatted) according to Lat-Long
//===================================================================================
-(void)loadAddressWithLat:(double)latitude Long:(double)longitude{
    
    NSDictionary *aDict=[self getAddressForLatitude:latitude longitude:longitude];
    
    NSString *aStrFormattedAddress=[[[aDict objectForKey:@"results"] firstObject] objectForKey:@"formatted_address"];
    
    if(aStrFormattedAddress){
        _txtFieldSearch.text=aStrFormattedAddress;
    }
}

- (NSDictionary *)getAddressForLatitude:(double)latitude longitude:(double)longitude
{
    NSString *aStrUrl=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true&key=%@",latitude,longitude,kAPIKey];
    NSURL *aUrl=[NSURL URLWithString:aStrUrl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:aUrl
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    // Fetch the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    if(urlData){
        // Construct a String around the Data from the response
        NSDictionary *aDict=[NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingAllowFragments error:&error];
        return aDict;
    }else{
        return nil;
    }
    
}
- (IBAction)btnSaveAction:(id)sender
{
    [mutDicLocation setObject:_txtFieldSearch.text forKey:@"address"];
    
    [_delegate selectLocationDidFinishedWithLocationInfo:mutDicLocation];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)btnCancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
