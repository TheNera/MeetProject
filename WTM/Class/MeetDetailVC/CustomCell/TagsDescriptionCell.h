//
//  TagsDescriptionCell.h
//  WTM
//
//   04/02/15.
//
//

#import <UIKit/UIKit.h>
#define kTagsFontSize 12.0
#define kDescriptionFontSize  12.0
#define kTagsFontName @"DINPro-Medium"
#define kDescriptionFontName @"DINPro-Regular"
@interface TagsDescriptionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *txtViewDescription;
@property (weak, nonatomic) IBOutlet UITextView *txtViewTags;
-(void)setTags:(NSString*)strTags andDescription:(NSString*)strDescription;

@end
