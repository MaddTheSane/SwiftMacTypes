//
//  CTFontDescriptorAdditions.swift
//  CoreTextAdditions
//
//  Created by C.W. Betts on 10/19/17.
//  Copyright © 2017 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText

public extension CTFontDescriptor {
	/// The attributes dictionary of the font descriptor.
	///
	/// The font descriptor attributes dictionary. This dictionary contains the minimum
	/// number of attributes to specify fully this particular font descriptor.
	var attributes: [String: Any] {
		return CTFontDescriptorCopyAttributes(self) as! [String : Any]
	}
	
	/// Returns the value associated with an arbitrary attribute.
	/// - parameter key: The requested attribute.
	/// - returns: A reference to an arbitrary attribute, or `nil` if the requested
	/// attribute is not present.
	func attribute(forKey key: String) -> Any? {
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
	func descriptorMatching(attributes: Set<String>?) -> CTFontDescriptor? {
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
	func descriptorsMatching(attributes: Set<String>?) -> [CTFontDescriptor]? {
		return CTFontDescriptorCreateMatchingFontDescriptors(self, attributes as NSSet?) as! [CTFontDescriptor]?
	}
	
	/// Copies a font descriptor with new feature setting.
	///
	/// This is a convenience method to more easily toggle the state of individual features.
	/// - parameter featureTypeIdentifier: The feature type identifier.
	/// - parameter featureSelectorIdentifier: The feature selector identifier.
	/// - returns: A copy of the original font descriptor modified with the given feature settings.
	@available(macOS 10.5, iOS 3.2, watchOS 2.0, tvOS 9.0, *)
	@inlinable func copyWithFeature(type featureTypeIdentifier: CFNumber, selector featureSelectorIdentifier: CFNumber) -> CTFontDescriptor {
		return CTFontDescriptorCreateCopyWithFeature(self, featureTypeIdentifier, featureSelectorIdentifier)
	}

	/// Creates a copy of the original font descriptor with a new variation instance.
	/// - parameter variationIdentifier: The variation axis identifier. This is the four
	/// character code of the variation axis as an `OSType`.
	/// - parameter variationValue: The value corresponding with the variation instance.
	/// - returns: This function returns a copy of the original font descriptor with a new variation instance.
	/// This is a convenience method for easily creating new variation font instances.
	@available(macOS 10.5, iOS 3.2, watchOS 2.0, tvOS 9.0, *)
	func copyWithVariation(identifier variationIdentifier: OSType, value variationValue: CGFloat) -> CTFontDescriptor {
		return CTFontDescriptorCreateCopyWithVariation(self, NSNumber(value: variationIdentifier), variationValue)
	}
	
	/// Returns a new font descriptor based on the original descriptor having the specified symbolic traits.
	/// - parameter symTraitValue: The value of the symbolic traits. This bitfield is used to indicate
	/// the desired value for the traits specified by the `symTraitMask` parameter. Used in conjunction,
	/// they can allow for trait removal as well as addition.
	/// - parameter symTraitMask: The mask bits of the symbolic traits. This bitfield is used to indicate the
	/// traits that should be changed.
	/// - returns: Returns a new font descriptor reference in the same family with the given symbolic traits,
	/// or `nil` if none found in the system.
	@available(macOS 10.9, iOS 7.0, watchOS 2.0, tvOS 9.0, *)
	@inlinable func copyWithSymbolicTraits(value symTraitValue: CTFont.SymbolicTraits, mask symTraitMask: CTFont.SymbolicTraits) -> CTFontDescriptor? {
		return CTFontDescriptorCreateCopyWithSymbolicTraits(self, symTraitValue, symTraitMask)
	}

	/// Returns a new font descriptor in the specified family based on the traits of the original descriptor.
	/// - parameter family: The name of the desired family.
	/// - returns: Returns a new font reference with the original traits in the given family,
	/// or `nil` if none found in the system.
	@available(macOS 10.9, iOS 7.0, watchOS 2.0, tvOS 9.0, *)
	func copy(withFamily family: String) -> CTFontDescriptor? {
		return CTFontDescriptorCreateCopyWithFamily(self, family as NSString)
	}

	/// Creates a copy of the original font descriptor with new attributes.
	/// - parameter attributes: A CFDictionaryRef of arbitrary attributes.
	/// - returns: This function creates a new copy of the original font descriptor with attributes augmented
	/// by those specified. If there are conflicts between attributes, the new attributes will replace existing ones,
	/// except for `kCTFontVariationAttribute` and `kCTFontFeatureSettingsAttribute` which
	/// will be merged.
	///
	/// Starting with macOS 10.12 and iOS 10.0, setting the value of `kCTFontFeatureSettingsAttribute`
	/// to `kCFNull` will clear the feature settings of the original font descriptor. Setting the value of any individual
	/// feature settings pair in the `kCTFontFeatureSettingsAttribute` value array to `kCFNull` will clear
	/// that feature setting alone. For example, an element like
	/// `@{ (id)kCTFontFeatureTypeIdentifierKey: @(kLigaturesType), (id)kCTFontFeatureSelectorIdentifierKey: (id)kCFNull }`
	/// means clear the `kLigatureType` feature set in the original font descriptor. An element
	/// like `@[ @"liga", (id)kCFNull ]` will have the same effect.
	@available(macOS 10.5, iOS 3.2, watchOS 2.0, tvOS 9.0, *)
	func copy(withAttributes attributes: [String: Any]) -> CTFontDescriptor {
		return CTFontDescriptorCreateCopyWithAttributes(self, attributes as NSDictionary)
	}
}
