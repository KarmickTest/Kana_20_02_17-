//
//  DoctorListingViewController.m
//  Kana
//
//  Created by Karmick on 27/01/17.
//  Copyright © 2017 Karmick. All rights reserved.
//

#import "DoctorListingViewController.h"
#import "Constant.h"
#import "DefineHeader.h"



@interface DoctorListingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *strClinicId;
    MBProgressHUD *hud;
    NSMutableArray *arrmDoctorListing;
    SCLAlertView *alert;
    NSString *languageCheck;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tblv_DoctorListing;
@end



@implementation DoctorListingViewController

#pragma mark View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tblv_DoctorListing.delegate=self;
    _tblv_DoctorListing.dataSource=self;
    arrmDoctorListing=[[NSMutableArray alloc]init];
    strClinicId=[[NSUserDefaults standardUserDefaults] objectForKey:@"ClinicId"];
    
    DebugLog(@"strClinicId%@ ==== specId%@",strClinicId,_strSpecialistId);
   
    [self getDoctorList];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    languageCheck =[[NSUserDefaults standardUserDefaults]objectForKey:@"languageCode"];
    LocalizationSetLanguage(languageCheck);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -  Call Web Service

-(void)getDoctorList{
    /**********Custom loader****************/
    self.view.userInteractionEnabled=NO;
    hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
     languageCheck=[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     DebugLog(@"languageCheck%@",languageCheck);
    if ([Utility isNetworkAvailable]==YES) {
        NSString *strDoctorListPostParameter = [NSString stringWithFormat:@"clinic_id=%@&sp_id=%@&lang=%@",strClinicId,_strSpecialistId,languageCheck, nil];
        NSLog(@"strDoctorListPostParameter%@",strDoctorListPostParameter);
        NSString *strDoctorListingApi=[NSString stringWithFormat:@"%@%@",API,DOCTORLISTING];
         DebugLog(@"The string value:%@",strDoctorListingApi);
        
        [[Singelton getInstance] jsonParseWithPostMethod:^(NSDictionary* testResult){
            
            DebugLog(@"Result %@", testResult);
            if ([[testResult valueForKey:@"success"] boolValue]==1) {
                arrmDoctorListing=[testResult valueForKey:@"list"];
                DebugLog(@"arrmDoctorListing====%@",arrmDoctorListing);
                _tblv_DoctorListing.hidden=NO;
                [_tblv_DoctorListing reloadData];
            }
            else{
                _tblv_DoctorListing.hidden=YES;
                alert=[[SCLAlertView alloc]init];
                [alert showWarning:self title:WARNINGTITLE subTitle:[testResult valueForKey:@"message"] closeButtonTitle:@"OK" duration:0.0f];
                
            }
            self.view.userInteractionEnabled=YES;
            [hud hideAnimated:YES];
            
            
        } andString:strDoctorListingApi andParam:strDoctorListPostParameter];
      
    }
    else{
        alert=[[SCLAlertView alloc]init];
         [alert showWarning:self title:@"Warning" subTitle:@"Network error" closeButtonTitle:@"OK" duration:0.0f];

        
    }
}


- (IBAction)btn_Back_Click:(id)sender {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];

}

#pragma mark TableView Delegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return [arrmDoctorListing count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return 1;//exampleCardLabels.count;
   
    
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
    return 202.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"MediaSearchCell";
    MediaSearchCell *mMediaSearchCell = (MediaSearchCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (mMediaSearchCell == nil){
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"MediaSearchCell" owner:self options:nil];
        mMediaSearchCell = [nibArray objectAtIndex:0];
        
    }
    mMediaSearchCell.contentView.layer.borderWidth=1.0f;
    mMediaSearchCell.contentView.layer.borderColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:204.0f/255.0f alpha:1.0f].CGColor;
    [mMediaSearchCell.lbl_Description1 setText:[[[arrmDoctorListing objectAtIndex:indexPath.section] valueForKey:@"name"] uppercaseString]];
    
    NSString *qualification = [[arrmDoctorListing objectAtIndex:indexPath.section] valueForKey:@"qualification"];
    qualification = [qualification stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    qualification = [qualification stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    mMediaSearchCell.lbl_Description3.text=qualification;
    NSString *specialities = [[arrmDoctorListing objectAtIndex:indexPath.section] valueForKey:@"specialities"];
    specialities = [specialities stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    specialities = [specialities stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    mMediaSearchCell.lbl_Description4.text=specialities;
    
    // mMediaSearchCell.lbl_Description5.text=[[arrmDoctorListing objectAtIndex:indexPath.section] valueForKey:@"case_studies"];
    //mMediaSearchCell.lbl_Description2.text=[[arrmDoctorListing objectAtIndex:indexPath.section] valueForKey:@"email"];
    
    [mMediaSearchCell.imgv_Media_Image sd_setImageWithURL:[NSURL URLWithString:[[arrmDoctorListing objectAtIndex:indexPath.section] valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"doctor_place_holder"] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
    mMediaSearchCell.imgv_Media_Image.layer.shadowColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25f] CGColor];
    mMediaSearchCell.imgv_Media_Image.layer.shadowOffset = CGSizeMake(5, 5.0f);
    mMediaSearchCell.imgv_Media_Image.layer.shadowOpacity = 0.5f;
    mMediaSearchCell.imgv_Media_Image.layer.shadowRadius = 5.0f;
    mMediaSearchCell.imgv_Media_Image.layer.masksToBounds = NO;
    mMediaSearchCell.imgv_Media_Image.layer.cornerRadius = 25.0f;
    mMediaSearchCell.imgv_Media_Image.clipsToBounds=YES;
    mMediaSearchCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return mMediaSearchCell;
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard;// = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
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
    SearchDetalisViewController *mSearchDetalisViewController = [storyboard instantiateViewControllerWithIdentifier:@"SearchDetalisViewController"];
    mSearchDetalisViewController.strDoctorName=[[arrmDoctorListing objectAtIndex:indexPath.section] valueForKey:@"name"];
     mSearchDetalisViewController.strDoctorId=[[arrmDoctorListing objectAtIndex:indexPath.section] valueForKey:@"id"];
     mSearchDetalisViewController.strClinicID=strClinicId;
     mSearchDetalisViewController.strComingFrom=@"SpecificClinic";
     DebugLog(@"strDoctorName====%@ strClinicID %@",mSearchDetalisViewController.strDoctorId,mSearchDetalisViewController.strClinicID);
    [self.navigationController pushViewController:mSearchDetalisViewController animated:NO];
    
}



@end
