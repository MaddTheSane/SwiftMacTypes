//
//  CoreTextAdditionsTests.swift
//  CoreTextAdditionsTests
//
//  Created by C.W. Betts on 11/4/17.
//  Copyright © 2017 C.W. Betts. All rights reserved.
//

import XCTest
@testable import CoreTextAdditions
@testable import CoreTextAdditions.CTAFontManagerErrors

class CoreTextAdditionsTests: XCTestCase {
	
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
	
	func testFontNames() {
		let names = FontManager.availableFontFamilyNames
		print(names)
	}
	
	func testPSNames() {
		let names = FontManager.availablePostScriptNames
		print(names)
	}
	
	func testFontURLs() {
		let names = FontManager.availableFontURLs
		print(names)
	}
	
	func testFontThing() {
		let wmfURL = URL(fileURLWithPath: "/System/Library/Fonts/Times.ttc")
		guard let fd = FontManager.fontDescriptors(from: wmfURL) else {
			XCTFail("")
			return
		}
		print(fd)
		for desc in fd {
			let aFont = CTFont.create(with: desc, size: 14)
			print(aFont)
		}
	}
	
	func testFeatures() {
		let aFont = CTFont.create(withName: "Times", size: 0)
		print(aFont.features!)
	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}
}
