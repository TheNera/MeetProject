//
//  ColorButton.m
//  WTM
//
//   06/02/15.
//
//

#import "ColorButton.h"

@implementation ColorButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setValue:(id)value forKeyPath:(NSString *)keyPath{
    if([keyPath isEqualToString:@"bgColor"]){
        UIColor *aColor = (UIColor*)value;
        self.backgroundColor = aColor;
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
    }
}

@end
