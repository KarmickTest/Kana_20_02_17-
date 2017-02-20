//
//  AboutUsViewController.m
//  Kana
//
//  Created by Karmick on 12/01/17.
//  Copyright © 2017 Karmick. All rights reserved.
//

#import "AboutUsViewController.h"
#import "DefineHeader.h"
#import "Constant.h"
#import <MessageUI/MessageUI.h>

@interface AboutUsViewController ()<UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>{
    NSMutableArray *arrmAboutUsContent;
    NSMutableArray *arrmAboutUsContent1;
    SCLAlertView *alert;
    MBProgressHUD *hud;
    NSString *languageCheck;
    NSString *Description,*PhoneNumber,*EmailId;
    
}
@property (weak, nonatomic) IBOutlet UILabel *lbl_Header;
@property (weak, nonatomic) IBOutlet UITableView *tblv_About_Table;

@end

@implementation AboutUsViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tblv_About_Table.delegate=self;
    _tblv_About_Table.dataSource=self;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    
    languageCheck=[[NSUserDefaults standardUserDefaults]objectForKey:@"languageCode"];    LocalizationSetLanguage(languageCheck);
    
     _lbl_Header.text=[_strHeader uppercaseString];
    arrmAboutUsContent=[[NSMutableArray alloc]initWithObjects:LocalizedString(@"RATEUSONAPPSTORE"),LocalizedString(@"CALLUS"),LocalizedString(@"MAILUS"), nil];
    arrmAboutUsContent1=[[NSMutableArray alloc]initWithObjects:@"RatingImage",@"Call",@"Mail", nil];
   
    
    [self GetContactUs];
}

#pragma mark - Call Web Service

-(void)GetContactUs
{
    if ([Utility isNetworkAvailable]==YES) {
        /**********Custom loader****************/
         languageCheck=[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
        DebugLog(@"languageCheck%@",languageCheck);
        hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        NSString *strClinicListApi=[NSString stringWithFormat:@"%@%@",API,CONTACTUS];
        DebugLog(@"The string value:%@",strClinicListApi);
        
        [[Singelton getInstance] jsonparse:^(NSDictionary* testResult){
            DebugLog(@"ClinicList====%@",testResult);
            if ([[testResult valueForKey:@"success"] boolValue]==1) {
                // DebugLog(@"arrmHomeContent====%@",arrmHomeContent);
                Description=[testResult valueForKey:@"main_body"];
                PhoneNumber=[testResult valueForKey:@"PhoneNumber"];
                EmailId=[testResult valueForKey:@"email"];
                [self.tblv_About_Table reloadData];
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

#pragma mark Button Action

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    else{
        return [arrmAboutUsContent count];//exampleCardLabels.count;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 350.0f;
    }
    else{
        return 66.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        AboutUsCell1 *mAboutUsCell1 = (AboutUsCell1 *)[tableView dequeueReusableCellWithIdentifier:@"AboutUsCell1"];
        
        if (mAboutUsCell1 == nil){
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"AboutUsCell1" owner:self options:nil];
            mAboutUsCell1 = [nibArray objectAtIndex:0];
        }
        
        
        NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                initWithData: [Description dataUsingEncoding:NSUnicodeStringEncoding]
                                                options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                documentAttributes: nil
                                                error: nil
                                                ];
        
        
        mAboutUsCell1.txtv_Description.attributedText=attributedString;
        
        mAboutUsCell1.selectionStyle = UITableViewCellSelectionStyleNone;
        return mAboutUsCell1;
    }
    else{
        
        AboutUsCell2 *mAboutUsCell2 = (AboutUsCell2 *)[tableView dequeueReusableCellWithIdentifier:@"AboutUsCell2"];
        
        if (mAboutUsCell2 == nil) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"AboutUsCell2" owner:self options:nil];
            mAboutUsCell2 = [nibArray objectAtIndex:0];
        }
        
        
        
        
        if (indexPath.row==2) {
            mAboutUsCell2.vw_seperatorView.hidden=YES;
        }
        else{
            mAboutUsCell2.vw_seperatorView.hidden=NO;
            
        }
        mAboutUsCell2.imgv_Social_Image.image= [UIImage imageNamed:[NSString stringWithFormat:@"%@",[arrmAboutUsContent1 objectAtIndex:indexPath.row]]];
        mAboutUsCell2.lbl_Social_Media.text=[arrmAboutUsContent objectAtIndex:indexPath.row];
        mAboutUsCell2.selectionStyle = UITableViewCellSelectionStyleNone;
        return mAboutUsCell2;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            NSLog(@"Click");
            NSString * appId = @"";
            if (appId.length==0) {
                 alert=[[SCLAlertView alloc]init];
                [alert showWarning:self title:WARNINGTITLE subTitle:@"No data available" closeButtonTitle:@"OK" duration:0.0f];
            }
            else{
                
                NSString * theUrl = [NSString  stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software",appId];
                if ([[UIDevice currentDevice].systemVersion integerValue] > 6)
                    theUrl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appId];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:theUrl]];
                
            }
            
        }
        else if (indexPath.row==1){
            NSLog(@"Click1");
            NSString *strPhoneNo = PhoneNumber;
            NSString *cleanedString = [[strPhoneNo componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
            NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *phoneURLString = [NSString stringWithFormat:@"telprompt:%@", escapedPhoneNumber];
            NSURL *phoneURL = [NSURL URLWithString:phoneURLString];
            
            if ([[UIApplication sharedApplication] canOpenURL:phoneURL]) {
                [[UIApplication sharedApplication] openURL:phoneURL];
            }
        }
        else{
            NSLog(@"Click3");
            MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
            if ([MFMailComposeViewController canSendMail]) {
                mail.mailComposeDelegate = self;
                [mail setSubject:@"Tell us what you think"];
                [mail setMessageBody:@"Thanks for installing Kana:" isHTML:NO];
                [mail setToRecipients:@[EmailId]];
                
                [self presentViewController:mail animated:YES completion:NULL];
            }
        }
    }
}

#pragma mark mailCompose delegates

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            
            
            
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            
            
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            
            
            
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    
    
}

@end
