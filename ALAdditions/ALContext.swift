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

final public class ALContext {
	private(set) var context: ALCcontext = nil
	
	public var makeCurrent: Bool {
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


