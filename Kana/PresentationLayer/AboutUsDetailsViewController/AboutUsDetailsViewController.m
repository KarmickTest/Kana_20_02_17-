//
//  AboutUsDetailsViewController.m
//  Kana
//
//  Created by Karmick on 03/02/17.
//  Copyright © 2017 Karmick. All rights reserved.
//

#import "AboutUsDetailsViewController.h"
#import "Constant.h"
#import "DefineHeader.h"

@interface AboutUsDetailsViewController ()<UIWebViewDelegate>
{
     MBProgressHUD *hud;
    SCLAlertView *alert;
     NSString *languageCheck;
    
}
@property (weak, nonatomic) IBOutlet UILabel *PageTitleLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webv_AboutUs;

@end

@implementation AboutUsDetailsViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    languageCheck=[[NSUserDefaults standardUserDefaults]objectForKey:@"languageCode"];
    LocalizationSetLanguage(languageCheck);
    
    if ([self.PageType isEqualToString:@"AboutUs"])
    {
        self.PageTitleLabel.text=LocalizedString(@"ABOUTUS");
    }
    else if ([self.PageType isEqualToString:@"TermsCondition"])
    {
        self.PageTitleLabel.text=LocalizedString(@"TERMS&CONDITIONS");
    }
    
    
    
    self.webv_AboutUs.delegate=self;
     hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self GetAboutDetalis];
}

#pragma mark - Call web Service

-(void)GetAboutDetalis{
    
    //hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    if ([Utility isNetworkAvailable]==YES) {
         languageCheck=[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
        DebugLog(@"languageCheck%@",languageCheck);
        NSString *strClinicListApi;
        NSString *Keyvalue;
        if ([self.PageType isEqualToString:@"AboutUs"])
        {
            strClinicListApi=[NSString stringWithFormat:@"%@%@",API,ABOUTUS];
            DebugLog(@"The string value:%@",strClinicListApi);
            
            Keyvalue=[NSString stringWithFormat:@"cms_key=%@",@"About-us"];
        }
        else if ([self.PageType isEqualToString:@"TermsCondition"])
        {
            strClinicListApi=[NSString stringWithFormat:@"%@%@",API,ABOUTUS];
            DebugLog(@"The string value:%@",strClinicListApi);
            
            Keyvalue=[NSString stringWithFormat:@"cms_key=%@",@"Terms-and-Conditions"];
        }
        
        
        [[Singelton getInstance] jsonParseWithPostMethod:^(NSDictionary *result)
         {
             DebugLog(@"The value:%@",result);
             
             if ([[result valueForKey:@"success"] boolValue]==1)
             {
                 NSString *AboutusHTMLdata=[result valueForKey:@"main_body"];
                 
                 
                 [self.webv_AboutUs loadHTMLString:AboutusHTMLdata baseURL:nil];
                  //[hud hideAnimated:YES];
             }
             else
             {
                 [alert showWarning:self title:@"Warning" subTitle:@"Network error" closeButtonTitle:@"OK" duration:0.0f];
                 [hud hideAnimated:YES];
             }
             
             
         } andString:strClinicListApi andParam:Keyvalue];
        
        
        
    }
    else{
        [alert showWarning:self title:@"Warning" subTitle:@"Network error" closeButtonTitle:@"OK" duration:0.0f];
    }
    
}



#pragma mark - Optional UIWebViewDelegate delegate methods

- (BOOL)webView:(UIWebView* )webView shouldStartLoadWithRequest:(NSURLRequest* )request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"test");
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //    NSLog(@"test2");
    
    //    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    NSLog(@"test3");
    [hud hideAnimated:YES];
    //    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

- (void)webView:(UIWebView* )webView didFailLoadWithError:(NSError* )error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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



@end
