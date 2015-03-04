//
//  PhotostreamCell.h
//  WTM
//
//   04/02/15.
//
//

#import <UIKit/UIKit.h>

@interface PhotostreamCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionImages;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property(nonatomic,strong)NSMutableArray *mutArrPhotos;
@end
