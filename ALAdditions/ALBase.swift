//
//  ALBase.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 5/28/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Foundation
import OpenAL
//import OpenAL.AL

final public class OpenAL {
	public class func enableCapability(avar: ALenum) {
		alEnable(avar)
	}
	
	public class func disableCapability(avar: ALenum) {
		alDisable(avar)
	}
	
	public class func capabilityEnabled(avar: ALenum) -> Bool {
		return alIsEnabled(avar) != 0
	}
	
	public class func stringForParameter(avar: ALenum) -> String? {
		let tmpStr = alGetString(avar)
		if tmpStr == nil {
			return nil
		}
		return String(UTF8String: tmpStr)
	}
	
	public class func extensionIsPresent(extname: String) -> Bool {
		return alIsExtensionPresent(extname) != 0
	}
	
	public class func alEnumValue(ename: String) -> ALenum {
		return alGetEnumValue(ename)
	}
	
	//AL_API void* AL_APIENTRY alGetProcAddress( const ALchar* fname );
}
