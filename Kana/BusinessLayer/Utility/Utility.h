

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum {
    kWebServiceTypeLogin,
    kWebServiceTypeGetOffers,
    kWebServiceFavouriteOffer,
    kWebServiceTypeForgotPassword
} webServiceType;

@interface Utility : NSObject

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

+ (UIImage *)resizeImageKeepingAspectRatio:(UIImage *)sourceImage byWidth:(CGFloat)width;
+ (UIImage *)resizeImageKeepingAspectRatio:(UIImage *)sourceImage byHeight:(CGFloat)height;
+ (UIImage *)resizeImageIgnoringAspectRatio:(UIImage *)sourceImage bySize:(CGSize)newSize;
+ (UIImage *)cropImage:(UIImage *)sourceImage withRect:(CGRect)rect;
+ (UIImage *)blurImage:(UIImage *)sourceImage blurAmount:(float)blur;
+ (UIImage*)mergeImage:(UIImage*)firstImage withImage:(UIImage*)secondImage;
+ (UIImage *)maskImage:(UIImage *)sourceImage withMask:(UIImage *)maskImage;
+ (UIImage *)normalizedCapturedImage:(UIImage *)rawImage;
+ (UIImage *)getCurrentScreenShot:(UIViewController *)viewController;

+ (NSString *)getProjectVersionNumber;
+ (NSString *)getBuildVersionNumber;
+ (CGSize)getDeviceScreenSize;
+ (NSString *)getDeviceOSVersionNumber;


+ (BOOL)isNetworkAvailable;
+ (NSDate *)getGMTDateTimeFromLocalDateTime:(NSDate *)date;
+ (int)differenceBetweenTwoDates:(NSDate *)startDate endDate:(NSDate *)endDate;
+ (NSDate *)getLocalDateTimeFromGMTDateTime:(NSDate *)date;

+ (NSString *)encodeStringToBase64:(NSString *)str;
+ (NSString *)decodeStringFromBase64:(NSString *)str;
+ (NSString *)changeDate:(NSString *)date fromFormat:(NSString *)from toFormat:(NSString *)to;
//+ (void)saveUserInfo:(User *)userInfo;
//+ (User *)getUserInfo;
+ (void)removeUserInfo;
+ (NSString *)getDocumentDirectoryPath;
+ (NSString *)createFolderInDocumentDirectory:(NSString *)folderName;
+ (NSString *)getFolderPathFromDocumentDirectory:(NSString *)folderName;
+ (NSString *)getFilePathFromDocumentDirectory:(NSString *)fileName inFolder:(NSString *)folderName;
+ (NSString *)saveFileInDocumentDirectory:(NSData *)fileData fileName:(NSString *)fileName inDirectory:(NSString *)folderName;
+ (BOOL)removeSpecificFileFromDirectory:(NSString *)folderName fileName:(NSString *)fileName;
+ (BOOL)removeAllFilesFromDirectory:(NSString *)folderName;
+ (BOOL)removeSpecificDirectoryFromDocumentDirectory:(NSString *)folderName;
+ (BOOL)removeAllFilesAndFolderFromDocumentDirectory;

@end
