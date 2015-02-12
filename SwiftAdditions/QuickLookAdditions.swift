//
//  QuickLook.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 1/17/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Foundation

public var kQLReturnMask: OSStatus {
	return 0xaf00
}

public var kQLReturnNoErr: OSStatus {
	return noErr
}

public var kQLReturnHasMore: OSStatus {
	return (kQLReturnMask | 10)
}

public enum QLPreviewPDFStyle: Int {
	case Standard = 0
	case PagesWithThumbnailsOnRight = 3
	case PagesWithThumbnailsOnLeft = 4
}
