//
//  CTFontDescriptorAdditions.swift
//  CoreTextAdditions
//
//  Created by C.W. Betts on 10/19/17.
//  Copyright © 2017 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText

extension CTFontDescriptor {
	public var attributes: [String: Any] {
		return CTFontDescriptorCopyAttributes(self) as! [String : Any]
	}
	
	public func attribute(forKey key: String) -> Any? {
		return CTFontDescriptorCopyAttribute(self, key as CFString) as Any?
	}
	//CTFontDescriptorCreateMatchingFontDescriptor
	
	public func descriptorMatching(attributes: Set<String>?) -> CTFontDescriptor? {
		return CTFontDescriptorCreateMatchingFontDescriptor(self, attributes as NSSet?)
	}
	
	public func descriptorsMatching(attributes: Set<String>?) -> [CTFontDescriptor]? {
		return CTFontDescriptorCreateMatchingFontDescriptors(self, attributes as NSSet?) as! [CTFontDescriptor]?
	}

}
