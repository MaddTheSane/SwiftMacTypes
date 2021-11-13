//
//  UTTypes.swift
//  UTTypeOSTypes
//
//  Created by C.W. Betts on 11/13/21.
//  Copyright © 2021 C.W. Betts. All rights reserved.
//

import Foundation
import UniformTypeIdentifiers

public extension UTTagClass {
	/**
	 The tag class for Mac OS type codes such as `"TEXT"`.
	 
	 The raw value of this tag class is `"com.apple.ostype"`.
	 */
	static var osType: UTTagClass {
		return UTTagClass(rawValue: "com.apple.ostype")
	}
}

public extension UTType {
	/**
	 If available, the preferred (first available) tag of class
	 `.osType`.
	 
	 If not `nil`, the value of this property is the best available Mac OS type code
	 for the given type, according to its declaration. The value of this
	 property is equivalent to:
	 
	 ```
	 type.tags[.osType]?.first
	 ```
	 */
	var preferredOSType: String? {
		tags[.osType]?.first
	}
}
