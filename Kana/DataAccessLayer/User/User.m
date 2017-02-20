
#import "User.h"

@implementation User


-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        _user_ID = @"";
        _phoneNumber = @"";
        _profilePicUrl = @"";
        _isStudent = @"";
        _collegeName = @"";
        _majorSubject = @"";
        _enterCollegeYear = @"";
        _educationalLevel = @"";
        _countryName = @"";
        _countryDigitalCode = @"";
        _latitude = @"";
        _longitude = @"";
        _verificationcode = @"";
        _NickName = @"";
        _college_ID = @"";
        _subject_ID = @"";
	}
	return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:_user_ID forKey:@"user_ID"];
    [encoder encodeObject:_phoneNumber forKey:@"phoneNumber"];
    [encoder encodeObject:_isStudent forKey:@"isStudent"];
    [encoder encodeObject:_collegeName forKey:@"collegeName"];
    [encoder encodeObject:_majorSubject forKey:@"majorSubject"];
    [encoder encodeObject:_enterCollegeYear forKey:@"enterCollegeYear"];
    [encoder encodeObject:_educationalLevel forKey:@"educationalLevel"];
    [encoder encodeObject:_countryName forKey:@"countryName"];
    [encoder encodeObject:_countryDigitalCode forKey:@"countryDigitalCode"];
    [encoder encodeObject:_latitude forKey:@"latitude"];
    [encoder encodeObject:_longitude forKey:@"longitude"];
    [encoder encodeObject:_verificationcode forKey:@"verificationcode"];
    [encoder encodeObject:_NickName forKey:@"NickName"];
    [encoder encodeObject:_profilePicUrl forKey:@"profilePicUrl"];
    [encoder encodeObject:_college_ID forKey:@"college_ID"];
    [encoder encodeObject:_subject_ID forKey:@"subject_ID"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        _user_ID = [decoder decodeObjectForKey:@"user_ID"];
        _phoneNumber = [decoder decodeObjectForKey:@"phoneNumber"];
        _isStudent = [decoder decodeObjectForKey:@"isStudent"];
        _collegeName = [decoder decodeObjectForKey:@"collegeName"];
        _majorSubject = [decoder decodeObjectForKey:@"majorSubject"];
        _enterCollegeYear = [decoder decodeObjectForKey:@"enterCollegeYear"];
        _educationalLevel = [decoder decodeObjectForKey:@"educationalLevel"];
        _countryName = [decoder decodeObjectForKey:@"countryName"];
        _countryDigitalCode = [decoder decodeObjectForKey:@"countryDigitalCode"];
        _latitude = [decoder decodeObjectForKey:@"latitude"];
        _longitude = [decoder decodeObjectForKey:@"longitude"];
        _verificationcode = [decoder decodeObjectForKey:@"verificationcode"];
        _NickName = [decoder decodeObjectForKey:@"NickName"];
        _profilePicUrl = [decoder decodeObjectForKey:@"profilePicUrl"];
        _college_ID = [decoder decodeObjectForKey:@"college_ID"];
        _subject_ID = [decoder decodeObjectForKey:@"subject_ID"];
    }
    return self;
}




@end
