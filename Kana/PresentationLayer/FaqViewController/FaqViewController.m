//
//  FaqViewController.m
//  Kana
//
//  Created by Karmick on 03/02/17.
//  Copyright © 2017 Karmick. All rights reserved.
//

#import "FaqViewController.h"
#import "Constant.h"
#import "DefineHeader.h"

@interface FaqViewController ()<UITableViewDelegate,UITableViewDataSource>{
    MBProgressHUD *hud;
    NSMutableArray *arrmFaqContent;
    SCLAlertView *alert;
    UIView *vwMaskView;
    NSString *languageCheck;
}
@property (weak, nonatomic) IBOutlet UITableView *tblv_Faq_Table;
@property (weak, nonatomic) IBOutlet UIView *vw_Show_Answer;
@property (weak, nonatomic) IBOutlet UITextView *txtv_Answer;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Question;
@property (weak, nonatomic) IBOutlet UIButton *btn_Close;

@end

@implementation FaqViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    languageCheck=[[NSUserDefaults standardUserDefaults]objectForKey:@"languageCode"];
    LocalizationSetLanguage(languageCheck);
    
    arrmFaqContent=[[NSMutableArray alloc]init];
     alert= [[SCLAlertView alloc] init];
    _tblv_Faq_Table.delegate=self;
    _tblv_Faq_Table.dataSource=self;
    _vw_Show_Answer.hidden=YES;
    _vw_Show_Answer.layer.cornerRadius=5.0f;
    _btn_Close.layer.cornerRadius=5.0f;
    _txtv_Answer.contentInset = UIEdgeInsetsMake(-9.0,-7.0,0,0.0);
    vwMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [vwMaskView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5]];
    [self.view addSubview:vwMaskView];
     vwMaskView.hidden=YES;
    _lbl_Question.layer.cornerRadius=5.0f;
    _txtv_Answer.layer.cornerRadius=5.0f;
    
    [self getFaqList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    vwMaskView.frame=CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
    
    [self.tblv_Faq_Table reloadData];
}
#pragma mark -  Call Web Service

-(void)getFaqList{
     languageCheck=[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     DebugLog(@"languageCheck%@",languageCheck);
    if ([Utility isNetworkAvailable]==YES) {
        /**********Custom loader****************/
        hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        NSString *strFaqApi=[NSString stringWithFormat:@"%@%@",API,FAQ];
        DebugLog(@"The string value:%@",strFaqApi);
        
        [[Singelton getInstance] jsonparse:^(NSDictionary* testResult){
            DebugLog(@"FAQLIST ====%@",testResult);
            if ([[testResult valueForKey:@"success"] boolValue]==1) {
                arrmFaqContent=[testResult valueForKey:@"list"];
                DebugLog(@"arrmFaqContent====%@",arrmFaqContent);
                 [_tblv_Faq_Table reloadData];
            }
            else{
                [alert showWarning:self title:@"Oops!" subTitle:[testResult valueForKey:@"message"] closeButtonTitle:@"OK" duration:0.0f];
                
            }
           
            self.view.userInteractionEnabled=YES;
            [hud hideAnimated:YES];
            
        } andString:strFaqApi];
    }
    else{
        [alert showWarning:self title:@"Warning" subTitle:@"Network error" closeButtonTitle:@"OK" duration:0.0f];
    }
}

#pragma mark Button Action

- (IBAction)btn_Close_Click:(id)sender {
  _vw_Show_Answer.alpha =0.0;
  vwMaskView.alpha=0.0;/* set the frame here */
  vwMaskView.hidden=YES;
  _vw_Show_Answer.hidden=YES;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *arrmRow=[[arrmFaqContent objectAtIndex:section]valueForKey:@"q_a"] ;
    return [arrmRow count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [arrmFaqContent count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tblv_Faq_Table.frame.size.width, 44)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:16]];
    label.text = [NSString stringWithFormat:@"%@",[[arrmFaqContent objectAtIndex:section]valueForKey:@"category"]];
    
    if ([languageCheck isEqualToString:@"en"])
    {
        label.textAlignment = NSTextAlignmentLeft;
    }
    else
    {
        label.textAlignment = NSTextAlignmentRight;
    }
    
    
    
    UIView *sectionHeader = [[UIView alloc] init];
    sectionHeader.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:0.04f];
   // sectionHeader.layer.shadowColor = [[UIColor blackColor] CGColor];
    //sectionHeader.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    //sectionHeader.layer.shadowRadius = 5.0f;
   // sectionHeader.layer.shadowOpacity = 1.0f;
    [sectionHeader addSubview:label];
    
    return sectionHeader;
        
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
       NSMutableArray *arrmRow=[[arrmFaqContent objectAtIndex:indexPath.section]valueForKey:@"q_a"] ;
    DebugLog(@"arrmRow%@",arrmRow);
        FaqCell *mFaqCell = (FaqCell *)[tableView dequeueReusableCellWithIdentifier:@"FaqCell"];
        
        if (mFaqCell == nil){
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"FaqCell" owner:self options:nil];
            mFaqCell = [nibArray objectAtIndex:0];
        }
        mFaqCell.lbl_Faq_Question.text=[[arrmRow objectAtIndex:indexPath.row]valueForKey:@"title"];
        mFaqCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return mFaqCell;
        
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   NSMutableArray *arrmRow=[[arrmFaqContent objectAtIndex:indexPath.section]valueForKey:@"q_a"] ;
    [vwMaskView addSubview:_vw_Show_Answer];
    [_vw_Show_Answer bringSubviewToFront:self.view];
    if(vwMaskView.hidden == true && _vw_Show_Answer.hidden==true)
    {
        vwMaskView.hidden=NO;
      _vw_Show_Answer.hidden = NO;
        [UIView animateWithDuration:0.5   delay:0.0 options:UIViewAnimationCurveEaseOut
         animations:^(void) {
         _vw_Show_Answer.alpha =1.0;
         vwMaskView.alpha=1.0;
     }
     completion:NULL];
    }
    
      _lbl_Question.text=[[arrmRow objectAtIndex:indexPath.row]valueForKey:@"title"];
     _txtv_Answer.text=[[arrmRow objectAtIndex:indexPath.row]valueForKey:@"description"];
}

@end
