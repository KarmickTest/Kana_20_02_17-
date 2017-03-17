//
//  FirstViewController.m
//  Kana
//
//  Created by Karmick on 13/01/17.
//  Copyright © 2017 Karmick. All rights reserved.
//

#import "FirstViewController.h"
#import "DefineHeader.h"
#import "Constant.h"
#import "LocalizeHelper.h"



@interface FirstViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSMutableArray *arrmHomeContent;
    NSMutableArray *arrmSpecialization;
    MBProgressHUD *hud;
    SCLAlertView *alert;
    NSString *languageCheck;
   
}
@property (weak, nonatomic) IBOutlet UICollectionView *colv_Choose_Clinic;
@property (weak, nonatomic) IBOutlet UIView *vw_For_Flipping;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_Image;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Choose_Clinic;

@end


@implementation FirstViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _colv_Choose_Clinic.layer.cornerRadius=5.0f;
    
    _colv_Choose_Clinic.delegate=self;
    _colv_Choose_Clinic.dataSource=self;
    arrmHomeContent=[[NSMutableArray alloc]init];
    arrmSpecialization=[[NSMutableArray alloc]init];
    [self getClinicList];
    
       
   
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    languageCheck =[[NSUserDefaults standardUserDefaults]objectForKey:@"languageCode"];
    LocalizationSetLanguage(languageCheck);
    DebugLog(@"%@",languageCheck);
    _lbl_Choose_Clinic.text=LocalizedString(@"HOME");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -  Call Web Service

-(void)getClinicList{
    
     if ([Utility isNetworkAvailable]==YES) {
                  /**********Custom loader****************/
         languageCheck=[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
          DebugLog(@"languageCheck%@",languageCheck);
           hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            NSString *strClinicListApi=[NSString stringWithFormat:@"%@%@",API,CLINICLIST];
            DebugLog(@"The string value:%@",strClinicListApi);
         NSString *strParameter=[NSString stringWithFormat:@"lang=%@",languageCheck, nil];
         DebugLog(@"The Keyvalue:%@",strParameter);

            
         [[Singelton getInstance] jsonParseWithPostMethod:^(NSDictionary *testResult)
          {
                DebugLog(@"ClinicList====%@",testResult);
                if ([[testResult valueForKey:@"success"] boolValue]==1) {
                    arrmHomeContent=[testResult valueForKey:@"details"];
                    DebugLog(@"arrmHomeContent====%@",arrmHomeContent);
               }
             else{
                 alert=[[SCLAlertView alloc]init];
                [alert showWarning:self title:@"Oops!" subTitle:[testResult valueForKey:@"message"] closeButtonTitle:@"OK" duration:0.0f];
                     
                 }
                 [_colv_Choose_Clinic reloadData];
                 self.view.userInteractionEnabled=YES;
                 [hud hideAnimated:YES];

               } andString:strClinicListApi andParam:strParameter];
            }
            else{
                alert=[[SCLAlertView alloc]init];
            [alert showWarning:self title:@"Warning" subTitle:@"Network error" closeButtonTitle:@"OK" duration:0.0f];
     }
}


#pragma mark - CollectionView Delegate and Data Source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;//[firstSection count];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [arrmHomeContent count];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(225, 225);
    
    return size;
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(15, 15, 15, 15); // top, left, bottom, right
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCell *mHomeCell = (HomeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCell" forIndexPath:indexPath];
    mHomeCell.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    mHomeCell.imgv_Background_Image.layer.masksToBounds = YES;
    [mHomeCell.imgv_Background_Image sd_setImageWithURL:[NSURL URLWithString:[[arrmHomeContent objectAtIndex:indexPath.row] valueForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"Gallery_Placeholder"] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
    mHomeCell.imgv_Background_Image.clipsToBounds=YES;
    mHomeCell.imgv_Background_Image.layer.cornerRadius=5.0f;
    mHomeCell.imgv_Shadow.layer.cornerRadius=5.0f;
    mHomeCell.contentView.layer.cornerRadius=5.0f;

    mHomeCell.lbl_Clinic_Name.text=[[arrmHomeContent valueForKey:@"name"]objectAtIndex:indexPath.row];
    mHomeCell.lbl_Clinic_Address.text=[[arrmHomeContent valueForKey:@"address"]objectAtIndex:indexPath.row];
    
    return mHomeCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyboard;
    if([languageCheck isEqualToString:@"en"]){
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    else{
        storyboard =[UIStoryboard storyboardWithName:@"Arabic_Storyboard" bundle:nil];
    }
    
    CATransition *transition = [CATransition animation];
    transition.duration = .3;
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    
    DoctorListingViewController *mDoctorListingViewController = [storyboard instantiateViewControllerWithIdentifier:@"DoctorListingViewController"];
    mDoctorListingViewController.strSpecialistId=[[arrmHomeContent objectAtIndex:indexPath.row] valueForKey:@"spid"];
    DebugLog(@"strSpecialistId%@",mDoctorListingViewController.strSpecialistId);
    [self.navigationController pushViewController:mDoctorListingViewController animated:NO];
//    UIStoryboard *storyboard;
//   
//    if([languageCheck isEqualToString:@"en"]){
//        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    }
//    else{
//        storyboard =[UIStoryboard storyboardWithName:@"Arabic_Storyboard" bundle:nil];
//    }
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Specialization"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    arrmSpecialization=[[arrmHomeContent valueForKey:@"speciality"]objectAtIndex:indexPath.row];
//    [[NSUserDefaults standardUserDefaults] setObject:arrmSpecialization forKey:@"Specialization"];
//    [[NSUserDefaults standardUserDefaults] setObject:[[arrmHomeContent valueForKey:@"id"]objectAtIndex:indexPath.row] forKey:@"ClinicId"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    CATransition *transition = [CATransition animation];
//    transition.duration = .3;
//    transition.type = kCATransitionFade;
//    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
//    TabBarController *mTabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
//    if([languageCheck isEqualToString:@"en"]){
//    }
//    else{
//    [mTabBarController setSelectedIndex:4];
//    }
//    
//    [self.navigationController pushViewController:mTabBarController animated:NO];
    
   
    

    
}



@end
