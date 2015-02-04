//
//  SelectLocationVC.m
//  WTM
//

#import "SelectLocationVC.h"

@interface SelectLocationVC ()

@end

@implementation SelectLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *aDictLocationData = [NSDictionary dictionaryWithObjectsAndKeys:[PFGeoPoint geoPointWithLatitude:72.0 longitude:27],@"location",@"Ahmedabad",@"address", nil];
    [_delegate selectLocationDidFinishedWithLocationInfo:aDictLocationData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
        
    });
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
