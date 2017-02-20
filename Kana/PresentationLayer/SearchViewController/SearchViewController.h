//
//  SearchViewController.h
//  Kana
//
//  Created by Karmick on 11/01/17.
//  Copyright © 2017 Karmick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *SearchTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBarView;
@property (weak, nonatomic) IBOutlet UIView *TableViewBackroundView;

@end
