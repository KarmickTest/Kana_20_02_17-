//
//  MediaSearchCell.h
//  Kana
//
//  Created by Karmick on 11/01/17.
//  Copyright © 2017 Karmick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaSearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgv_Media_Image;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Description1;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Description2;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Description3;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Description4;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Description5;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Date;

@end
