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
	
	@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
	func testAttributeScopes() {
		var attrStr = AttributedString("Color")
		attrStr.foregroundColor = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)
		
		do {
			let nsAttr = try NSAttributedString(attrStr, including: AttributeScopes.CoreTextAttributes.self)
			print(nsAttr)
			attrStr.foregroundColor = nil
			print(attrStr)
			let attrStr1 = try AttributedString(nsAttr, including: AttributeScopes.CoreTextAttributes.self)
			let nsAttr2 = NSMutableAttributedString(string: "Color")
			nsAttr2.addAttribute(NSAttributedString.Key.CoreText.foregroundColor, value: CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1), range: NSRange(location: 0, length: 5))
			let attrStr2 = try AttributedString(nsAttr2, including: AttributeScopes.CoreTextAttributes.self)
			print(attrStr1)
			print(attrStr2)
//			XCTAssertNotEqual(attrStr1, attrStr)
//			XCTAssertEqual(attrStr1, attrStr2)
		} catch {
			XCTFail("")
		}
	}
	
	func testFeatures() {
		let aFont = CTFont.create(withName: "Times New Roman", size: 0)
		let aFeat = aFont.features
		XCTAssertNotNil(aFeat)
		guard let aFeat else {
			return
		}
		print(aFeat)
	}
	
	func testTables() {
		let aFont = CTFont.create(withName: "Times New Roman", size: 12)
		guard let tables = aFont.availableTables() else {
			XCTFail("Times should at least have tables...")
			return
		}
		print(tables)
	}
	
	/// This tests "PostCrypt", a PostScript Type 1 outline font.
	///
	/// As there's no reliable way to store an old, Mac-style PostScript outlines on git,
	/// let's use the PC's way of storing PostScript outlines
	func testNoTables() {
		guard let PCURL = Bundle(for: type(of: self)).url(forResource: "PostCrypt", withExtension: "pfb") else {
			XCTFail("PostCrypt should at least be findable...")
			return
		}

		guard let datProvid = CGDataProvider(url: PCURL as NSURL),
			  let cgFont = CGFont(datProvid) else {
			XCTFail("Creation of the PostScript CGFont failed...")
			return
		}
		let graphFont = CTFont.create(graphicsFont: cgFont, size: 12)
		
		if let tables2 = graphFont.availableTables() {
			XCTFail("We got tables… \(tables2)")
			return
		}
	}
}
