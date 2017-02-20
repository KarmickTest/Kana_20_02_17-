//
//  SearchDetalisViewController.h
//  Kana
//
//  Created by Sayan  on 12/01/17.
//  Copyright © 2017 Karmick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>

@interface SearchDetalisViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *CollectionViewDoctorDetalis;
@property (weak, nonatomic) IBOutlet UIView *HospitalView;
@property (weak, nonatomic) IBOutlet UIView *CalenderBackView;

@property (weak, nonatomic) IBOutlet UITableView *DoctorTimeTableView;

//@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
//@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
//
//@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;
@property (strong, nonatomic) NSString *strDoctorName;
@property (strong, nonatomic) NSString *strDoctorId;
@property (strong, nonatomic) NSString *strClinicID;
@property (strong, nonatomic) NSString *strComingFrom;

@end
