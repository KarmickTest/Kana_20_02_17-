//
//  SearchDetalisViewController.m
//  Kana
//
//  Created by Sayan  on 12/01/17.
//  Copyright © 2017 Karmick. All rights reserved.
//

#import "SearchDetalisViewController.h"
#import "DectorDetalisCollectionViewCell.h"
#import "DefineHeader.h"
#import "Constant.h"
#import "LocalizeHelper.h"



@interface SearchDetalisViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDataSource,UITableViewDelegate>
{
    DectorDetalisCollectionViewCell *cell;
    NSIndexPath *scrollindex;
    
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
    
    NSDate *_dateSelected;
    
    MBProgressHUD *hud;
    SCLAlertView *alert;
    NSString *languageCheck;
    NSMutableArray *arrmCliniclocation;
    NSMutableArray *arrmAvailableDate;
    NSMutableArray *arrmTrimAvailableDate;
    
    DoctorDetalisCell *cell2;
    LocationTableCell *mLocationTableCell;
    UIToolbar *toolbar_DatePickerView;
    UIPickerView *pckvMonthAndYearPicker;
    UIView *viewPicker;
}
@property (weak, nonatomic) IBOutlet UILabel *lbl_Doctor_Details;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_Right_Arrow;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Doctor_Location;
@property (weak, nonatomic) IBOutlet UIView *vw_Location_PopUp;
@property (weak, nonatomic) IBOutlet UITableView *tblv_Location_Table;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Choose_Location;
@property (weak, nonatomic) IBOutlet UIButton *btn_Cancel;
@property (weak, nonatomic) IBOutlet UIView *vw_Mask_View;
@property (weak, nonatomic) IBOutlet UIButton *btn_Choose_Location;

- (IBAction)CalenderNextBtn:(id)sender;
- (IBAction)CalenderPreviousBtn:(id)sender;


@end

@implementation SearchDetalisViewController

#pragma mark -  View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.CollectionViewDoctorDetalis.delegate=self;
    self.CollectionViewDoctorDetalis.dataSource=self;
    [self.CollectionViewDoctorDetalis reloadData];
    
    self.HospitalView.layer.cornerRadius=5.0f;
    self.HospitalView.clipsToBounds=YES;
    
    self.CalenderBackView.layer.cornerRadius=5.0f;
    self.CalenderBackView.clipsToBounds=YES;
    
    self.vw_Location_PopUp.layer.cornerRadius=5.0f;
    self.vw_Location_PopUp.clipsToBounds=YES;
    
    self.btn_Cancel.layer.cornerRadius=5.0f;
    self.btn_Cancel.clipsToBounds=YES;
    
    
    self.DoctorTimeTableView.delegate=self;
    self.DoctorTimeTableView.dataSource=self;
    self.DoctorTimeTableView.separatorColor=[UIColor clearColor];
    [self.DoctorTimeTableView reloadData];
    arrmCliniclocation=[[NSMutableArray alloc]init];
    arrmAvailableDate=[[NSMutableArray alloc]init];
    arrmTrimAvailableDate=[[NSMutableArray alloc]init];
    _vw_Mask_View.hidden=YES;
    _vw_Location_PopUp.hidden=YES;
    
    _tblv_Location_Table.delegate=self;
    _tblv_Location_Table.dataSource=self;
    _tblv_Location_Table.tag=1002;
//    _calendarManager = [JTCalendarManager new];
//    _calendarManager.delegate = self;
//    
//    // Generate random events sort by date using a dateformatter for the demonstration
//    //[self createRandomEvents];
//    
//    // Create a min and max date for limit the calendar, optional
//    [self createMinAndMaxDate];
//    
//    [_calendarManager setMenuView:_calendarMenuView];
//    [_calendarManager setContentView:_calendarContentView];
//    [_calendarManager setDate:_todayDate];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    _lbl_Doctor_Details.text=_strDoctorName;
    if ([_strComingFrom isEqualToString:@"SpecificClinic"]) {
        _imgv_Right_Arrow.hidden=YES;
        _btn_Choose_Location.userInteractionEnabled=NO;
    }
    else{
        _imgv_Right_Arrow.hidden=NO;
        _btn_Choose_Location.userInteractionEnabled=YES;
    }
    [self getDoctorDetails];
}

#pragma mark -  Call Web Service

