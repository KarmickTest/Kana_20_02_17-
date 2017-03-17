//
//  GalleryViewController.m
//  Kana
//
//  Created by Karmick on 12/01/17.
//  Copyright © 2017 Karmick. All rights reserved.
//

#import "GalleryViewController.h"
#import "DefineHeader.h"
#import "Constant.h"
#import "UIImageView+WebCache.h"
#import <SYPhotoBrowser/SYPhotoBrowser.h>

@interface GalleryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    
    NSMutableArray *arrmHomeContent,*galaryListContentArr,*UrlArr;
    NSMutableArray *arrmHomeContent1;
    MBProgressHUD *hud;
    NSString *languageCheck;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *colv_Gallery;

@end

@implementation GalleryViewController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _colv_Gallery.delegate=self;
    _colv_Gallery.dataSource=self;
    self.colv_Gallery.hidden=YES;
    galaryListContentArr=[[NSMutableArray alloc] init];
    UrlArr=[[NSMutableArray alloc] init];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"TapOnCell"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.colv_Gallery.hidden=YES;
    languageCheck =[[NSUserDefaults standardUserDefaults]objectForKey:@"languageCode"];
    LocalizationSetLanguage(languageCheck);
    [self getGalaryList];
}


#pragma mark -  Call Web Service

-(void)getGalaryList{
     languageCheck=[[NSUserDefaults standardUserDefaults] objectForKey:@"languageCode"];
     DebugLog(@"languageCheck%@",languageCheck);
    
    hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    if ([Utility isNetworkAvailable]==YES) {
        
        NSString *strClinicListApi=[NSString stringWithFormat:@"%@%@",API,GALARYLIST];
        DebugLog(@"The string value:%@",strClinicListApi);
        
        [[Singelton getInstance] jsonparse:^(NSDictionary* testResult){
            
            DebugLog(@"GALARYLIST====%@",testResult);
            if ([[testResult valueForKey:@"success"] boolValue]==1) {
                
                
                self.colv_Gallery.hidden=NO;
                galaryListContentArr=[testResult valueForKey:@"list"];
                DebugLog(@"arrmGalaryContent====%lu",(unsigned long)galaryListContentArr.count);
                
                if (UrlArr.count>0)
                {
                    [UrlArr removeAllObjects];
                }
                
                for (int i=0; i<galaryListContentArr.count; i++)
                {
                    [UrlArr addObject:[[galaryListContentArr objectAtIndex:i] valueForKey:@"large"]];
                }
                
                
                [self.colv_Gallery reloadData];
            }
            self.view.userInteractionEnabled=YES;
            [hud hideAnimated:YES];
            
        } andString:strClinicListApi];
    }
    else{
        [hud hideAnimated:YES];
        [Utility showAlertWithTitle:@"Warning" message:@"Network error"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView Delegate and Data Source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;//[firstSection count];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // NSLog(@"[arrmGetTimeSlots count]%ld",(long)[arrmGetTimeSlots count]);
    return [galaryListContentArr count];
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    CGRect screenRect = [[UIScreen mainScreen] bounds];
    //    CGFloat screenWidth = screenRect.size.width;
    //    float cellWidth = screenWidth / 4.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
    CGSize size = CGSizeMake(167, 167);
    
    return size;
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10); // top, left, bottom, right
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GalleryCell *mGalleryCell = (GalleryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryCell" forIndexPath:indexPath];
    mGalleryCell.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
   // mGalleryCell.backgroundColor=[UIColor colorWithRed:232.0f/255.0f green:232.0f/255.0f blue:232.0f/255.0f alpha:1.0];
   //mGalleryCell.imgv_Gallery_Image.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",[[galaryListContentArr objectAtIndex:indexPath.row] valueForKey:@"medium"]]];
   
    
    
    [mGalleryCell.imgv_Gallery_Image sd_setImageWithURL:[NSURL URLWithString:[[galaryListContentArr objectAtIndex:indexPath.row] valueForKey:@"medium"]] placeholderImage:[UIImage imageNamed:@"Gallery_Placeholder"] options:/* DISABLES CODE */ (0) == 0?SDWebImageRefreshCached : 0];
    
    mGalleryCell.imgv_Gallery_Image.clipsToBounds=YES;
    
    
       mGalleryCell.contentView.layer.borderColor=[UIColor lightGrayColor].CGColor;
       mGalleryCell.contentView.layer.borderWidth=0.5f;

    
    
    return mGalleryCell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DebugLog(@"you clicked image index: %ld",  indexPath.row);
    
    
    SYPhotoBrowser *photoBrowser = [[SYPhotoBrowser alloc] initWithImageSourceArray:UrlArr caption:nil delegate:self];
    photoBrowser.initialPageIndex = indexPath.row;
    photoBrowser.pageControlStyle = SYPhotoBrowserPageControlStyleLabel;
    [self presentViewController:photoBrowser animated:YES completion:nil];
    
    
}


@end
