//
//  DectorDetalisCollectionViewCell.h
//  Kana
//
//  Created by Sayan  on 12/01/17.
//  Copyright © 2017 Karmick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DectorDetalisCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgv_Dr_Image;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Dr_Name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Email;
@property (weak, nonatomic) IBOutlet UILabel *Lbl_Specialities;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Qualification;

@end
