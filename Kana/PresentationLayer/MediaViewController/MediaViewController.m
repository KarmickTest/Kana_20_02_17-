//
//  MediaViewController.m
//  Kana
//
//  Created by Karmick on 11/01/17.
//  Copyright © 2017 Karmick. All rights reserved.
//

#import "MediaViewController.h"
#import "DefineHeader.h"
#import "Constant.h"
#import "UIImageView+WebCache.h"

@interface MediaViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    NSMutableArray *arrm_Citylist;
    NSDictionary *CitynameImage;
    NSDictionary *dicNamewdSourceCode;
    NSArray *exampleCardLabels,*searchCity,*cityname,*cityimg;
    
    MBProgressHUD *hud;
    SCLAlertView *alert;
    NSMutableArray *MediaListArray;
    NSString *languageCheck;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tblv_MediaTable;

@end

@implementation MediaViewController

#pragma mark View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     _tblv_MediaTable.delegate=self;
    _tblv_MediaTable.dataSource=self;
    
    
    _MediaCollection.delegate=self;
    _MediaCollection.dataSource=self;
    
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"TapOnCell"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    languageCheck =[[NSUserDefaults standardUserDefaults]objectForKey:@"languageCode"];
    LocalizationSetLanguage(languageCheck);
    [self GetMediaList];
}
#pragma mark -  Call Web Service

-(void)GetMediaList{
     languageCheck=[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
    DebugLog(@"languageCheck%@",languageCheck);
    if ([Utility isNetworkAvailable]==YES) {
        /**********Custom loader****************/
        hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        NSString *strClinicListApi=[NSString stringWithFormat:@"%@%@",API,MEDIALIST];
        DebugLog(@"The string value:%@",strClinicListApi);
        
        [[Singelton getInstance] jsonparse:^(NSDictionary* testResult){
            DebugLog(@"ClinicList====%@",testResult);
            if ([[testResult valueForKey:@"success"] boolValue]==1) {
                
                MediaListArray=[[NSMutableArray alloc] init];
                
                MediaListArray=[testResult valueForKey:@"list"];
                
                [self.tblv_MediaTable reloadData];
                [self.MediaCollection reloadData];
                
                DebugLog(@"arrmHomeContent====%@",MediaListArray);
            }
            else{
                alert=[[SCLAlertView alloc]init];
                [alert showWarning:self title:@"Oops!" subTitle:[testResult valueForKey:@"message"] closeButtonTitle:@"OK" duration:0.0f];
                
            }
            
            self.view.userInteractionEnabled=YES;
            [hud hideAnimated:YES];
            
        } andString:strClinicListApi];
    }
    else{
        alert=[[SCLAlertView alloc]init];
        [alert showWarning:self title:@"Warning" subTitle:@"Network error" closeButtonTitle:@"OK" duration:0.0f];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    
    //[_searchBar becomeFirstResponder];
   [super viewDidAppear:animated];
    
}



#pragma mark TableView Delegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
  return MediaListArray.count;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.01f;
    }
    else{
    return 10.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 147.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"MediaSearchCell";
    MediaSearchCell *mMediaSearchCell = (MediaSearchCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (mMediaSearchCell == nil){
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"MediaSearchCell" owner:self options:nil];
        mMediaSearchCell = [nibArray objectAtIndex:0];
        
    }
    mMediaSearchCell.lbl_Description1.text=[[MediaListArray objectAtIndex:indexPath.section] valueForKey:@"title"];
    mMediaSearchCell.lbl_Description2.text=[[MediaListArray objectAtIndex:indexPath.section] valueForKey:@"description"];
    [mMediaSearchCell.imgv_Media_Image sd_setImageWithURL:[NSURL URLWithString:[[MediaListArray objectAtIndex:indexPath.section] valueForKey:@"thumbURL"]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
    
      mMediaSearchCell.imgv_Media_Image.clipsToBounds=YES;
      mMediaSearchCell.lbl_Description4.hidden=YES;
        mMediaSearchCell.lbl_Description5.hidden=YES;
        mMediaSearchCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return mMediaSearchCell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%ld",indexPath.section);
    NSURL *linkToApp = [NSURL URLWithString:[NSString stringWithFormat:@"youtube://watch?v=%@",[[MediaListArray objectAtIndex:indexPath.section] valueForKey:@"media_id"]]]; // app
    NSURL *linkToWeb = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@",[[MediaListArray objectAtIndex:indexPath.section] valueForKey:@"media_id"]]]; // this is correct
    
    
    if ([[UIApplication sharedApplication] canOpenURL:linkToApp]) {
        // Can open the youtube app URL so launch the youTube app with this URL
        [[UIApplication sharedApplication] openURL:linkToApp];
    }
    else{
        // Can't open the youtube app URL so launch Safari instead
        [[UIApplication sharedApplication] openURL:linkToWeb];
    }
    
    
}







#pragma mark - CollectionView Delegate and Data Source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;//[firstSection count];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // NSLog(@"[arrmGetTimeSlots count]%ld",(long)[arrmGetTimeSlots count]);
    return MediaListArray.count;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    CGRect screenRect = [[UIScreen mainScreen] bounds];
    //    CGFloat screenWidth = screenRect.size.width;
    //    float cellWidth = screenWidth / 4.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
    CGSize size = CGSizeMake(167, 167);
    
    return size;
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10); // top, left, bottom, right
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MediaCollectionViewCell *mGalleryCell = (MediaCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MediaCollectionViewCell" forIndexPath:indexPath];
    mGalleryCell.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    // mGalleryCell.backgroundColor=[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0];
    //mGalleryCell.imgv_Gallery_Image.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[[galaryListContentArr objectAtIndex:indexPath.row] valueForKey:@"medium"]]];
    
    [mGalleryCell.YoutubeImageView sd_setImageWithURL:[NSURL URLWithString:[[MediaListArray objectAtIndex:indexPath.row] valueForKey:@"thumbURL"]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
    
   mGalleryCell.YoutubeImageView.clipsToBounds=YES;
    
    
    mGalleryCell.contentView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    mGalleryCell.contentView.layer.borderWidth=0.5f;
    
    
    
    return mGalleryCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DebugLog(@"you clicked image index: %ld",  indexPath.row);
    
    NSURL *linkToApp = [NSURL URLWithString:[NSString stringWithFormat:@"youtube://watch?v=%@",[[MediaListArray objectAtIndex:indexPath.row] valueForKey:@"media_id"]]]; // app
    NSURL *linkToWeb = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@",[[MediaListArray objectAtIndex:indexPath.row] valueForKey:@"media_id"]]]; // this is correct
    
    
    if ([[UIApplication sharedApplication] canOpenURL:linkToApp]) {
        // Can open the youtube app URL so launch the youTube app with this URL
        [[UIApplication sharedApplication] openURL:linkToApp];
    }
    else{
        // Can't open the youtube app URL so launch Safari instead
        [[UIApplication sharedApplication] openURL:linkToWeb];
    }
        
    
}













@end
