//
//  PhotoStreamVC.m
//  WTM
//
//  Created by Jwalin Shah on 18/02/15.
//
//

#import "PhotoStreamVC.h"
#import "AddMeetVC.h"
#import "PostPhotoVC.h"
@interface PhotoStreamVC ()<MainControllerNavigationDelegate,MainControllerTopbarDatasource>
{
    UICollectionViewCell *cellHidden;
    }
@property (weak, nonatomic) IBOutlet UIButton *btnMyPhotos;
@property (weak,nonatomic) IBOutlet UIButton *btnEveryOnePhoto;

@end

@implementation PhotoStreamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    mutArrPhotos = [[NSMutableArray   alloc]init];
    [self getPhotoStreamFromParse:nil];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    appDel.mainController.topbarDatasource=self;
    appDel.mainController.navigationDelegate =self;
}
-(void)getPhotoStreamFromParse :(PFUser *)user
{
    PFQuery *query= [PFQuery queryWithClassName:@"Photostream"];
    if (user)
    {
        [query whereKey:@"user" equalTo:user];
    }
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        {
            [mutArrPhotos removeAllObjects];
            [mutArrPhotos addObjectsFromArray:objects];
            [_collPhotos reloadData];
        }
    }];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return mutArrPhotos.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *aCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoStreamCell" forIndexPath:indexPath];
    PFObject *object = [mutArrPhotos objectAtIndex:indexPath.row];
    
    UIImageView *imgPhoto = (UIImageView*)[aCell viewWithTag:101];
    [imgPhoto sd_setImageWithURL:[NSURL URLWithString:object[@"image"]] placeholderImage:nil];
    return aCell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PFObject *object = [mutArrPhotos objectAtIndex:indexPath.row];
    UICollectionViewCell *aCell = [collectionView cellForItemAtIndexPath:indexPath] ;
    CGRect rectReferance = [self.view convertRect:aCell.frame fromView:aCell.superview];
    [appDel.mainController showImagePreviewOverlay:object cellObject:rectReferance delegate:self];
    cellHidden = aCell;
    aCell.hidden =YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float sizeOfcell = (self.view.frame.size.width-(2*12)-3)/3;
    return CGSizeMake(sizeOfcell, sizeOfcell);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnEveryOnePhoto:(id)sender {
    [self getPhotoStreamFromParse:nil];
}
- (IBAction)btnMyPhotos:(id)sender {
        [self getPhotoStreamFromParse:[PFUser currentUser]];
}

#pragma mark - Preview Delegate
-(void)priviewDidDismissedWithObject:(PFObject *)object
{
    cellHidden.hidden = NO;
    cellHidden = nil;
}
#pragma mark - Main Controller Delegate and Datasource

-(BOOL)mainControllerShouldShowMenu{
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"isLoggedIn"];
}
-(BOOL)mainControllerShouldShowRightButton{
    if (![PFUser currentUser])
    {
        return NO;
    }
    return YES;
}
-(BOOL)mainControllerShouldShowRightMostButton{
    if (![PFUser currentUser])
    {
        return NO;
    }
    return YES;
}

-(BOOL)mainControllerShouldShowTopbar{
    return YES;
}

-(id)mainControllerIconForMenu{
    return [UIImage imageNamed:@"menu_icon.png"];
}
-(id)mainControllerIconForRightButton{
    return [UIImage imageNamed:@"calender.png"];
}
-(id)mainControllerIconForRightMostButton{
    return [UIImage imageNamed:@"camera.png"];
}

-(NSString*)mainControllerTitleForScreen{
    return @"PHOTOSTREAM";
    
}
-(void)mainControllerNavigationRightMostButtonDidTappedWithObject:(id)object
{
    PostPhotoVC *postPhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PostPhotoVC"];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:postPhotoVC];
    [self presentViewController:navController animated:YES completion:nil];
    
}
-(void)mainControllerNavigationRightButtonDidTappedWithObject:(id)object
{
    AddMeetVC *addMeetVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddMeetVC"];
    [self presentViewController:addMeetVC animated:YES completion:nil];
}



@end
