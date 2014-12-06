//
//  AdditionalAdditions.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 11/2/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Foundation

/// Best used for tuples of the same type, which Swift converts fixed-sized C arrays into.
/// returns nil if any type in the mirror doesn't match `X`
public func GetArrayFromMirror<X>(mirror: MirrorType) -> [X]? {
	var anArray = [X]()
	for i in 0..<mirror.count {
		if let aChar = mirror[i].1.value as? X {
			anArray.append(aChar)
		} else {
			assert(false, "Value at \(i) (\(mirror[i].0)) does not match type \(X.self)")
			return nil
		}
	}
	
	return anArray
}

/// Best used for a fixed-size C array that expects to be NULL-terminated, like a C string.
public func GetArrayFromMirror<X>(mirror: MirrorType, appendLastObject lastObj: X) -> [X]? {
	if let bArray: [X] = GetArrayFromMirror(mirror) {
		var anArray = bArray
		anArray.append(lastObj)
		return anArray
	} else {
		return nil
	}
}

/// Useful to force a function to run on the main thread, but you don't know if you ARE on the main thread.
public func RunOnMainThreadSync(block: dispatch_block_t) {
	if NSThread.isMainThread() {
		block()
	} else {
		dispatch_sync(dispatch_get_main_queue(), block)
	}
}
