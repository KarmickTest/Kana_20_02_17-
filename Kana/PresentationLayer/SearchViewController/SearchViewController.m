//
//  SearchViewController.m
//  Kana
//
//  Created by Karmick on 11/01/17.
//  Copyright © 2017 Karmick. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "DefineHeader.h"
#import "Constant.h"

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UITabBarDelegate>
{
    SearchTableViewCell *cell;
    MBProgressHUD *hud;
    SCLAlertView *alert;
    NSMutableArray *arrmSearch;
    NSString *languageCheck;
    NSUserDefaults *userDefaultCellTapData;

}
@property (weak, nonatomic) IBOutlet UILabel *lbl_NoDataFound;

@end

@implementation SearchViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
     alert=[[SCLAlertView alloc]init];
    self.SearchTableView.delegate=self;
    self.SearchTableView.dataSource=self;
    self.SearchTableView.hidden=YES;
    [self.SearchTableView reloadData];
    userDefaultCellTapData=[NSUserDefaults standardUserDefaults];
    
    self.SearchBarView.delegate=self;
    self.SearchBarView.layer.borderWidth = 1;
    self.SearchBarView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.SearchBarView.layer.cornerRadius=5.0f;
    self.SearchBarView.clipsToBounds=YES;
    
    self.TableViewBackroundView.layer.cornerRadius=5.0f;
    self.TableViewBackroundView.clipsToBounds=YES;
    _lbl_NoDataFound.hidden=YES;
    [userDefaultCellTapData setObject:@"No" forKey:@"TapOnCell"];
    [userDefaultCellTapData synchronize];
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    NSString *strCellTapData=[userDefaultCellTapData objectForKey:@"TapOnCell"];
    DebugLog(@"strCellTapData%@",strCellTapData);
    if ([strCellTapData isEqualToString:@"No"]) {
        _SearchTableView.hidden=YES;
        _SearchBarView.text=@"";
        _lbl_NoDataFound.hidden=YES;
    }
   
   
    languageCheck =[[NSUserDefaults standardUserDefaults]objectForKey:@"languageCode"];
    LocalizationSetLanguage(languageCheck);
    
    if ([languageCheck isEqualToString:@"ar"]){
        UITextField *searchField;
        for (UIView *subview in self.SearchBarView.subviews){
            //this will work in iOS 7
            for (id sub in subview.subviews) {
            if([NSStringFromClass([sub class]) isEqualToString:@"UISearchBarTextField"]){
            [sub setTextAlignment:NSTextAlignmentRight];
            }
            }
            //this will work for less than iOS 7
            if ([subview isKindOfClass:[UITextField class]]) {
            searchField = (UITextField *)subview;
            break;
            }
        }
        //for less than iOS 7
        if (searchField) {
            searchField.textAlignment = NSTextAlignmentRight;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -  UISearchBar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *searchText=searchBar.text;
    DebugLog(@"searchText%@",searchText);
     [self GetSearchList:searchText];
}

#pragma mark -  Call Web Service

-(void)GetSearchList :(NSString *)str{
     languageCheck=[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
    DebugLog(@"languageCheck%@",languageCheck);
    if ([Utility isNetworkAvailable]==YES) {
        /**********Custom loader****************/
        NSString *strPostParameter=[NSString stringWithFormat:@"search=%@",str];
        DebugLog(@"strPostParameter:%@",strPostParameter);
        hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        NSString *strTestimonialsApi=[NSString stringWithFormat:@"%@%@",API,SEARCH];
        DebugLog(@"The string value:%@",strTestimonialsApi);
       
        [[Singelton getInstance] jsonParseWithPostMethod:^(NSDictionary* testResult){
            DebugLog(@"Testimonials====%@",testResult);
            self.view.userInteractionEnabled=YES;
            [hud hideAnimated:YES];
            if ([[testResult valueForKey:@"success"] boolValue]==1) {
                arrmSearch=[[NSMutableArray alloc]init];
                arrmSearch=[testResult valueForKey:@"list"];
                DebugLog(@"arrmSearch====%@",arrmSearch);
                self.SearchTableView.hidden=NO;
                _lbl_NoDataFound.hidden=YES;
                [self.SearchTableView reloadData];
            }
            else{
                _lbl_NoDataFound.hidden=NO;
                self.SearchTableView.hidden=YES;
                
            }
        }andString:strTestimonialsApi andParam:strPostParameter];
    }
    else{
        [alert showWarning:self title:@"Warning" subTitle:@"Network error" closeButtonTitle:@"OK" duration:0.0f];
    }
}

#pragma mark Button ACtion
- (void)firstButton
{
    NSLog(@"First button tapped");
}

#pragma mark TableView Delegate and DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return arrmSearch.count;//exampleCardLabels.count;
    
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section==0) {
//        return 0.01f;
//    }
//    else{
//        return 10.0f;
//    }
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *headerView = [[UIView alloc] init];
//    headerView.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
//    return headerView;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 196.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"MediaSearchCell";
    MediaSearchCell *mMediaSearchCell = (MediaSearchCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (mMediaSearchCell == nil){
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"MediaSearchCell" owner:self options:nil];
        mMediaSearchCell = [nibArray objectAtIndex:0];
        
    }
    mMediaSearchCell.lbl_Description1.text=[[arrmSearch objectAtIndex:indexPath.row] valueForKey:@"doctorname"];
    mMediaSearchCell.lbl_Description2.text=[[arrmSearch objectAtIndex:indexPath.row] valueForKey:@"email"];
    mMediaSearchCell.lbl_Description3.text=[[arrmSearch objectAtIndex:indexPath.row] valueForKey:@"qualification"];
    mMediaSearchCell.lbl_Description4.text=[[arrmSearch objectAtIndex:indexPath.row] valueForKey:@"specialities"];
    mMediaSearchCell.lbl_Description5.text=[[arrmSearch objectAtIndex:indexPath.row] valueForKey:@"case_studies"];
   [mMediaSearchCell.imgv_Media_Image sd_setImageWithURL:[NSURL URLWithString:[[arrmSearch objectAtIndex:indexPath.row] valueForKey:@"profile_pic"]] placeholderImage:[UIImage imageNamed:@"doctor_place_holder"] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
    mMediaSearchCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return mMediaSearchCell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
    SearchDetalisViewController *mSearchDetalisViewController = [storyboard instantiateViewControllerWithIdentifier:@"SearchDetalisViewController"];
    [userDefaultCellTapData setObject:@"Yes" forKey:@"TapOnCell"];
    [userDefaultCellTapData synchronize];
     mSearchDetalisViewController.strDoctorName=[[arrmSearch objectAtIndex:indexPath.row] valueForKey:@"doctorname"];
    mSearchDetalisViewController.strDoctorId=[[arrmSearch objectAtIndex:indexPath.row] valueForKey:@"doctorId"];
    mSearchDetalisViewController.strClinicID=@"";
    DebugLog(@"strDoctorName====%@ strClinicID %@",mSearchDetalisViewController.strDoctorId,mSearchDetalisViewController.strClinicID);

    [self.navigationController pushViewController:mSearchDetalisViewController animated:NO];
}





@end
