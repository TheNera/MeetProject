//
//  PhotostreamCell.m
//  WTM
//
//   04/02/15.
//
//

#import "PhotostreamCell.h"

@implementation PhotostreamCell

- (void)awakeFromNib {
    _collectionImages.dataSource =self;
    _collectionImages.delegate =self;
    // Initialization code
}
-(void)layoutSubviews{
    _collectionImages.frame =CGRectMake(20, 44, self.frame.size.width-40, self.frame.size.height-44);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)setMutArrPhotos:(NSMutableArray *)mutArrPhotos{
    _mutArrPhotos = mutArrPhotos;
    [self updateCellTitle];
    [_collectionImages reloadData];
}
-(void)updateCellTitle{
    if(_mutArrPhotos.count>0){
        _lblTitle.text = [NSString stringWithFormat:@"%ld Photos",_mutArrPhotos.count];
    }else{
        _lblTitle.text =  [NSString stringWithFormat:@"No Photos Available"];
    }
}
#pragma mark -  CollectionView Delegate and Datasouce
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _mutArrPhotos.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *aCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imgCell" forIndexPath:indexPath];
    
    UIImageView *aImg = (UIImageView*)[aCell viewWithTag:100];
    aImg.image = nil;
    
    PFObject *aObjectPhotoStream = [_mutArrPhotos objectAtIndex:indexPath.row];
    
    NSString *aStrUrl = [aObjectPhotoStream objectForKey:@"image"];
    
    if(aStrUrl){
        NSURL *aImgURL = [NSURL URLWithString:aStrUrl];
        [aImg sd_setImageWithURL:aImgURL placeholderImage:[UIImage imageNamed:@"12_photos_2.png"]];
    }else{
        [aImg setImage:[UIImage imageNamed:@"12_photos_2.png"]];
    }
    return aCell;
}


@end
