//
//  ALBase.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 5/28/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Foundation
import OpenAL.AL

final public class OpenAL {
	class func enableCapability(avar: ALenum) {
		alEnable(avar)
	}
	
	class func disableCapability(avar: ALenum) {
		alDisable(avar)
	}
	
	class func capabilityEnabled(avar: ALenum) -> Bool {
		return alIsEnabled(avar) != 0
	}
	
	class func stringForParameter(avar: ALenum) -> String? {
		return String(UTF8String: alGetString(avar))
	}
}
