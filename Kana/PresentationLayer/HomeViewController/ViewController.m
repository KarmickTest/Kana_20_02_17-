//
//  ViewController.m
//  test
//
//  Created by Karmick on 11/01/17.
//  Copyright © 2017 Karmick. All rights reserved.
//

#import "ViewController.h"
#import "DefineHeader.h"
#import "Constant.h"
#import "UIImageView+WebCache.h"


@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSMutableArray *arrmHomeContent;
    NSMutableArray *arrmHomeContent1;
    SCLAlertView *alert;
    NSString *languageCheck;
  
}
@property (weak, nonatomic) IBOutlet UILabel *lbl_Clinic;

@property (weak, nonatomic) IBOutlet UICollectionView *colv_Home_Cell;

@end


@implementation ViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    arrmHomeContent=[[NSMutableArray alloc]initWithObjects:@"HomeCellImage1",@"HomeCellImage2",@"HomeCellImage3",@"HomeCellImage1",@"HomeCellImage2",@"HomeCellImage3",@"HomeCellImage1",@"HomeCellImage2",@"HomeCellImage3",@"HomeCellImage1",@"HomeCellImage2",@"HomeCellImage3",@"HomeCellImage1",@"HomeCellImage2",@"HomeCellImage3",@"HomeCellImage1",@"HomeCellImage2",@"HomeCellImage3",@"HomeCellImage1",@"HomeCellImage2",@"HomeCellImage3",@"HomeCellImage1",@"HomeCellImage2",@"HomeCellImage3",@"HomeCellImage1",@"HomeCellImage2",@"HomeCellImage3",@"HomeCellImage1",@"HomeCellImage2",@"HomeCellImage3",@"HomeCellImage1",@"HomeCellImage2",@"HomeCellImage3",@"HomeCellImage1",@"HomeCellImage2",@"HomeCellImage3",@"HomeCellImage1",@"HomeCellImage2",@"HomeCellImage3",@"HomeCellImage1",@"HomeCellImage2",@"HomeCellImage3",@"HomeCellImage1",@"HomeCellImage2",@"HomeCellImage3", nil];
     arrmHomeContent1=[[NSMutableArray alloc]init];
     arrmHomeContent1=[[NSUserDefaults standardUserDefaults]objectForKey:@"Specialization"];
    alert= [[SCLAlertView alloc] init];
    DebugLog(@"Specialist Listing%@",arrmHomeContent1);
   

    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    DebugLog(@"NSUserDefaults2%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"TapOnCell"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
   languageCheck =[[NSUserDefaults standardUserDefaults]objectForKey:@"languageCode"];
    LocalizationSetLanguage(languageCheck);
    _lbl_Clinic.text=LocalizedString(@"CLINIC");
    if (arrmHomeContent.count>0) {
        _colv_Home_Cell.delegate=self;
        _colv_Home_Cell.dataSource=self;
        [_colv_Home_Cell reloadData];
    }
    else{
        
        [alert showWarning:self title:@"Oops!" subTitle:LocalizedString(@"No content available") closeButtonTitle:LocalizedString(@"OK") duration:0.0f];
        
    }
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark - CollectionView Delegate and Data Source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;//[firstSection count];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    return [arrmHomeContent1 count];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize size = CGSizeMake(225, 225);
    
    return size;
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(1, 0, 0, 0); // top, left, bottom, right
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 25.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
     HomeCell *mHomeCell = (HomeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCell" forIndexPath:indexPath];
     mHomeCell.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
     mHomeCell.imgv_Background_Image.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[arrmHomeContent objectAtIndex:indexPath.row]]];
    DebugLog(@"Spname %@",[[arrmHomeContent1 objectAtIndex:indexPath.row] valueForKey:@"spname"]);
     mHomeCell.lbl_Clinic_Name.text=[[arrmHomeContent1 objectAtIndex:indexPath.row] valueForKey:@"spname"];
    return mHomeCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
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

    DoctorListingViewController *mDoctorListingViewController = [storyboard instantiateViewControllerWithIdentifier:@"DoctorListingViewController"];
    mDoctorListingViewController.strSpecialistId=[[arrmHomeContent1 objectAtIndex:indexPath.row] valueForKey:@"spid"];
    DebugLog(@"strSpecialistId%@",mDoctorListingViewController.strSpecialistId);
    [self.navigationController pushViewController:mDoctorListingViewController animated:NO];

    
    
    
}

@end
