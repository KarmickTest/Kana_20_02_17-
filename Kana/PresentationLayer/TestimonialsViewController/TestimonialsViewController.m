//
//  TestimonialsViewController.m
//  Kana
//
//  Created by Karmick on 06/02/17.
//  Copyright © 2017 Karmick. All rights reserved.
//

#import "TestimonialsViewController.h"
#import "DefineHeader.h"
#import "Constant.h"

@interface TestimonialsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    MBProgressHUD *hud;
    SCLAlertView *alert;
    NSMutableArray *arrmTestimonials;
    NSString *languageCheck;
}
@property (weak, nonatomic) IBOutlet UITableView *tblv_Testimonials;

@end

@implementation TestimonialsViewController

#pragma mark -  View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
     alert=[[SCLAlertView alloc]init];
    _tblv_Testimonials.delegate=self;
    _tblv_Testimonials.dataSource=self;
    arrmTestimonials=[[NSMutableArray alloc]init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    languageCheck =[[NSUserDefaults standardUserDefaults]objectForKey:@"languageCode"];
    LocalizationSetLanguage(languageCheck);
    [self GetTestimonialsList];
}

#pragma mark -  Button Action

- (IBAction)btn_Back_Click:(id)sender {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -  Call Web Service

-(void)GetTestimonialsList{
     languageCheck=[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
    DebugLog(@"languageCheck%@",languageCheck);
    if ([Utility isNetworkAvailable]==YES) {
        /**********Custom loader****************/
        hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        NSString *strTestimonbialsApi=[NSString stringWithFormat:@"%@%@",API,TESTIMONIALS];
        DebugLog(@"The string value:%@",strTestimonbialsApi);
        
        [[Singelton getInstance] jsonparse:^(NSDictionary* testResult){
            DebugLog(@"Testimonials====%@",testResult);
            if ([[testResult valueForKey:@"success"] boolValue]==1) {
                arrmTestimonials=[testResult valueForKey:@"list"];
                DebugLog(@"arrmTestimonials====%@",arrmTestimonials);
            }
            else{
                [alert showWarning:self title:@"Oops!" subTitle:[testResult valueForKey:@"message"] closeButtonTitle:@"OK" duration:0.0f];
            }
            
            self.view.userInteractionEnabled=YES;
            [self.tblv_Testimonials reloadData];
            [hud hideAnimated:YES];
            
        } andString:strTestimonbialsApi];
    }
    else{
        [alert showWarning:self title:@"Warning" subTitle:@"Network error" closeButtonTitle:@"OK" duration:0.0f];
    }
}

#pragma mark TableView Delegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return arrmTestimonials.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1.0f;//exampleCardLabels.count;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0.01f;
    }
    else{
        return 10.0f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 172.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"MediaSearchCell";
    MediaSearchCell *mMediaSearchCell = (MediaSearchCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (mMediaSearchCell == nil){
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"MediaSearchCell" owner:self options:nil];
        mMediaSearchCell = [nibArray objectAtIndex:0];
    }
    DebugLog(@"image%@",[arrmTestimonials valueForKey:@"image"]);
    mMediaSearchCell.lbl_Description1.text=[[arrmTestimonials objectAtIndex:indexPath.section] valueForKey:@"title"];
    mMediaSearchCell.lbl_Description2.text=[[arrmTestimonials objectAtIndex:indexPath.section] valueForKey:@"description"];
     mMediaSearchCell.lbl_Date.text=[[arrmTestimonials objectAtIndex:indexPath.section] valueForKey:@"added_date"];
    [mMediaSearchCell.imgv_Media_Image sd_setImageWithURL:[NSURL URLWithString:[[arrmTestimonials objectAtIndex:indexPath.section] valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"placeholder"] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
    mMediaSearchCell.imgv_Media_Image.clipsToBounds=YES;
    mMediaSearchCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return mMediaSearchCell;
    
}



@end