-(void)getDoctorDetails{
    
    if ([Utility isNetworkAvailable]==YES) {
        /**********Custom loader****************/
        languageCheck=[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
        DebugLog(@"languageCheck%@",languageCheck);
        hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        NSString *strDoctorDetailsApi=[NSString stringWithFormat:@"%@%@",API,DOCTORDETAILS];
         DebugLog(@"The string value:%@",strDoctorDetailsApi);
        NSString *Keyvalue=[NSString stringWithFormat:@"doctor_id=%@&clinic_id=%@&lang=%@",_strDoctorId,_strClinicID, languageCheck,nil];
        DebugLog(@"The Keyvalue:%@",Keyvalue);
        
        [[Singelton getInstance] jsonParseWithPostMethod:^(NSDictionary *result)
         {
             DebugLog(@"The value:%@",result);
             [hud hideAnimated:YES];
             if ([[result valueForKey:@"success"] boolValue]==1)
             {
                
                [cell.imgv_Dr_Image sd_setImageWithURL:[NSURL URLWithString:[result valueForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"doctor_place_holder"] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
                 cell.lbl_Dr_Name.text=[result valueForKey:@"name"];
                 cell.lbl_Email.text=[result valueForKey:@"email"];
                 cell.Lbl_Specialities.text=[result valueForKey:@"specialities"];
                 cell.lbl_Qualification.text=[result valueForKey:@"qualification"];
                 arrmCliniclocation=[result valueForKey:@"Cliniclocation"];
                 DebugLog(@"arrmCliniclocation%@",arrmCliniclocation);
                 
             if (arrmCliniclocation.count == 1) {
                 arrmTrimAvailableDate=[[arrmCliniclocation objectAtIndex:0]valueForKey:@"availabledate"];
                 DebugLog(@"arrmTrimAvailableDate%@",arrmTrimAvailableDate);
                 _lbl_Doctor_Location.text=[[arrmCliniclocation objectAtIndex:0]valueForKey:@"location"];
                 for (int i=0; i<arrmTrimAvailableDate.count; i++) {
                 NSString *str=[NSString stringWithFormat:@"%@",[[arrmTrimAvailableDate valueForKey:@"time"] objectAtIndex:i]];
                 if (str.length>0) {
                 DebugLog(@"str====%@",str);
                 [arrmAvailableDate addObject:[arrmTrimAvailableDate objectAtIndex:i]];
                 DebugLog(@"arrmAvailableDate====%@",arrmAvailableDate);
                        
                 [_DoctorTimeTableView reloadData];
                }
                }
                }
             else{
                  _lbl_Doctor_Location.text=[[arrmCliniclocation objectAtIndex:0]valueForKey:@"location"];
                  for (int i=0; i<arrmCliniclocation.count; i++) {
                      arrmTrimAvailableDate=[[arrmCliniclocation objectAtIndex:0]valueForKey:@"availabledate"];
                  }
                 DebugLog(@"arrmTrimAvailableDate%@",arrmTrimAvailableDate);
                 for (int i=0; i<arrmTrimAvailableDate.count; i++) {
                     NSString *str=[NSString stringWithFormat:@"%@",[[arrmTrimAvailableDate valueForKey:@"time"] objectAtIndex:i]];
                     if (str.length>0) {
                         DebugLog(@"str====%@",str);
                         [arrmAvailableDate addObject:[arrmTrimAvailableDate objectAtIndex:i]];
                         DebugLog(@"arrmAvailableDate====%@",arrmAvailableDate);
                         
                         [_DoctorTimeTableView reloadData];
                     }
                 }
                 
             }
             }
             else
             {
                 [alert showWarning:self title:@"Warning" subTitle:@"Network error" closeButtonTitle:@"OK" duration:0.0f];
                 [hud hideAnimated:YES];
             }
             
             
         } andString:strDoctorDetailsApi andParam:Keyvalue];
    }
    else{
        [alert showWarning:self title:@"Warning" subTitle:@"Network error" closeButtonTitle:@"OK" duration:0.0f];
    }
}

#pragma mark - Button Action
- (IBAction)btn_Cancel_click:(id)sender {
    _vw_Mask_View.hidden=YES;
    _vw_Location_PopUp.hidden=YES;
    
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

- (IBAction)btn_Choose_Location_Click:(id)sender {
    _vw_Mask_View.hidden=NO;
    _vw_Location_PopUp.hidden=NO;
    [self.view bringSubviewToFront:_vw_Location_PopUp];
    [_tblv_Location_Table reloadData];
   
}

#pragma mark - TableView Delegate and DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1002) {
        return [[arrmCliniclocation valueForKey:@"location"] count];
    }
    else{
        return [arrmAvailableDate count];
   
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1002) {
        mLocationTableCell=[tableView dequeueReusableCellWithIdentifier:@"LocationTableCell"];
    
        mLocationTableCell.backgroundColor=[UIColor whiteColor];
        mLocationTableCell.selectionStyle=UITableViewCellSelectionStyleNone;
        mLocationTableCell.lbl_Location_Name.text=[[arrmCliniclocation objectAtIndex:indexPath.row]valueForKey:@"location"];
        return mLocationTableCell;
    }
    else{
    cell2=[tableView dequeueReusableCellWithIdentifier:@"DoctorDetalisCell"];
    if (indexPath.row%2==0)
    {
    cell2.backgroundColor=[UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1];
    }
    else
    {
    cell2.backgroundColor=[UIColor whiteColor];
    }
    cell2.selectionStyle=UITableViewCellSelectionStyleNone;
    NSString *strDay=[[arrmAvailableDate valueForKey:@"day"]objectAtIndex:indexPath.row];
    NSString *strTime=[[arrmAvailableDate valueForKey:@"time"]objectAtIndex:indexPath.row];
    cell2.lbl_Day.text=strDay;
    if (strTime.length==0) {
        cell2.lbl_Time.text=@"Not Available";
    }
    else{
        cell2.lbl_Time.text=strTime;
    }
    
    return cell2;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1002) {
        return 64.0f;
    }
    else{
        return 64.0f;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1002) {
        _lbl_Doctor_Location.text=[[arrmCliniclocation objectAtIndex:indexPath.row] valueForKey:@"location"];
        DebugLog(@"%ld",(long)indexPath.row);
        [arrmAvailableDate removeAllObjects];
        arrmTrimAvailableDate=[[arrmCliniclocation objectAtIndex:indexPath.row]valueForKey:@"availabledate"];
        DebugLog(@"arrmTrimAvailableDate%@",arrmTrimAvailableDate);
        for (int i=0; i<arrmTrimAvailableDate.count; i++) {
            NSString *str=[NSString stringWithFormat:@"%@",[[arrmTrimAvailableDate valueForKey:@"time"] objectAtIndex:i]];
            if (str.length>0) {
                DebugLog(@"str====%@",str);
                [arrmAvailableDate addObject:[arrmTrimAvailableDate objectAtIndex:i]];
                DebugLog(@"arrmAvailableDate====%@",arrmAvailableDate);
                
                [_DoctorTimeTableView reloadData];
            }
        }
        
    }
    _vw_Mask_View.hidden=YES;
    _vw_Location_PopUp.hidden=YES;
}
#pragma mark - ColletionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;//[firstSection count];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // NSLog(@"[arrmGetTimeSlots count]%ld",(long)[arrmGetTimeSlots count]);
    return 1;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell = (DectorDetalisCollectionViewCell * )[collectionView dequeueReusableCellWithReuseIdentifier:@"DectorDetalisCollectionViewCell" forIndexPath:indexPath];
    
    
    cell.imgv_Dr_Image.clipsToBounds=YES;
    
    // scrollindex=indexPath;
    
    return cell;
    
}


- (CGSize)collectionView:(UICollectionView* )collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    //    CGFloat screenWidth = screenRect.size.width;
    //    float cellWidth = screenWidth / 3.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
    
    CGSize size = CGSizeMake(screenRect.size.width, 250);
    
    return size;
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 0, 0, 0); // top, left, bottom, right
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}


