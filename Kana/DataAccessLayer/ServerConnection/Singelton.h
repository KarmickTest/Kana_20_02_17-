//
//  Singelton.h
//  testk
//
//  Created by Karmick 7 on 01/10/15.
//  Copyright (c) 2015 Karmick 7. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MapKit/MapKit.h>
@interface Singelton : NSObject<NSURLSessionDelegate,NSURLSessionDataDelegate,NSURLSessionTaskDelegate,CLLocationManagerDelegate,
MKAnnotation,MKMapViewDelegate>{

    NSString *firstname;
    NSString *lastname;
    NSString *userid;
    NSString *usertype;
    
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLLocationCoordinate2D coordinate;
   
}
+(Singelton *)getInstance;
-(NSString *) Encoder:(NSString *)str;
-(NSString *)demoMethod:(NSString*)outputString;
-(void)jsonparse:(void(^)(NSDictionary* result))handler andString:(NSString*) yourString;
-(void)jsonParseWithPostMethod:(void(^)(NSDictionary* result))handler andString:(NSString*) yourString andParam:(NSString *)params;
-(BOOL)IsBlank:(NSString *)str;
-(NSString *)trim:(NSString *)str;
-(void)saveDefaultsGuest;
-(BOOL)isDeviceLocalizationArabic;
-(void)ButtonEdgeChange:(UIButton *)button spacing:(float)space;
-(NSString *)deviceID;
-(BOOL)isNumeric:(NSString*)inputString;
- (BOOL)isValidPassword:(NSString*)password;
-(NSString *)getLoginId;
-(NSString *)getDeviceToken;
-(void)updateServiceproviderLocation;
- (BOOL)validateEmailWithString:(NSString*)email;
@property (strong,nonatomic) NSString *isLogIn;
@property (strong,nonatomic) NSString *firstname;
@property (strong,nonatomic) NSString *lastname;
@property (strong,nonatomic) NSString *strCustomer_Id;
@property (strong,nonatomic) NSString *usertype;
@property (strong,nonatomic) NSString *strTitle1;
@end
