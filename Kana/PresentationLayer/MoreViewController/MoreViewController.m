//
//  MoreViewController.m
//  Kana
//
//  Created by Karmick on 12/01/17.
//  Copyright © 2017 Karmick. All rights reserved.
//

#import "MoreViewController.h"
#import "Constant.h"
#import "DefineHeader.h"

@interface MoreViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *arrMoreContent;
    FirstViewController *mFirstViewController;
     NSString *languageCheck;
}
@property (weak, nonatomic) IBOutlet UITableView *tblv_More;
@property (weak, nonatomic) IBOutlet UILabel *lbl_More;

@end

@implementation MoreViewController

#pragma mark - View Life Cycle


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tblv_More.delegate=self;
    _tblv_More.dataSource=self;
//    arrMoreContent=[[NSArray alloc]initWithObjects:@"About Us",@"Testimonials",@"Terms & Conditions",@"Faq",@"Contact Us",@"Change Language", nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"TapOnCell"];
    [[NSUserDefaults standardUserDefaults] synchronize];
     DebugLog(@"NSUserDefaults2%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    
    languageCheck=[[NSUserDefaults standardUserDefaults]objectForKey:@"languageCode"];
    LocalizationSetLanguage(languageCheck);
    _lbl_More.text=LocalizedString(@"MORE");
    
    arrMoreContent=[[NSArray alloc]initWithObjects:LocalizedString(@"CHANGELANGUAGE"), nil];
//     arrMoreContent=[[NSArray alloc]initWithObjects:LocalizedString(@"ABOUTUS"),LocalizedString(@"TESTIMONIALS"),LocalizedString(@"TERMS&CONDITIONS"),LocalizedString(@"FAQ"),LocalizedString(@"CONTACTUS"),LocalizedString(@"CHANGELANGUAGE"), nil];
    [_tblv_More reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark TableView Delegate and DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arrMoreContent count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86.0f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MoreCell *mMoreCell = (MoreCell *)[tableView dequeueReusableCellWithIdentifier:@"MoreCell"];
    if (mMoreCell == nil){
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"MoreCell" owner:self options:nil];
        mMoreCell = [nibArray objectAtIndex:0];
        
    }
    mMoreCell.lbl_More_Content.text=[arrMoreContent objectAtIndex:indexPath.row];
    mMoreCell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return mMoreCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
    if (indexPath.row==0) {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        
        //Using Block
        [alert addButton:LocalizedString(@"ENGLISH") actionBlock:^(void) {
            NSLog(@"1st button tapped");
            DebugLog(@"NSUserDefaults1%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
            
            languageCheck=[[NSUserDefaults standardUserDefaults]objectForKey:@"languageCode"];
            LocalizationSetLanguage(languageCheck);
            NSString *languageCode=@"en";
            [[NSUserDefaults standardUserDefaults]setObject:languageCode forKey:@"languageCode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            mFirstViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"FirstViewController"];
            [self.navigationController pushViewController:mFirstViewController animated:NO];
            
            
            
        }];
        
        //Using Block
        [alert addButton:LocalizedString(@"ARABIC") actionBlock:^(void) {
            NSLog(@"Second button tapped");
            
            languageCheck=[[NSUserDefaults standardUserDefaults]objectForKey:@"languageCode"];
            LocalizationSetLanguage(languageCheck);
            
            NSString *languageCode=@"ar";
            [[NSUserDefaults standardUserDefaults]setObject:languageCode forKey:@"languageCode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            DebugLog(@"NSUserDefaults%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
            mFirstViewController = [[UIStoryboard storyboardWithName:@"Arabic_Storyboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"FirstViewController"];
            [self.navigationController pushViewController:mFirstViewController animated:NO];
            
        }];
        
        //Using Blocks With Validation
        [alert showSuccess:self title:LocalizedString(@"CHANGELANGUAGE") subTitle:LocalizedString(@"SELECTYOURLANGUAGE") closeButtonTitle:LocalizedString(@"CANCEL") duration:0.0f];
    }
    
  /*  if (indexPath.row==0) {
        AboutUsDetailsViewController *mAboutUsDetailsViewController = [storyboard instantiateViewControllerWithIdentifier:@"AboutUsDetailsViewController"];
        mAboutUsDetailsViewController.PageType=@"AboutUs";
        [self.navigationController pushViewController:mAboutUsDetailsViewController animated:NO];
    }
    else if (indexPath.row==1) {
        TestimonialsViewController *mTestimonialsViewController= [storyboard instantiateViewControllerWithIdentifier:@"TestimonialsViewController"];
        [self.navigationController pushViewController:mTestimonialsViewController animated:NO];
    }
    else if (indexPath.row==2) {
        AboutUsDetailsViewController *mAboutUsDetailsViewController = [storyboard instantiateViewControllerWithIdentifier:@"AboutUsDetailsViewController"];
        mAboutUsDetailsViewController.PageType=@"TermsCondition";
        [self.navigationController pushViewController:mAboutUsDetailsViewController animated:NO];
    }
    else if (indexPath.row==3) {
        FaqViewController *mFaqViewController= [storyboard instantiateViewControllerWithIdentifier:@"FaqViewController"];
        [self.navigationController pushViewController:mFaqViewController animated:NO];
    }
    else if (indexPath.row==4){
        
        AboutUsViewController *mAboutUsViewController = [storyboard instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
        mAboutUsViewController.strHeader=[arrMoreContent objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:mAboutUsViewController animated:NO];
    }
    else
    {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        
        //Using Block
        [alert addButton:LocalizedString(@"ENGLISH") actionBlock:^(void) {
            NSLog(@"1st button tapped");
             DebugLog(@"NSUserDefaults1%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
           
            languageCheck=[[NSUserDefaults standardUserDefaults]objectForKey:@"languageCode"];
            LocalizationSetLanguage(languageCheck);
            NSString *languageCode=@"en";
            [[NSUserDefaults standardUserDefaults]setObject:languageCode forKey:@"languageCode"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            mFirstViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"FirstViewController"];
            [self.navigationController pushViewController:mFirstViewController animated:NO];
           
        

        }];
        
        //Using Block
         [alert addButton:LocalizedString(@"ARABIC") actionBlock:^(void) {
             NSLog(@"Second button tapped");
         
         languageCheck=[[NSUserDefaults standardUserDefaults]objectForKey:@"languageCode"];
         LocalizationSetLanguage(languageCheck);
         
         NSString *languageCode=@"ar";
         [[NSUserDefaults standardUserDefaults]setObject:languageCode forKey:@"languageCode"];
         [[NSUserDefaults standardUserDefaults] synchronize];
             
         DebugLog(@"NSUserDefaults%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
         mFirstViewController = [[UIStoryboard storyboardWithName:@"Arabic_Storyboard" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"FirstViewController"];
            [self.navigationController pushViewController:mFirstViewController animated:NO];
      
        }];
        
        //Using Blocks With Validation
        [alert showSuccess:self title:LocalizedString(@"CHANGELANGUAGE") subTitle:LocalizedString(@"SELECTYOURLANGUAGE") closeButtonTitle:LocalizedString(@"CANCEL") duration:0.0f];
    }
    */
}


@end
