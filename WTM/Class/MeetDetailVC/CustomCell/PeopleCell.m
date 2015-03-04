//
//  PeopleCell.m
//  WTM
//
//   04/02/15.
//
//

#import "PeopleCell.h"
#import "UIImageView+WebCache.h"
@implementation PeopleCell

- (void)awakeFromNib {
    // Initialization code
    [self updateCellTitle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setMutArrPeople:(NSMutableArray *)mutArrPeople{
    _mutArrPeople = mutArrPeople;
    [self updateCellTitle];
    [_colletionPeople reloadData];
}
-(void)updateCellTitle{
    if(_mutArrPeople.count>0){
        _lblCellTitle.text = [NSString stringWithFormat:@"%ld People Going",_mutArrPeople.count];
    }else{
        _lblCellTitle.text =  [NSString stringWithFormat:@"No People Going"];
    }
}
#pragma mark -  CollectionView Delegate and Datasouce
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _mutArrPeople.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *aCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imgCell" forIndexPath:indexPath];
    PFUser *aUserInfo = [_mutArrPeople objectAtIndex:indexPath.row];


    UIImageView *aImg = (UIImageView*)[aCell viewWithTag:100];
    aImg.frame =aCell.bounds;
    NSLog(@"Radius : %f",aImg.frame.size.height);
    aImg.layer.cornerRadius = aImg.frame.size.height/2.0;
    aImg.layer.masksToBounds = YES;
    aImg.image = nil;

    
    NSString *aStrUrl = aUserInfo[@"ProfileImageUrl"];
    if(aStrUrl){
        NSURL *aImgURL = [NSURL URLWithString:aStrUrl];
        [aImg sd_setImageWithURL:aImgURL placeholderImage:[UIImage imageNamed:@"profilePlaceholder.png"]];
    }else{
        [aImg setImage:[UIImage imageNamed:@"profilePlaceholder.png"]];
    }
    return aCell;
}


@end
