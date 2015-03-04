//
//  AddressCell.m
//  WTM
//
//   04/02/15.
//
//

#import "AddressCell.h"
#define kHeightWidth 86
#define kLeftPadding 17
@implementation AddressCell

- (void)awakeFromNib {
    _mapView.delegate =self;
    // Initialization code
}
-(void)layoutSubviews{
    _mapView.frame =  CGRectMake(self.frame.size.width-kHeightWidth, 0,kHeightWidth, kHeightWidth);
    _tapView.frame = _mapView.frame;
    _lblCellTitle.frame = CGRectMake(kLeftPadding, 10, self.frame.size.width-_mapView.frame.size.width-(kLeftPadding + kLeftPadding), 17);
    _txtViewAddress.frame = CGRectMake(kLeftPadding-3, _lblCellTitle.frame.origin.y+_lblCellTitle.frame.size.height, _lblCellTitle.frame.size.width, self.frame.size.height - _lblCellTitle.frame.origin.y+_lblCellTitle.frame.size.height);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTitle:(NSString *)strTitle place:(NSString *)strAddress location:(CLLocationCoordinate2D)location{
    _lblCellTitle.text = strTitle;
    _txtViewAddress.text = strAddress;
    [self addMarkerAtLocation:location];
    _mapView.selectedMarker = aMarker;
    [self animateToLocation:location.latitude and:location.longitude];
}

#pragma mark - MapView Delegates
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

-(void)animateToLocation:(double)latitude and:(double)longitude{
    
    float currentZoom=_mapView.camera.zoom;
    float duration;
    float differance=15-currentZoom;
    duration=differance>5?3.f:1.f;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0];  // 3 second animation
    GMSCameraUpdate *cameraUpdate=[GMSCameraUpdate setTarget:CLLocationCoordinate2DMake(latitude, longitude) zoom:10];
    [_mapView animateWithCameraUpdate:cameraUpdate];
    [_mapView animateToViewingAngle:10];
    [CATransaction commit];
    
}
@end
