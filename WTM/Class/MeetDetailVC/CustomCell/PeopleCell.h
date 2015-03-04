//
//  PeopleCell.h
//  WTM
//
//   04/02/15.
//
//

#import <UIKit/UIKit.h>

@interface PeopleCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *colletionPeople;
@property (weak, nonatomic) IBOutlet UILabel *lblCellTitle;
@property (nonatomic,strong)NSMutableArray *mutArrPeople;
-(void)showActivityInProgress:(BOOL)shouldShow;

@end
