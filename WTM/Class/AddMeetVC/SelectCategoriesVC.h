//
//  SelectCategoriesVC.h
//  WTM
//

//
//

#import <UIKit/UIKit.h>

@protocol SelectCategoriesDelegate <NSObject>
-(void)selectCategoriesDidFinishedWithCategories:(NSArray*)arrCategories;
-(void)selectCategoriesDidCancelled;
@end

@interface SelectCategoriesVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSString *strSelectedCategory;
@property(nonatomic,strong)NSMutableArray *mutArrSelectedCategories;
@property(nonatomic,strong)id<SelectCategoriesDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITableView *tblCategories;
@end
