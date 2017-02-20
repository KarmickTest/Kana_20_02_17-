//
//  LoadView.m
//  TENSER
//
//  Created by Mac Mini 4 on 12/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadView.h"

@implementation LoadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *) ShowActivity:(NSString*)message
{
    CGRect deviceScreen = [[UIScreen mainScreen] bounds];
    
    ActivityView = [[UIView	alloc] initWithFrame:CGRectMake((deviceScreen.size.width - 150) / 2, (deviceScreen.size.height - 100) / 2, 150, 100)];
	ActivityView.layer.cornerRadius = 10;
	ActivityView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	indicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(15, (ActivityView.frame.size.height - 25) / 2, 25, 25)];
	indicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
	
	UILabel *lblString=[[UILabel alloc] initWithFrame:CGRectMake(55, (ActivityView.frame.size.height - 20)/2, 100, 20)];
	lblString.font =[UIFont boldSystemFontOfSize:15];
	lblString.textAlignment =NSTextAlignmentLeft;
	lblString.textColor =[UIColor whiteColor];
	lblString.backgroundColor = [UIColor clearColor];
	lblString.text=message;
    [ActivityView addSubview:lblString];
    [ActivityView addSubview:indicator];
    [lblString release];
    [indicator startAnimating];
	ActivityView.backgroundColor=[UIColor blackColor];
    ActivityView.alpha=0.7;
	[UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    return ActivityView;
}

-(UIView *)showView{
    CGRect deviceScreen = [[UIScreen mainScreen] bounds];
    
    ActivityView = [[UIView	alloc] initWithFrame:CGRectMake((deviceScreen.size.width - 150) / 2, (deviceScreen.size.height - 70) / 2, 150, 100)];
    ActivityView.layer.cornerRadius = 10;
    ActivityView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    ActivityView.backgroundColor=[UIColor blackColor];
    ActivityView.alpha=0.7;
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    return ActivityView;
}

- (UIView *)ShowActivityForFrndRequest:(NSString*)message deviceScreen:(CGRect )deviceScreen
{
    
    //CGRect deviceScreen1 = [[UIScreen mainScreen] bounds];
    
    ActivityView = [[UIView	alloc] initWithFrame:CGRectMake((deviceScreen.size.width - 150) / 2, (deviceScreen.size.height - 100-163) / 2, 150, 100)];
    ActivityView.layer.cornerRadius = 10;
    ActivityView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    indicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(15, (ActivityView.frame.size.height - 25) / 2, 25, 25)];
    indicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
    
    UILabel *lblString=[[UILabel alloc] initWithFrame:CGRectMake(55, (ActivityView.frame.size.height - 20)/2, 100, 20)];
    lblString.font =[UIFont boldSystemFontOfSize:15];
    lblString.textAlignment =NSTextAlignmentLeft;
    lblString.textColor =[UIColor whiteColor];
    lblString.backgroundColor = [UIColor clearColor];
    lblString.text=message;
    [ActivityView addSubview:lblString];
    [ActivityView addSubview:indicator];
    [lblString release];
    [indicator startAnimating];
    ActivityView.backgroundColor=[UIColor blackColor];
    ActivityView.alpha=0.7;
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    return ActivityView;
}


- (UIView *) ShowActivityForImageUploading:(NSString*)message
{
    CGRect deviceScreen = [[UIScreen mainScreen] bounds];
    
    ActivityView = [[UIView	alloc] initWithFrame:CGRectMake((deviceScreen.size.width - 200) / 2, (deviceScreen.size.height - 100) / 2, 200, 100)];
    ActivityView.layer.cornerRadius = 10;
    ActivityView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    indicator=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, (ActivityView.frame.size.height - 25) / 2, 25, 25)];
    indicator.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
    
    UILabel *lblString=[[UILabel alloc] initWithFrame:CGRectMake(45, (ActivityView.frame.size.height - 20)/2, 150, 20)];
    lblString.font =[UIFont boldSystemFontOfSize:14];
    lblString.textAlignment =NSTextAlignmentLeft;
    lblString.textColor =[UIColor whiteColor];
    lblString.backgroundColor = [UIColor clearColor];
    lblString.text=message;
    [ActivityView addSubview:lblString];
    [ActivityView addSubview:indicator];
    [lblString release];
    [indicator startAnimating];
    ActivityView.backgroundColor=[UIColor blackColor];
    ActivityView.alpha=0.7;
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    return ActivityView;
}


- (void) hideActivity{
	//[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
	[indicator stopAnimating];
	[indicator removeFromSuperview];
	[ActivityView removeFromSuperview];
	ActivityView = nil;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
