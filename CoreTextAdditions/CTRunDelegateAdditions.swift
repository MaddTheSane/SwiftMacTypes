//
//  CTRunDelegateAdditions.swift
//  CoreTextAdditions
//
//  Created by C.W. Betts on 9/1/21.
//  Copyright © 2021 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText

// TODO: have Apple go over the API for CTRunDelegate, make sure all areas are supposed to be non-null.
public extension CTRunDelegate {
	@inlinable static func create(callbacks: UnsafePointer<CTRunDelegateCallbacks>, refCon: UnsafeMutableRawPointer?) -> CTRunDelegate? {
		return CTRunDelegateCreate(callbacks, refCon)
	}
	
	@inlinable var refCon: UnsafeMutableRawPointer {
		return CTRunDelegateGetRefCon(self)
	}
}
