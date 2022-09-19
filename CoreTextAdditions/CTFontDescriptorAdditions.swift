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
	
	/// Font attributes key.
	enum AttributeKey: RawRepresentable, Hashable, CustomStringConvertible, Codable {
		public typealias RawValue = CFString
		
		public var description: String {
			return rawValue as String
		}
		
		public var rawValue: CFString {
			if #available(macOS 10.13, *) {
				if self == .variationAxes {
					return kCTFontVariationAxesAttribute
				}
			}
			switch self {
			case .URL:
				return kCTFontURLAttribute
			case .name:
				return kCTFontNameAttribute
			case .displayName:
				return kCTFontDisplayNameAttribute
			case .familyName:
				return kCTFontFamilyNameAttribute
			case .styleName:
				return kCTFontStyleNameAttribute
			case .traits:
				return kCTFontTraitsAttribute
			case .variation:
				return kCTFontVariationAttribute
			case .variationAxes:
				fatalError("We should not be getting here!")
			case .size:
				return kCTFontSizeAttribute
			case .matrix:
				return kCTFontMatrixAttribute
			case .cascadeList:
				return kCTFontCascadeListAttribute
			case .characterSet:
				return kCTFontCharacterSetAttribute
			case .languages:
				return kCTFontLanguagesAttribute
			case .baselineAdjust:
				return kCTFontBaselineAdjustAttribute
			case .macintoshEncodings:
				return kCTFontMacintoshEncodingsAttribute
			case .features:
				return kCTFontFeaturesAttribute
			case .featureSettings:
				return kCTFontFeatureSettingsAttribute
			case .fixedAdvance:
				return kCTFontFixedAdvanceAttribute
			case .orientation:
				return kCTFontOrientationAttribute
			}
		}
		
		public init?(rawValue: CFString) {
			if #available(macOS 10.13, *) {
				if rawValue == kCTFontVariationAxesAttribute {
					self = .variationAxes
					return
				}
			}
			switch rawValue {
			case kCTFontURLAttribute:
				self = .URL
				
			case kCTFontNameAttribute:
				self = .name
				
			case kCTFontDisplayNameAttribute:
				self = .displayName
				
			case kCTFontFamilyNameAttribute:
				self = .familyName
				
			case kCTFontStyleNameAttribute:
				self = .styleName
				
			case kCTFontTraitsAttribute:
				self = .traits
				
			case kCTFontVariationAttribute:
				self = .variation
				
			case kCTFontSizeAttribute:
				self = .size
				
			case kCTFontMatrixAttribute:
				self = .matrix
				
			case kCTFontCascadeListAttribute:
				self = .cascadeList
				
			case kCTFontCharacterSetAttribute:
				self = .characterSet
				
			case kCTFontLanguagesAttribute:
				self = .languages
				
			case kCTFontBaselineAdjustAttribute:
				self = .baselineAdjust
				
			case kCTFontMacintoshEncodingsAttribute:
				self = .macintoshEncodings
				
			case kCTFontFeaturesAttribute:
				self = .features
				
			case kCTFontFeatureSettingsAttribute:
				self = .featureSettings
				
			case kCTFontFixedAdvanceAttribute:
				self = .fixedAdvance
				
			case kCTFontOrientationAttribute:
				self = .orientation
				
			default:
				return nil
			}
		}
		
		/// The font URL.
		///
		/// This is the key for accessing the font URL from the font descriptor. The value associated with this key is a `CFURL`.
		case URL
		
		/// The PostScript name.
		///
		/// This is the key for retrieving the PostScript name from the font descriptor. When matching, this is treated
		/// more generically: the system first tries to find fonts with this PostScript name. If none is found, the system
		/// tries to find fonts with this family name, and, finally, if still nothing, tries to find fonts with this display name.
		/// The value associated with this key is a `CFString`. If unspecified, defaults to "Helvetica", if unavailable
		/// falls back to global font cascade list.
		case name
		
		/// The display name.
		///
		/// This is the key for accessing the name used to display the font. Most commonly this is the full name. The
		/// value associated with this key is a `CFString`.
		case displayName
		
		/// The family name.
		///
		/// This is the key for accessing the family name from the font descriptor. The value associated with this key is a `CFString`.
		case familyName
		
		/// The style name.
		///
		/// This is the key for accessing the style name of the font. This name represents the designer's description of the font's style.
		/// The value associated with this key is a `CFString`.
		case styleName
		
		/// The font traits dictionary.
		///
		/// This is the key for accessing the dictionary of font traits for stylistic information. See *CTFontTraits.h* for the list of font
		/// traits. The value associated with this key is a `CFDictionary`.
		case traits
		
		/// The font variation dictionary.
		///
		/// This key is used to obtain the font variation instance as a `CFDictionary`. If specified in a font descriptor, fonts
		/// with the specified axes will be primary match candidates, if no such fonts exist, this attribute will be ignored.
		case variation
		
		/// An array of variation axis dictionaries or null if the font does not support variations. Each variation axis dictionary contains
		/// the five `kCTFontVariationAxis*` keys.
		@available(macOS 10.13, iOS 11.0, watchOS 4.0, tvOS 11.0, *)
		case variationAxes
		
		/// The font point size.
		///
		/// This key is used to obtain or specify the font point size. Creating a font with this unspecified will default to a point
		/// size of *12.0*. The value for this key is represented as a `CFNumber`.
		case size
		
		/// The font transformation matrix.
		///
		/// This key is used to specify the font transformation matrix when creating a font. The default
		/// value is `CGAffineTransformIdentity`. The value for this key is a `CFDataRef` containing
		/// a `CGAffineTransform`, of which only the *a*, *b*, *c*, and d fields are used.
		case matrix
		
		/// The font cascade list.
		///
		/// This key is used to specify or obtain the cascade list used for a font reference. The cascade list is a
		/// `CFArray` containing `CTFontDescriptor`s. If unspecified, the global cascade list is used. This
		/// list is not consulted for private-use characters on OS X 10.10, iOS 8, or earlier.
		case cascadeList
		
		/// The font Unicode character coverage set.
		///
		/// The value for this key is a `CFCharacterSet`. Creating a font with this attribute will restrict the font to a
		/// subset of its actual character set.
		case characterSet
		
		/// The list of supported languages.
		///
		/// The value for this key is a `CFArray` of `CFString` language identifiers conforming to *UTS #35*. It can
		/// be requested from any font. If present in a descriptor used for matching, only fonts supporting the specified
		/// languages will be returned.
		case languages
		
		/// The baseline adjustment to apply to font metrics.
		///
		/// The value for this key is a floating-point `CFNumber`. This is primarily used when defining font descriptors for
		/// a cascade list to keep the baseline of all fonts even.
		case baselineAdjust
		
		/// The Macintosh encodings (legacy script codes).
		///
		/// The value associated with this key is a `CFNumber` containing a bitfield of the script codes in
		/// <CoreText/SFNTTypes.h>; bit 0 corresponds to `kFontRomanScript`, and so on. This attribute is provided for legacy compatibility.
		case macintoshEncodings
		
		/// The array of font features.
		///
		/// This key is used to specify or obtain the font features for a font reference. The value associated with this key
		/// is a `CFArray` of font feature dictionaries. This features list contains the feature information
		/// from the **'feat'** table of the font. See the `CTFontCopyFeatures()` API in   *CTFont.h*.
		case features
		
		/// The array of typographic feature settings.
		///
		/// This key is used to specify an array of zero or more feature settings. Each setting dictionary indicates which setting should
		/// be applied. In the case of duplicate or conflicting settings the last setting in the list will take precedence. In the case of AAT
		/// settings, it is the caller's responsibility to handle exclusive and non-exclusive settings as necessary.
		/// An AAT setting dictionary contains a tuple of a `kCTFontFeatureTypeIdentifierKey` key-value pair and a `kCTFontFeatureSelectorIdentifierKey` key-value pair.
		/// 			An OpenType setting dictionary contains a tuple of a `kCTFontOpenTypeFeatureTag` key-value pair and a `kCTFontOpenTypeFeatureValue` key-value pair.
		///
		///  Starting with OS X 10.10 and iOS 8.0, settings are also accepted (but not returned) in the following simplified forms:
		///  An OpenType setting can be either an array pair of tag string and value number, or a tag string on its own. For example: `@[ @"c2sc", @1 ]` or simply `@"c2sc"`. An unspecified value enables the feature and a value of zero disables it.
		///  An AAT setting can be specified as an array pair of type and selector numbers. For example: `@[ @(kUpperCaseType), @(kUpperCaseSmallCapsSelector) ]`.
		case featureSettings
		
		/// Specifies advance width.
		///
		/// This key is used to specify a constant advance width, which affects the glyph metrics of any font instance created
		/// with this key; it overrides font values and the font transformation matrix, if any. The value associated with this
		/// key must be a `CFNumber`.
		///
		/// Starting with macOS 10.14 and iOS 12.0, this only affects glyph advances that have non-zero width when this attribute is not present.
		case fixedAdvance
		
		/// The orientation attribute.
		///
		/// This key is used to specify a particular orientation for the glyphs of the font. The value associated with this key is a int
		/// as a `CFNumber`. If you want to receive vertical metrics from a font for vertical rendering, specify
		/// `kCTFontVerticalOrientation`. If unspecified, the font will use its native orientation.
		case orientation
	}
	
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
	func attribute(forKey key: AttributeKey) -> Any? {
		return CTFontDescriptorCopyAttribute(self, key.rawValue) as Any?
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
	func descriptorMatching(attributes: Set<AttributeKey>?) -> CTFontDescriptor? {
		var attrSet: NSSet?
		if let attrs = attributes {
			let preset = Set(attrs.map({$0.rawValue}))
			attrSet = preset as NSSet
		} else {
			attrSet = nil
		}
		return CTFontDescriptorCreateMatchingFontDescriptor(self, attrSet)
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
	func descriptorsMatching(attributes: Set<AttributeKey>?) -> [CTFontDescriptor]? {
		var attrSet: NSSet?
		if let attrs = attributes {
			let preset = Set(attrs.map({$0.rawValue}))
			attrSet = preset as NSSet
		} else {
			attrSet = nil
		}
		return CTFontDescriptorCreateMatchingFontDescriptors(self, attrSet) as! [CTFontDescriptor]?
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
