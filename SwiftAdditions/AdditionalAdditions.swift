//
//  AdditionalAdditions.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 11/2/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Foundation

internal let isLittleEndian = Int(OSHostByteOrder()) == OSLittleEndian

internal func GetArrayFromMirror<X>(mirror: MirrorType) -> [X] {
	var anArray = [X]()
	for i in 0..<mirror.count {
		var aChar = mirror[i].1.value as X
		anArray.append(aChar)
	}
	
	return anArray
}

internal func GetArrayFromMirror<X>(mirror: MirrorType, appendLastObject lastObj: X) -> [X] {
	var anArray: [X] = GetArrayFromMirror(mirror)
	anArray.append(lastObj)
	return anArray
}
