//
//  PreviewVC.m
//  WTM
//
//  Created by Jwalin Shah on 20/02/15.
//
//

#import "PreviewVC.h"
#import "UIImageView+WebCache.h"

#define kTitleFont    [UIFont fontWithName:@"DINPro-Bold" size:15.0]
#define kDateFont    [UIFont fontWithName:@"DINPro-Medium" size:12.0]
#define kColorBG    [UIColor colorWithRed:29/255.0 green:32/255.0 blue:40/255.0 alpha:0.85];
@interface PreviewVC ()
{
    CGRect rectImageView;
    CGRect rectCell;
}
@end

@implementation PreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view bringSubviewToFront:_imgViewProfile];
    _imgViewProfile.layer.cornerRadius = _imgViewProfile.frame.size.height*0.5;
    _imgViewProfile.layer.masksToBounds =YES;
    rectImageView = _imgViewPreview.frame;
    self.view.backgroundColor = [UIColor clearColor];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnCloseAction:(id)sender {
    [self transitImageViewisExit:YES];
    _btnClose.hidden = YES;
}

-(void)loadPreviewScreenWithInfo:(PFObject*)info refRect:(CGRect)rect{
    
    __block NSString *aStrDescription;
    __block NSString *aStrCoverImagePath = info[@"image"];
    __block NSString *aStrCategories;
    __block NSString *aStrName;
    
    rectCell =rect;
    PFObject *meetObject = info[@"meet"];
    [meetObject fetchIfNeededInBackgroundWithBlock:^(PFObject *aObject, NSError *error) {
            info[@"meet"]=aObject;
            aStrDescription = aObject[@"description"];
            aStrCategories =aObject[@"categories"];
            aStrName =aObject[@"title"];
            [self setTitleOnLabel:aStrName date:info[@"date"]];
        
            NSString *aStrDescCate = [NSString stringWithFormat:@"%@\n\n%@",aStrCategories,aStrDescription];
            _txtDescription.text = aStrDescCate;
            _txtDescription.font = kDateFont;
    }];
    

    PFObject *userObject = info[@"user"];
    [userObject fetchIfNeededInBackgroundWithBlock:^(PFObject *aObject, NSError *error) {
            info[@"user"]= aObject;
        _imgViewProfile.hidden = YES;
        _imgViewProfile.alpha=0.0;
        [_imgViewProfile sd_setImageWithURL:[NSURL URLWithString:aObject[@"ProfileImageUrl"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _imgViewProfile.image =image;
            _imgViewProfile.hidden = NO;
            
            [UIView animateWithDuration:0.3 animations:^{
                _imgViewProfile.alpha = 1.0;
            }];
        }];

    }];
    
// ispl216##
    
    //Cover Image
    [_imgViewPreview sd_setImageWithURL:[NSURL URLWithString:aStrCoverImagePath]];
    [self transitImageViewisExit:NO];
    object =  info;
}
-(void)transitImageViewisExit:(BOOL)isExit{
    _imgViewPreview.frame = !isExit?rectCell:_imgViewPreview.frame;
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:1 animations:^{
        _imgViewPreview.frame =!isExit?rectImageView:rectCell;
    } completion:nil];
    
    if(!isExit){
        _viewDetailContainer.transform = CGAffineTransformTranslate(_viewDetailContainer.transform, 0, 50);
        _viewDetailContainer.alpha = 0.0;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        _viewDetailContainer.transform = isExit?CGAffineTransformTranslate(_viewDetailContainer.transform, 0, 15):CGAffineTransformIdentity;
        _viewDetailContainer.alpha = isExit?0:1.0;
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.backgroundColor = isExit?[UIColor clearColor]:kColorBG;
        
    }completion:^(BOOL finished) {
        if(isExit){
            if([_delegate respondsToSelector:@selector(priviewDidDismissedWithObject:)])
                [_delegate priviewDidDismissedWithObject:object];
            [self removeFromParentViewController];
            [self.view removeFromSuperview];
            self.view  = nil;
        }
    }];
    
}
-(void)setTitleOnLabel:(NSString*)aStrName date:(NSDate*)aDate{
    NSDate *localDate =  [appDel convertDateToLocale:aDate];
    
    NSString *aStrDate = [appDel getDayNotation:localDate withDate:YES];
    NSString *aStrTitleDate = [NSString stringWithFormat:@"%@	 %@",aStrName,aStrDate];
    NSMutableAttributedString *attrName = [[NSMutableAttributedString alloc]initWithString:aStrTitleDate];
    
    NSRange rngTitle  =[aStrTitleDate rangeOfString:aStrName];
    NSRange rngDate = [aStrTitleDate rangeOfString:aStrDate];
    
    [attrName addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rngTitle];
    [attrName addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:117/255.0 green:117/255.0 blue:117/255.0 alpha:1.0] range:rngDate];
    
    
    [attrName addAttribute:NSFontAttributeName value:kTitleFont range:rngTitle];
    [attrName addAttribute:NSFontAttributeName value:kDateFont range:rngDate];
    _lblTitleDate.attributedText = attrName;
}
@end
