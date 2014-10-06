//
//  RRFLoginConst.h
//  RRFLogin
//
//  Created by Rob Fahrni on 10/5/14.
//  Copyright (c) 2014 Apple Core Labs. All rights reserved.
//

// Image Names
static NSString* const kRRFLaunch2x = @"launch2x";
static NSString* const kRRFLaunchR4 = @"launchR4";

// View Storyboard Names
static NSString* const kRRFLoginViewController = @"RRFLoginViewController";

// Service constants
static NSString* const kRRFServiceBaseUrl   = @"http://mad.applecorelabs.com/xyzzy/simple";
static NSString* const kRRFLogin            = @"simple-login.php";

// Service Input Parameters
static NSString* const kRRFUserName         = @"username";
static NSString* const kRRFPassword         = @"password";

// Service Return Values
static NSString* const kRRFMagicToken       = @"magic_token";

// App Errors
static NSString* const kRRFSoftErrorField   = @"RRFSoftError";
static NSString* const kRRFRequestOperation = @"RRFRequestOperation";
static NSString* const kRRFNSError          = @"RRFNSError";

// Keys to localized strings
static NSString* const kRRFOkTitle          = @"OK";
static NSString* const kRRFLoginApp         = @"RRFLogin";
static NSString* const kRRFError            = @"Error";
static NSString* const kRRFSoftErrorText    = @"An unknown error occured";
static NSString* const kRRFLoginSucceeded   = @"Congratulations, you logged into the fancy service!";
static NSString* const kRRFLoginFailed      = @"Sorry, login failed. Check your username and password.";
static NSString* const kRRFUserNameRequiredMessage  = @"A username is required to log in";
static NSString* const kRRFPasswordRequiredMessage  = @"A password is required to log in";