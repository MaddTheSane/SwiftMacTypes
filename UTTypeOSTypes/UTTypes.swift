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
	
	/**
			Create a type given an OSType.
	
			- Parameters:
				- osType: The legacy OSType for which a type is
					desired.
				- supertype: Another type that the resulting type must conform to.
					Typically, you would pass `.data`.
	
			- Returns: A type. If no types are known to the system with the
				specified OS Type file code and conformance but the inputs were
				otherwise valid, a dynamic type may be provided. If the inputs were
				not valid, returns `nil`.
	
			This method is equivalent to:
	
			```
			UTType(tag: osType, tagClass: .osType, conformingTo: supertype)
			```
	
			To get the type of a file on disk, use `URLResourceValues.contentType`.
			You should not attempt to derive the type of a file system object based
			solely on its OSType file type.
		*/
	init?(osType: String, conformingTo supertype: UTType = .data) {
		self.init(tag: osType, tagClass: .osType, conformingTo: supertype)
	}
}
