//
//  SearchTableViewCell.h
//  Kana
//
//  Created by Sayan  on 11/01/17.
//  Copyright © 2017 Karmick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *TitleImageView;
@property (weak, nonatomic) IBOutlet UILabel *MainTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *SubTitleLabel;

@end
