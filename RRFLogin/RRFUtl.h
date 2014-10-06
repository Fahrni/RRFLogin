//
//  RRFUtl.h
//  RRFLogin
//
//  Created by Rob Fahrni on 10/5/14.
//  Copyright (c) 2014 Apple Core Labs. All rights reserved.
//

// Macro to get the size of a device window
#define DEVICE_SIZE [[[[UIApplication sharedApplication] keyWindow] rootViewController].view convertRect:[[UIScreen mainScreen] bounds] fromView:nil].size

#define IS_WIDESCREEN ( [ [ UIScreen mainScreen ] bounds ].size.height == 568 )
#define IS_IPHONE     ( [[[UIDevice currentDevice] model] rangeOfString:@"iPhone"].location != NSNotFound )
#define IS_IPAD       ( [[[UIDevice currentDevice] model] rangeOfString:@"iPad"].location != NSNotFound )

#define IS_IPHONE5    ( !IS_IPAD && IS_WIDESCREEN )

// Courtesy of Wil Shipley.
// http://www.wilshipley.com/blog/2005/10/pimp-my-code-interlude-free-code.html
//
static inline BOOL IsEmpty(id thing)
{
    return thing == nil
    || thing == [NSNull null]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
} // IsEmpty

// I'm lazy, this is shorter.
#define RRFLoadString(s) NSLocalizedString(s, s)