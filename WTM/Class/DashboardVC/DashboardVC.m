//
//  DashboardVC.m
//  WTM
//
//   31/01/15.
//
//

#import "DashboardVC.h"
#import "UIImageView+WebCache.h"
@interface DashboardVC (){
    NSMutableArray *mutArrDatasource;
}
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewProfilePic;
@property (weak, nonatomic) IBOutlet UIButton *btnViewEditProfile;
@end

@implementation DashboardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setProfileDetail) name:@"loginStateChange" object:nil];
    mutArrDatasource = [NSMutableArray array];
    [mutArrDatasource addObject:[self dictForTitle:@"Find Meets" imageName:@"find_icon.png"]];
    [mutArrDatasource addObject:[self dictForTitle:@"Meets I'm Attending" imageName:@"attending_icon.png"]];
    [mutArrDatasource addObject:[self dictForTitle:@"My Meets" imageName:@"my_meet_icon.png"]];
    [mutArrDatasource addObject:[self dictForTitle:@"Photostream" imageName:@"photo_stream_icon.png"]];
    [mutArrDatasource addObject:[self dictForTitle:@"Settings" imageName:@"setting_icon.png"]];
    self.view.backgroundColor = [UIColor clearColor];
    
    if([PFUser currentUser]){
        [self setProfileDetail];
    }else{
            appDel.mainController.btnMenu.hidden = YES;
    }
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    _imgViewProfilePic.contentMode = UIViewContentModeScaleAspectFill;
    _imgViewProfilePic.layer.cornerRadius = _imgViewProfilePic.frame.size.width/2.0;
    _imgViewProfilePic.layer.borderColor = [UIColor whiteColor].CGColor;
    _imgViewProfilePic.layer.borderWidth =2.0;
    _imgViewProfilePic.layer.masksToBounds = YES;
}
-(NSDictionary*)dictForTitle:(NSString*)strTitle imageName:(NSString*)strImgName{
    
    NSDictionary *aDict = [NSDictionary dictionaryWithObjectsAndKeys:strTitle,@"title",[UIImage imageNamed:strImgName],@"image", nil];
    
    return aDict;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate and Datasource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([_delegate respondsToSelector:@selector(dashboard:DidSelectMenu:)]){
        [_delegate dashboard:self DidSelectMenu:indexPath.row];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return mutArrDatasource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UILabel *aLbl = (UILabel*)[aCell viewWithTag:101];
    UIImageView *aImgView = (UIImageView*)[aCell viewWithTag:100];
    
    NSDictionary *aDict = [mutArrDatasource objectAtIndex:indexPath.row];
    aLbl.text =aDict[@"title"];
    aImgView.image = aDict[@"image"];
    return aCell;
}


#pragma mark -  Button Actions
- (IBAction)btnViewEditProfileAction:(id)sender {
    [_delegate dashboardDidTappedToViewProfile:self];
}
-(void)setProfileDetail{
    appDel.mainController.btnMenu.hidden = NO;
    PFUser *user = [PFUser currentUser];
    _lblUserName.text = user[@"FName"];
    [_imgViewProfilePic sd_setImageWithURL:[NSURL URLWithString:user[@"ProfileImageUrl"]]];
}

@end
