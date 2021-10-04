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

//! Needed because \c CTFontCopyAvailableTables returns a \c CFArray with unboxed values, which Swift does not like at all.
NSArray<NSNumber*> *__nullable CTAFontCopyAvailableTables(CTFontRef __nonnull font, CTFontTableOptions options) NS_REFINED_FOR_SWIFT;

#endif /* CTAdditionsSwiftHelpers_h */
