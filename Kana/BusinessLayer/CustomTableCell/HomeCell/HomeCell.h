//
//  HomeCell.h
//  Kana
//
//  Created by Karmick on 12/01/17.
//  Copyright © 2017 Karmick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_Clinic_Name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Clinic_Address;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_Background_Image;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_Shadow;
@property (weak, nonatomic) IBOutlet UIView *vw_BackView;

@end
