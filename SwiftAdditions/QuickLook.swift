//
//  QuickLook.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 1/17/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Foundation

#if os(OSX)

public enum QLPreviewPDFStyle: Int {
	case standard = 0
	case pagesWithThumbnailsOnRight = 3
	case pagesWithThumbnailsOnLeft = 4
}

#endif
