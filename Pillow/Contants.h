//
//  Contants.h
//  Pillow
//
//  Created by Xinyuan Wang on 1/13/17.
//  Copyright © 2017 RJT. All rights reserved.
//

#ifndef Contants_h
#define Contants_h

//user signup keys
static NSString *const useridKey = @"userid";
static NSString *const usernameKey = @"username";
static NSString *const passwordKey = @"password";
static NSString *const emailKey = @"email";
static NSString *const mobileKey = @"mobile";
static NSString *const dobKey = @"dob";
static NSString *const address1Key = @"address1";
static NSString *const address2Key = @"address2";
static NSString *const usertypeKey = @"usertype";
static NSString *const userstatusKey = @"usertstatus";

//user login return keys
static NSString *const loginRespondIdKey = @"User Id";
static NSString *const loginRespondTypeKey = @"User Type";
static NSString *const searchUserRespondNameKey = @"User Name";
static NSString *const searchUserRespondMobileKey = @"User Mobile";
static NSString *const searchUserRespondEmailKey = @"User Email";


//user date format
static NSString *const dateFormat = @"dd-MM-yyyy";

//key in UserDefaults
static NSString *const userKey = @"currentUser";

//buyerKey sellerKey
static NSString *const buyerContent = @"buyer";
static NSString *const sellerContent = @"seller";

//Property keys Note: (for key of userID in property, please use LoginRespondIdKey)

static NSString *const propIDKey = @"Property Id";
static NSString *const propNameKey = @"Property Name";
static NSString *const propTypeKey = @"Property Type";
static NSString *const propCataKey = @"Property Category";
static NSString *const propAddr1Key = @"Property Address1";
static NSString *const propAddr2Key =@"Property Address2";
static NSString *const propZipKey = @"Property Zip";
static NSString *const propImg1Key =@"Property Image 1";
static NSString *const propImg2Key =@"Property Image 2";
static NSString *const propImg3Key = @"Property Image 3";
static NSString *const propLatKey = @"Property Latitude";
static NSString *const propLongKey = @"Property Longitude";
static NSString *const propCostKey = @"Property Cost";
static NSString *const propSizeKey = @"Property Size";
static NSString *const propDescKey = @"Property Desc";
static NSString *const propPubDateKey = @"Property Published Date";
static NSString *const propModDateKey = @"Property Modify Date";
static NSString *const propStatusKey = @"Property Status";

#endif /* Contants_h */
