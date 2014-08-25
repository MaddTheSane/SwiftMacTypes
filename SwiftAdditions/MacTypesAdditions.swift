//
//  PlayerPROCoreAdditions.swift
//  PPMacho
//
//  Created by C.W. Betts on 7/24/14.
//
//

import Darwin.MacTypes
import Foundation
import CoreServices

extension String {
	init(pascalString pStr: StringPtr, encoding: CFStringEncoding = CFStringEncoding(CFStringBuiltInEncodings.MacRoman.toRaw())) {
		var theStr = CFStringCreateWithPascalString(kCFAllocatorDefault, pStr, encoding)
		self.init(theStr as NSString as String)
	}
	
	init(_ pStr: StringPtr) {
		self.init(pascalString: pStr)
	}
}

extension OSType: Printable {
	public var stringValue: String {
	get {
		let toRet = UTCreateStringForOSType(self).takeRetainedValue()
		return toRet as NSString
	}
	}
	
	init(_ toInit: String) {
		self = UTGetOSTypeFromString(toInit as NSString as CFStringRef)
	}
	
	static func convertFromStringLiteral(value: String) -> OSType {
		return OSType(value)
	}
	
	public var description: String { get {
		return self.stringValue
	}}

}

func &(lhs: Boolean, rhs: Boolean) -> Boolean {
	if lhs {
		return rhs
	}
	return false
}

func |(lhs: Boolean, rhs: Boolean) -> Boolean {
	if lhs {
		return true
	}
	return rhs
}

func ^(lhs: Boolean, rhs: Boolean) -> Boolean {
	return Boolean(lhs != rhs)
}

@prefix func !(a: Boolean) -> Boolean {
	return a ^ true
}

func &=(inout lhs: Boolean, rhs: Boolean) {
	var lhsB: Boolean = 0
	var rhsB: Boolean = 0
	if lhs {
		lhsB = 1
	}
	if rhs {
		rhsB = 1
	}
	lhs = lhsB & rhsB
}

extension Boolean : BooleanLiteralConvertible, LogicValue {
	init(_ v : LogicValue) {
		if v.getLogicValue() {
			self = 1
		} else {
			self = 0
		}
	}
	
	public static func convertFromBooleanLiteral(value: BooleanLiteralType) -> Boolean {
		if (value == true) {
			return 1
		} else {
			return 0
		}
	}
	
	public func getLogicValue() -> Bool {
		if (self == 0) {
			return false
		} else {
			return true
		}
	}
}
