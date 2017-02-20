

#ifndef hairvii_Constant_h
#define hairvii_Constant_h


#define API @"http://360frameworks.com/kana/webservice/"
#define CLINICLIST @"clinic_list.php"
#define DOCTORLISTING  @"doctor_list.php"
#define GALARYLIST @"gallery.php"
#define FAQ @"faq.php"
#define ABOUTUS @"cms.php"
#define CONTACTUS @"contactUs.php"
#define MEDIALIST @"medialist.php"
#define TESTIMONIALS @"testimonials.php"
#define SEARCH @"search.php"
#define DOCTORDETAILS @"doc_details.php"


#define ALERT_TITLE @"Kana"
#define ALERT_NOTIFICATION @""
#define WARNINGTITLE @"Oops!"
#define BUTTONTITLE  @"OK";
#define NETWORKERROR @"Network error";
 //Change this one to your ID

#define BASEURL @""
//#define BASEURL @""
#define DebugLog(...) NSLog(__VA_ARGS__)
static NSString * const kClientID =@"1024831568071-b7g559ldi06rvhefujosn8f7nlil25u1.apps.googleusercontent.com";

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RobotoConso @"RobotoCondensed-Regular"
#define Roboto @"Roboto-Regular"
#define MainStory [UIStoryboard storyboardWithName:@"Main" bundle:nil]

#define MAINSTORYBOARD [UIStoryboard storyboardWithName:@"Main" bundle:nil]

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)




#endif
typedef void(^KHJSondataBlock) (NSURLResponse *response, NSError *error,id resopncedata);
typedef void (^KHDownloadImage)(NSError *error, UIImage *image);