//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
////    for (UICollectionViewCell *cell22 in [self.CollectionViewDoctorDetalis visibleCells]) {
////        scrollindex = [self.CollectionViewDoctorDetalis indexPathForCell:cell22];
////        NSLog(@"%@",scrollindex);
////    }
//
//    CGRect visibleRect = (CGRect){.origin = self.CollectionViewDoctorDetalis.contentOffset, .size = self.CollectionViewDoctorDetalis.bounds.size};
//    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
//    scrollindex = [self.CollectionViewDoctorDetalis indexPathForItemAtPoint:visiblePoint];
//     NSLog(@"%@",scrollindex);
//
//}



- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    [self.CollectionViewDoctorDetalis reloadData];
    [self.CollectionViewDoctorDetalis scrollToItemAtIndexPath:scrollindex atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*#pragma mark - CalendarManager delegate

- (IBAction)CalenderNextBtn:(id)sender{
    [_calendarContentView loadNextPageWithAnimation];
    [_calendarManager reload];
    
    NSLog(@"next tap");

}

- (IBAction)CalenderPreviousBtn:(id)sender{
    [_calendarContentView loadPreviousPageWithAnimation];
    [_calendarManager reload];
    
    NSLog(@"next tap");

}


// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor colorWithRed:6/255.0f green:147/255.0f blue:194/255.0f alpha:1];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
}

#pragma mark - Fake data

- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    // Min date will be 2 month before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-2];
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:2];
}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}

- (void)createRandomEvents
{
    _eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!_eventsByDate[key]){
            _eventsByDate[key] = [NSMutableArray new];
        }
        
        [_eventsByDate[key] addObject:randomDate];
    }
}



*/



@end
