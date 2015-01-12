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
		XCTAssert(inferredBo == bo)
	}
	
	func testIndexSetGenerator() {
		var intTest = [Int]()
		
		let idxSet = NSMutableIndexSet(indexesInRange: NSRange(1..<8))
		
		idxSet.addIndex(100)
		idxSet.addIndex(80)
		idxSet.addIndex(200)
		idxSet.addIndex(10)
		idxSet.addIndex(5)
		
		for i in idxSet {
			intTest.append(i)
		}
	}
}
