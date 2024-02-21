//
//  CTAdditionsSwiftHelpers.h
//  CoreTextAdditions
//
//  Created by C.W. Betts on 10/18/17.
//  Copyright © 2017 C.W. Betts. All rights reserved.
//

#ifndef CTAdditionsSwiftHelpers_h
#define CTAdditionsSwiftHelpers_h

#import <Foundation/Foundation.h>
#include <CoreText/CTFont.h>

//! Needed because \c CTFontCopyAvailableTables returns a \c CFArrayRef with unboxed values, which Swift does not like \b at \b all.
NSArray<NSNumber*> *__nullable CTAFontCopyAvailableTables(CTFontRef __nonnull font, CTFontTableOptions options) NS_RETURNS_RETAINED;

#endif /* CTAdditionsSwiftHelpers_h */
