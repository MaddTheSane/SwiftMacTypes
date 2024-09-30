//
//  SwiftAdditionsTests.swift
//  SwiftAdditionsTests
//
//  Created by C.W. Betts on 8/22/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftAdditions
@testable import FoundationAdditions

class SwiftAdditionsTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testNSUUIDTranslators() {
		let aUUID = NSUUID()
		let aCFUUID = aUUID.cfUUID
		let bUUID = NSUUID(cfUUID: aCFUUID)
		XCTAssertEqual(aUUID, bUUID)
	}
	
	func testUUIDTranslators() {
		let aUUID = UUID()
		let aCFUUID = aUUID.cfUUID
		let bUUID = UUID(cfUUID: aCFUUID)
		XCTAssertEqual(aUUID, bUUID)
	}
	
	func testSubStringFunction() {
		//Simple ASCII string: both representations should be the same
		var testString = "hi How are you today?"
		var subString = testString.substringWithLength(utf8: 10)
		var subString2 = testString.substringWithLength(utf16: 10)
		XCTAssertEqual(subString, subString2)
		
		//Emoji-heavy string. UTF-16 gets more than UTF-8
		testString = "hi 🙃🐱🦄  🌊🎮🎯🚵🏹"
		subString = testString.substringWithLength(utf8: 10)
		subString2 = testString.substringWithLength(utf16: 10)
		XCTAssertNotEqual(subString, subString2)
		
		//Simple, short non-ASCII string
		testString = "Olé"
		subString = testString.substringWithLength(utf8: 10)
		XCTAssertEqual(testString, subString)
		subString2 = testString.substringWithLength(utf16: 10)
		XCTAssertEqual(testString, subString2)
		XCTAssertEqual(subString2, subString)
		
		//bounds testing
		testString = "Résumé"
		subString = testString.substringWithLength(utf8: 6)
		subString2 = testString.substringWithLength(utf8: 7)
		XCTAssertEqual(subString2, subString)
		subString = testString.substringWithLength(utf16: 6)
		subString2 = testString.substringWithLength(utf16: 7)
		XCTAssertEqual(testString, subString2)
		XCTAssertEqual(subString, subString2)
		
		//Emoji-only string. Should get a blank string back
		testString = "🙃🐱🦄  🌊🎮🎯🚵🏹"
		subString = testString.substringWithLength(utf8: 2)
		subString2 = testString.substringWithLength(utf16: 1)
		XCTAssertEqual("", subString)
		XCTAssertEqual("", subString2)
	}
	
	func testNSNumberCocoaComparable() {
		let num1 = NSNumber(value: 9)
		let num2 = NSNumber(value: 9.0)
		let num3 = NSNumber(value: 7)
		let num4 = NSNumber(value: 8)
		var numArr = [num1, num3, num4]
		
		XCTAssert(num1 >= num2)
		XCTAssert(num1 <= num2)
		XCTAssert(num1 == num2)
		XCTAssert(num1 > num4)
		XCTAssertFalse(num1 < num4)
		XCTAssert(num1 >= num4)
		numArr.sort()
		XCTAssertEqual(numArr, [num3, num4, num2])
	}
}
