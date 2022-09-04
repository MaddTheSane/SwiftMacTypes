//
//  CGColorSpace.swift
//  QuartzAdditions
//
//  Created by C.W. Betts on 7/24/22.
//  Copyright © 2022 C.W. Betts. All rights reserved.
//

import Foundation
import CoreGraphics.CGColorSpace

public extension CGColorSpace {
	//CGColorSpaceUsesITUR_2100TF
	/// Return true if color space uses transfer functions defined in **ITU Rec.2100**.
	@available(macOS 11.0, iOS 14.0, tvOS 14.0, *)
	@inlinable var usesITUR_2100TF: Bool {
		return CGColorSpaceUsesITUR_2100TF(self)
	}
	
	@available(macOS 12.0, iOS 15.0, tvOS 15.0, *)
	@inlinable var isPQBased: Bool {
		return CGColorSpaceIsPQBased(self)
	}

	@available(macOS 12.0, iOS 15.0, tvOS 15.0, *)
	@inlinable var isHLGBased: Bool {
		return CGColorSpaceIsHLGBased(self)
	}
	
	@available(macOS 10.12, iOS 10.0, tvOS 10.0, *)
	@inlinable var usesExtendedRange: Bool {
		return CGColorSpaceUsesExtendedRange(self)
	}
}
