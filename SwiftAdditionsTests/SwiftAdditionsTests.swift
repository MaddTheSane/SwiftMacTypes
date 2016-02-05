//
//  SwiftAdditionsTests.swift
//  SwiftAdditionsTests
//
//  Created by C.W. Betts on 8/22/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Cocoa
import XCTest
import SwiftAdditions

class SwiftAdditionsTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testByteOrder() {
		let bo = Int(OSHostByteOrder())
		var inferredBo: Int
		
		switch currentByteOrder {
		case .Big:
			inferredBo = OSBigEndian
			break
			
		case .Little:
			inferredBo = OSLittleEndian
			break
			
		case .Unknown:
			inferredBo = OSUnknownByteOrder
			break
		}
		XCTAssertEqual(inferredBo, bo)
	}
	
	func testUUIDTranslators() {
		let aUUID = NSUUID()
		let aCFUUID = aUUID.CFUUID
		let bUUID = NSUUID(CFUUID: aCFUUID)
		XCTAssertEqual(aUUID, bUUID)
	}
}
