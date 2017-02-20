//
//  FooterView.m
//  RoundAfire
//
//  Created by Imac on 10/06/16.
//  Copyright © 2016 karmick123. All rights reserved.
//

#import "FooterView.h"
#import "Constant.h"

@implementation FooterView

- (IBAction)tabbar_Button_Home_Click:(id)sender{
    [_delegate footerButtonClicked:0];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"mybooks"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"explore"];
    [[NSUserDefaults standardUserDefaults]synchronize];
//    self.btn_Footer_Home.backgroundColor=RFDarkOrangeColor;
//    self.btn_Footer_Explore.backgroundColor=RFOrangeColor;
//    self.btn_Footer_My_Books.backgroundColor=RFOrangeColor;
//    self.btn_Footer_Parents.backgroundColor=RFOrangeColor;
    
}
- (IBAction)tabbar_Button_Explore_Click:(id)sender{
     [_delegate footerButtonClicked:1];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"explore"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"mybooks"];
    [[NSUserDefaults standardUserDefaults]synchronize];
//    self.btn_Footer_Explore.backgroundColor=RFDarkOrangeColor;
//    self.btn_Footer_My_Books.backgroundColor=RFOrangeColor;
//    self.btn_Footer_Parents.backgroundColor=RFOrangeColor;
//    self.btn_Footer_Home.backgroundColor=RFOrangeColor;

    
}
- (IBAction)tabbar_Button_My_Books_Click:(id)sender{
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"mybooks"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"explore"];
    [[NSUserDefaults standardUserDefaults]synchronize];
     [_delegate footerButtonClicked:2];
//    self.btn_Footer_My_Books.backgroundColor=RFDarkOrangeColor;
//    self.btn_Footer_Parents.backgroundColor=RFOrangeColor;
//    self.btn_Footer_Home.backgroundColor=RFOrangeColor;
//    self.btn_Footer_Explore.backgroundColor=RFOrangeColor;
    
}
- (IBAction)tabbar_Button_Parents_Click:(id)sender{
     [_delegate footerButtonClicked:3];
//    self.btn_Footer_Parents.backgroundColor=RFDarkOrangeColor;
//    self.btn_Footer_Home.backgroundColor=RFOrangeColor;
//    self.btn_Footer_Explore.backgroundColor=RFOrangeColor;
//    self.btn_Footer_My_Books.backgroundColor=RFOrangeColor;
    
}
-(void)myBooksTabSelect:(NSInteger) sender{
    if (sender==1){
//        self.btn_Footer_Explore.backgroundColor=RFDarkOrangeColor;
//        self.btn_Footer_My_Books.backgroundColor=RFOrangeColor;
//        self.btn_Footer_Parents.backgroundColor=RFOrangeColor;
//        self.btn_Footer_Home.backgroundColor=RFOrangeColor;
//        
    }
   else if (sender==2) {
//        self.btn_Footer_My_Books.backgroundColor=RFDarkOrangeColor;
//        self.btn_Footer_Parents.backgroundColor=RFOrangeColor;
//        self.btn_Footer_Home.backgroundColor=RFOrangeColor;
//        self.btn_Footer_Explore.backgroundColor=RFOrangeColor;
    }
   else{
//       self.btn_Footer_Home.backgroundColor=RFDarkOrangeColor;
//       self.btn_Footer_Explore.backgroundColor=RFOrangeColor;
//       self.btn_Footer_My_Books.backgroundColor=RFOrangeColor;
//       self.btn_Footer_Parents.backgroundColor=RFOrangeColor;
   }
    
}


@end
