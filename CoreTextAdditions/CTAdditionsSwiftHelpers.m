//
//  blankFile.m
//  CoreTextAdditions
//
//  Created by C.W. Betts on 10/18/17.
//  Copyright © 2017 C.W. Betts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTAdditionsSwiftHelpers.h"

NSArray *__nullable CTAFontCopyAvailableTables(CTFontRef __nonnull font, CTFontTableOptions options)
{
	CFArrayRef preGoodArray = CTFontCopyAvailableTables(font, options);
	if (preGoodArray) {
		CFIndex count = CFArrayGetCount(preGoodArray);
		NSMutableArray *ourArray = [[NSMutableArray alloc] initWithCapacity:count];
		for (NSInteger i = 0; i < count; i++) {
			CTFontTableTag newTag = (CTFontTableTag)(uintptr_t)CFArrayGetValueAtIndex(preGoodArray, i);
			[ourArray addObject:@(newTag)];
		}
		
		CFRelease(preGoodArray);
		return [ourArray copy];
	}
	
	return nil;
}
