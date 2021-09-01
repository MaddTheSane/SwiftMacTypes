//
//  CTRunDelegateAdditions.swift
//  CoreTextAdditions
//
//  Created by C.W. Betts on 9/1/21.
//  Copyright © 2021 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText

public extension CTRunDelegate {
	var refCon: UnsafeMutableRawPointer {
		return CTRunDelegateGetRefCon(self)
	}
}
