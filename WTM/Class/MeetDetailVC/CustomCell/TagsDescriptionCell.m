//
//  TagsDescriptionCell.m
//  WTM
//
//   04/02/15.
//
//

#import "TagsDescriptionCell.h"

@implementation TagsDescriptionCell

- (void)awakeFromNib {
    // Initialization code
    _txtViewTags.font =[ UIFont fontWithName:kTagsFontName size:kTagsFontSize];
    _txtViewDescription.font = [UIFont fontWithName:kDescriptionFontName size:kDescriptionFontSize];
}
//-(void)layoutSubviews{
//    _txtViewDescription.frame = CGRectMake(11, 26, self.frame.size.width-21, self.frame.size.height-50);
//    _txtViewTags.frame = CGRectMake(11, 0, self.frame.size.width-21, 26);
//    NSLog(@"Layout Called");
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setTags:(NSString *)strTags andDescription:(NSString *)strDescription{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGFloat width = self.frame.size.width -(2*12);
        CGRect rectTags = [strTags boundingRectWithSize:CGSizeMake(width, 9999) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:kDescriptionFontName size:kDescriptionFontSize]} context:nil];
        
        CGRect rectDescription = [strDescription boundingRectWithSize:CGSizeMake(width, 9999) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:kTagsFontName size:kTagsFontSize]} context:nil];
        
        _txtViewTags.text = strTags;
        _txtViewDescription.text = strDescription;
        
        _txtViewTags.frame = CGRectMake(11, 8.0, width, rectTags.size.height+20);
        _txtViewDescription.frame = CGRectMake(11, _txtViewTags.frame.origin.y + _txtViewTags.frame.size.height-15, width, rectDescription.size.height+25.0);
    });
    
}

@end
