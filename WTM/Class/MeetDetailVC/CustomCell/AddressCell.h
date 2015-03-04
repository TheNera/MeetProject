//
//  AddressCell.h
//  WTM
//
//   04/02/15.
//
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
@interface AddressCell : UITableViewCell<GMSMapViewDelegate>{
    GMSMarker *aMarker;
}
@property (weak, nonatomic) IBOutlet UILabel *lblCellTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtViewAddress;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *tapView;

-(void)setTitle:(NSString*)strTitle place:(NSString*)strAddress location:(CLLocationCoordinate2D)location;

@end
