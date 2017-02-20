//
//  FooterView.h
//  RoundAfire
//
//  Created by Imac on 10/06/16.
//  Copyright © 2016 karmick123. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomAction <NSObject>

-(void)footerButtonClicked:(int)btnTag;

@end

@interface FooterView : UIView
@property id<CustomAction> delegate;
- (IBAction)tabbar_Button_Home_Click:(id)sender;
- (IBAction)tabbar_Button_Explore_Click:(id)sender;
- (IBAction)tabbar_Button_My_Books_Click:(id)sender;
- (IBAction)tabbar_Button_Parents_Click:(id)sender;
-(void)myBooksTabSelect:(NSInteger) sender;
@property (strong, nonatomic) IBOutlet UIButton *btn_Footer_Home;
@property (strong, nonatomic) IBOutlet UIButton *btn_Footer_Explore;
@property (strong, nonatomic) IBOutlet UIButton *btn_Footer_My_Books;
@property (strong, nonatomic) IBOutlet UIButton *btn_Footer_Parents;

@end
