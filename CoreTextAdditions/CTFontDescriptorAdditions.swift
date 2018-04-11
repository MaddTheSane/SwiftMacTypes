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
	/// The attributes dictionary of the font descriptor.
	///
	/// The font descriptor attributes dictionary. This dictionary contains the minimum
	/// number of attributes to specify fully this particular font descriptor.
	public var attributes: [String: Any] {
		return CTFontDescriptorCopyAttributes(self) as! [String : Any]
	}
	
	/// Returns the value associated with an arbitrary attribute.
	/// - parameter key: The requested attribute.
	/// - returns: A reference to an arbitrary attribute, or `nil` if the requested
	/// attribute is not present.
	public func attribute(forKey key: String) -> Any? {
		return CTFontDescriptorCopyAttribute(self, key as CFString) as Any?
	}
	
	/// Returns the single preferred matching font descriptor based on the original 
	/// descriptor and system precedence.
	/// - parameter attributes: A set of attribute keys that must be identically matched
	/// in any returned font descriptors. May be `nil`.
	/// - returns: A normalized font descriptor matching the attributes present in
	/// descriptor, or `nil` on error.
	///
	/// The original descriptor may be returned in normalized form. In the context of font
	/// descriptors, *normalized* infers that the input values were matched up with actual
	/// existing fonts, and the descriptors for those existing fonts are the returned
	/// normalized descriptors.
	public func descriptorMatching(attributes: Set<String>?) -> CTFontDescriptor? {
		return CTFontDescriptorCreateMatchingFontDescriptor(self, attributes as NSSet?)
	}
	
	/// Returns an array of normalized font descriptors matching the provided descriptor.
	/// - parameter attributes: A set of attribute keys that must be identically matched
	/// in any returned font descriptors. May be `nil`.
	/// - returns: An array of normalized font descriptors matching the attributes present
	/// in this descriptor, or `nil` on error.
	///
	/// If this is already normalized, then the array will contain only one item: this
	/// descriptor. In the context of font descriptors, *normalized* infers that the input
	/// values were matched up with actual existing fonts, and the descriptors for those
	/// existing fonts are the returned normalized descriptors.
	public func descriptorsMatching(attributes: Set<String>?) -> [CTFontDescriptor]? {
		return CTFontDescriptorCreateMatchingFontDescriptors(self, attributes as NSSet?) as! [CTFontDescriptor]?
	}
}
