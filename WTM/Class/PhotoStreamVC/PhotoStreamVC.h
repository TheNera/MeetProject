//
//  PhotoStreamVC.h
//  WTM
//
//  Created by Jwalin Shah on 18/02/15.
//
//

#import <UIKit/UIKit.h>
#import "PreviewVC.h"
@interface PhotoStreamVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,PreviewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *mutArrPhotos;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collPhotos;

@end
