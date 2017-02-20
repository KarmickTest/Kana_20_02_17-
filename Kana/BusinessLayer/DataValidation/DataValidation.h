//
//  DataValidation.h
//  ProjDemo
//
//  Created by Ankush Chakraborty on 17/11/14.
//  Copyright (c) 2014 Isis Design Services. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DataValidation : NSObject

+ (BOOL)isDeviceiPhone;
+ (BOOL)isNullString:(NSString *)textString;
+ (BOOL)isNumericString:(NSString *)textString;
+ (BOOL)isAlphabetString:(NSString *)textString;
+ (BOOL)isValidPassword:(NSString*)password;
+ (BOOL)isValidateMailid:(NSString *)email;
+ (BOOL)isValidatePhoneNo:(NSString *)phoneno;
+ (BOOL)isFutureDateByToday:(NSDate *)date;
+ (BOOL)isFutureDate:(NSDate *)date1 byDate:(NSDate *)date2;
+ (BOOL)isAgeGreaterThanOrEqualTo:(int)age dateOfBirth:(NSDate *)dob;

@end
