//
//  PreviewVC.h
//  WTM
//
//  Created by Jwalin Shah on 20/02/15.
//
//

#import <UIKit/UIKit.h>

@protocol PreviewDelegate <NSObject>
-(void)priviewDidDismissedWithObject:(PFObject*)object;
@end

@interface PreviewVC : UIViewController{
    PFObject *object;
}
@property (weak, nonatomic) IBOutlet UIView *viewDetailContainer;
@property (weak, nonatomic) IBOutlet UILabel *lblTitleDate;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewProfile;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewPreview;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (strong,nonatomic)id<PreviewDelegate>delegate;
-(void)loadPreviewScreenWithInfo:(PFObject*)info refRect:(CGRect)rect;
@end
