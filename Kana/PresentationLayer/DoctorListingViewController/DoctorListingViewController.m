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
    alert= [[SCLAlertView alloc] init];
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
                
                [alert showWarning:self title:WARNINGTITLE subTitle:[testResult valueForKey:@"message"] closeButtonTitle:@"OK" duration:0.0f];
                
            }
            self.view.userInteractionEnabled=YES;
            [hud hideAnimated:YES];
            
            
        } andString:strDoctorListingApi andParam:strDoctorListPostParameter];
      
    }
    else{
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
    mMediaSearchCell.lbl_Description1.text=[[arrmDoctorListing objectAtIndex:indexPath.section] valueForKey:@"name"];
    mMediaSearchCell.lbl_Description2.text=[[arrmDoctorListing objectAtIndex:indexPath.section] valueForKey:@"email"];
    mMediaSearchCell.lbl_Description3.text=[[arrmDoctorListing objectAtIndex:indexPath.section] valueForKey:@"qualification"];
    mMediaSearchCell.lbl_Description4.text=[[arrmDoctorListing objectAtIndex:indexPath.section] valueForKey:@"specialities"];
    mMediaSearchCell.lbl_Description5.text=[[arrmDoctorListing objectAtIndex:indexPath.section] valueForKey:@"case_studies"];
    [mMediaSearchCell.imgv_Media_Image sd_setImageWithURL:[NSURL URLWithString:[[arrmDoctorListing objectAtIndex:indexPath.section] valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"doctor_place_holder"] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
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
