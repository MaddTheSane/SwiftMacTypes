//
//  ALContext.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 5/28/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Foundation
import OpenAL.AL
import OpenAL.ALC

typealias ALCcontext = COpaquePointer
typealias ALCdevice = COpaquePointer

enum ALCErrors: ALCenum {
	/// No error
	case NoError = 0
	
	/// No device
	case InvalidDevice = 0xA001
	
	/// invalid context ID
	case InvalidContext = 0xA002
	
	/// bad enum
	case InvalidEnum = 0xA003
	
	/// bad value
	case InvalidValue = 0xA004
	
	/// Out of memory
	case OutOfMemory = 0xA005
}

final public class ALContext {
	private(set) var context: ALCcontext = nil
	
	public func makeCurrent() -> Bool {
		return alcMakeContextCurrent(context) != 0
	}
	
	public func process() {
		alcProcessContext(context)
	}
	
	public func suspend() {
		alcSuspendContext(context)
	}
	
	public var current: Bool {
		return context == alcGetCurrentContext()
	}
	
	deinit {
		if context != nil {
			alcDestroyContext(context)
		}
	}
}


