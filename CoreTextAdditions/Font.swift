//
//  CTFontAdditions.swift
//  CoreTextAdditions
//
//  Created by C.W. Betts on 10/18/17.
//  Copyright © 2017 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText
import SwiftAdditions

public final class Font: CustomStringConvertible, CustomDebugStringConvertible {
	// The font object used internally.
	public let internalFont: CTFont
	
	/// Options for descriptor match and font creation.
	public typealias Options = CTFontOptions
	
	/// These constants represent the specific user interface purpose to specify for font creation.
	///
	/// Use these constants with `Font(uiType:size:forLanguage:)` to indicate the intended user interface usage of the font reference to be created.
	public typealias UIFontType = CTFontUIFontType
	
	/// These constants describe font table options.
	public typealias TableOptions = CTFontTableOptions
	
	/// Specifies the intended rendering orientation of the font for obtaining glyph metrics.
	public typealias Orientation = CTFontOrientation
	
	private init(ctFont: CTFont) {
		internalFont = ctFont
	}
	
	public var description: String {
		return "\(fullName), version \(name(ofKey: .version) ?? "<none>")"
	}
	
	public var debugDescription: String {
		return CFCopyDescription(internalFont)! as String
	}
	
	// MARK: - Font Constants
	/*! --------------------------------------------------------------------------
	@group Font Constants
	*/
	//--------------------------------------------------------------------------
	
	public enum FontNameKey: CustomStringConvertible {
		/// The name specifier for the copyright name.
		case copyright
		
		/// The name specifier for the family name.
		case family
		
		/// The name specifier for the subfamily name.
		case subFamily
		
		/// The name specifier for the style name.
		case style
		
		/// The name specifier for the unique name.
		///
		/// Note that this name is often not unique and should not be
		/// assumed to be truly unique.
		case unique
		
		/// The name specifier for the full name.
		case full
		
		/// The name specifier for the version name.
		case version
		
		/// The name specifier for the PostScript name.
		case postScript
		
		/// The name specifier for the trademark name.
		case trademark
		
		/// The name specifier for the manufacturer name.
		case manufacturer
		
		/// The name specifier for the designer name.
		case designer
		
		/// The name specifier for the description name.
		case fontDescription
		
		/// The name specifier for the vendor url name.
		case vendorURL
		
		/// The name specifier for the designer url name.
		case designerURL
		
		/// The name specifier for the license name.
		case license
		
		/// The name specifier for the license url name.
		case licenseURL
		
		/// The name specifier for the sample text name string.
		case sampleText
		
		/// The name specifier for the PostScript CID name.
		case postScriptCID
		
		/// Creates a `FontNameKey` from s supplied string.
		/// If `stringValue` doesn't match any of the `kCTFont...NameKey`s, returns `nil`.
		/// - parameter stringValue: The string value to attempt to init `FontNameKey` from.
		public init?(stringValue: String) {
			switch stringValue {
			case (kCTFontCopyrightNameKey as NSString as String):
				self = .copyright
				
			case (kCTFontFamilyNameKey as NSString as String):
				self = .family

			case (kCTFontSubFamilyNameKey as NSString as String):
				self = .subFamily

			case (kCTFontStyleNameKey as NSString as String):
				self = .style

			case (kCTFontUniqueNameKey as NSString as String):
				self = .unique

			case (kCTFontFullNameKey as NSString as String):
				self = .full

			case (kCTFontVersionNameKey as NSString as String):
				self = .version

			case (kCTFontPostScriptNameKey as NSString as String):
				self = .postScript

			case (kCTFontCopyrightNameKey as NSString as String):
				self = .copyright

			case (kCTFontTrademarkNameKey as NSString as String):
				self = .trademark
				
			case (kCTFontManufacturerNameKey as NSString as String):
				self = .manufacturer
				
			case (kCTFontDesignerNameKey as NSString as String):
				self = .designer
				
			case (kCTFontDescriptionNameKey as NSString as String):
				self = .fontDescription
				
			case (kCTFontVendorURLNameKey as NSString as String):
				self = .vendorURL
				
			case (kCTFontDesignerURLNameKey as NSString as String):
				self = .designerURL
				
			case (kCTFontLicenseNameKey as NSString as String):
				self = .license
				
			case (kCTFontLicenseURLNameKey as NSString as String):
				self = .licenseURL
				
			case (kCTFontSampleTextNameKey as NSString as String):
				self = .sampleText
				
			case (kCTFontPostScriptCIDNameKey as NSString as String):
				self = .postScriptCID

			default:
				return nil
			}
		}
		
		var cfString: CFString {
			switch self {
			case .copyright:
				return kCTFontCopyrightNameKey
				
			case .family:
				return kCTFontFamilyNameKey
				
			case .subFamily:
				return kCTFontSubFamilyNameKey
				
			case .style:
				return kCTFontStyleNameKey
				
			case .unique:
				return kCTFontUniqueNameKey
				
			case .full:
				return kCTFontFullNameKey
				
			case .version:
				return kCTFontVersionNameKey
				
			case .postScript:
				return kCTFontPostScriptNameKey
				
			case .trademark:
				return kCTFontTrademarkNameKey
				
			case .manufacturer:
				return kCTFontManufacturerNameKey
				
			case .designer:
				return kCTFontDesignerNameKey
				
			case .fontDescription:
				return kCTFontDescriptionNameKey
				
			case .vendorURL:
				return kCTFontVendorURLNameKey
				
			case .designerURL:
				return kCTFontDesignerURLNameKey
				
			case .license:
				return kCTFontLicenseNameKey
				
			case .licenseURL:
				return kCTFontLicenseURLNameKey
				
			case .sampleText:
				return kCTFontSampleTextNameKey
				
			case .postScriptCID:
				return kCTFontPostScriptCIDNameKey
			}
		}
		
		public var description: String {
			return cfString as String
		}
	}
	
	// MARK: - Font Creation
	/*! --------------------------------------------------------------------------
	@group Font Creation
	*/
	//--------------------------------------------------------------------------
	
	/// Creates a new font reference for the given name.
	///
	/// This function uses font descriptor matching so only registered fonts can be returned; see *CTFontManager.h* for more information.
	/// - parameter name: The font name for which you wish to create a new font reference. A valid PostScript name is preferred, although other font name types will be matched in a fallback manner.
	/// - parameter size: The point size for the font reference. If `0.0` is specified, the default font size of `12.0` will be used.
	/// - parameter matrix: The transformation matrix for the font. If `nil`, the identity matrix will be used. Optional.<br>
	/// Default value is `nil`.
	/// - parameter options: Options flags.<br>
	/// Default is empty.
	///
	/// Will return a `Font` that best matches the `name` provided with `size` and `matrix` attributes. The `name` parameter is the only required parameters, and default values will be used for unspecified parameters. A best match will be found if all parameters cannot be matched identically.
	@available(OSX 10.5, *)
	public convenience init(name: String, size: CGFloat, matrix: CGAffineTransform? = nil, options: Options = []) {
		let aFont: CTFont
		if var matrix = matrix {
			aFont = CTFontCreateWithNameAndOptions(name as NSString, size, &matrix, options)
		} else {
			aFont = CTFontCreateWithNameAndOptions(name as NSString, size, nil, options)
		}
		self.init(ctFont: aFont)
	}
	
	/// Returns a new font reference that best matches the font descriptor.
	/// - parameter descriptor: A font descriptor containing attributes that specify the requested font.
	/// - parameter size: The point size for the font reference. If `0.0` is specified, the default font size of `12.0` will be used.<br>
	/// - parameter matrix: The transformation matrix for the font. If `nil`, the identity matrix will be used. Optional.<br>
	/// Default value is `nil`.
	/// - parameter options: Options flags.
	/// Default is empty.
	///
	/// Will return a `Font` that best matches the attributes provided with the font descriptor. The `size` and `matrix` parameters will override any specified in the font descriptor, unless they are unspecified. A best match font will always be returned, and default values will be used for any unspecified.
	public convenience init(descriptor: CTFontDescriptor, size: CGFloat, matrix: CGAffineTransform? = nil, options: Options = []) {
		let aFont: CTFont
		if var matrix = matrix {
			aFont = CTFontCreateWithFontDescriptorAndOptions(descriptor, size, &matrix, options)
		} else {
			aFont = CTFontCreateWithFontDescriptorAndOptions(descriptor, size, nil, options)
		}
		self.init(ctFont: aFont)
	}
	
	/// Returns the special UI font for the given language and UI type.
	/// - parameter uiType: A `UIFontType` constant specifying the intended UI use for the requested font reference.
	/// - parameter size: The point size for the font reference. If `0.0` is specified, the default size for the requested `UIFontType` is used.
	/// - parameter language: Language identifier to select a font for a particular localization. If `nil`, the current system language is used. The format of the language identifier should conform to *UTS #35*.
	/// Default value is `nil`.
	///
	/// This creates the correct font for various UI uses. The only required parameter is the `uiType` selector, unspecified optional parameters will use default values.
	public convenience init?(uiType: UIFontType, size: CGFloat, forLanguage language: String? = nil) {
		guard let aFont = CTFontCreateUIFontForLanguage(uiType, size, language as NSString?) else {
			return nil
		}
		self.init(ctFont: aFont)
	}
	
	/// Returns a new font with additional attributes based on the original font.
	/// - parameter size: The point size for the font reference. If `0.0` is specified, the original font's size will be preserved.
	/// - parameter matrix: The transformation matrix for the font. If `nil`, the original font matrix will be preserved.<br>
	/// Default is `nil`.
	/// - parameter attributes: A font descriptor containing additional attributes that the new font should contain.
	///
	/// This function provides a mechanism to quickly change attributes on a given font reference in response to user actions. For instance, the size can be changed in response to a user manipulating a size slider.
	/// - returns: Returns a new font reference converted from the original with the specified attributes.
	public func copy(attributes: CTFontDescriptor?, size: CGFloat, matrix: CGAffineTransform? = nil) -> Font {
		let aFont: CTFont
		if var matrix = matrix {
			aFont = CTFontCreateCopyWithAttributes(internalFont, size, &matrix, attributes)
		} else {
			aFont = CTFontCreateCopyWithAttributes(internalFont, size, nil, attributes)
		}
		return Font(ctFont: aFont)
	}
	
	/// Returns a new font based on the original font with the specified symbolic traits.
	/// - parameter size: The point size for the font reference. If `0.0` is specified, the original font's size will be preserved.
	/// - parameter matrix: The transformation matrix for the font. If `nil`, the original font matrix will be preserved.<br/>
	/// Default is `nil`.
	/// - parameter symTraits: The value of the symbolic traits. This bitfield is used to indicate the desired value for the traits specified by the `.mask` parameter. Used in conjunction, they can allow for trait removal as well as addition.
	/// - returns: a new font reference in the same family with the given symbolic traits, or `nil` if none found in the system.
	public func copy(symbolicTraits symTraits: (traits: CTFontSymbolicTraits, mask: CTFontSymbolicTraits), size: CGFloat, matrix: CGAffineTransform? = nil) -> Font? {
		let aFont: CTFont?
		if var matrix = matrix {
			aFont = CTFontCreateCopyWithSymbolicTraits(internalFont, size, &matrix, symTraits.traits, symTraits.mask)
		} else {
			aFont = CTFontCreateCopyWithSymbolicTraits(internalFont, size, nil, symTraits.traits, symTraits.mask)
		}
		guard let bFont = aFont else {
			return nil
		}

		return Font(ctFont: bFont)
	}
	
	/// Returns a new font in the specified family based on the traits of the original font.
	/// - parameter size: The point size for the font reference. If `0.0` is specified, the original font's size will be preserved.
	/// - parameter matrix: The transformation matrix for the font. If `nil`, the original font matrix will be preserved.<br/>
	/// Default is `nil`
	/// - parameter family: The name of the desired family.
	/// - returns: Returns a new font reference with the original traits in the given family. `nil` if non found in the system.
	public func copy(familyName family: String, size: CGFloat, matrix: CGAffineTransform? = nil) -> Font? {
		let aFont: CTFont?
		if var matrix = matrix {
			aFont = CTFontCreateCopyWithFamily(internalFont, size, &matrix, family as NSString)
		} else {
			aFont = CTFontCreateCopyWithFamily(internalFont, size, nil, family as NSString)
		}
		
		if let aFont = aFont {
			return Font(ctFont: aFont)
		}
		
		return nil
	}
	
	// MARK: - Font Cascading
	/*! --------------------------------------------------------------------------
	@group Font Cascading
	*/
	//--------------------------------------------------------------------------
	
	/// Returns a new font reference that can best map the given string range based on the current font.
	/// - parameter string: A unicode string containing characters that cannot be encoded by the current font.
	/// - parameter range: A range specifying the range of the string that needs to be mapped.
	/// - returns: This function returns the best substitute font that can encode the specified string range.
	///
	/// This function is to be used when the current font does not cover the given range of the string. The current font itself will not be returned, but preference is given to fonts in its cascade list.
	public func font(for string: String, range: Range<String.Index>) -> Font {
		let range2 = NSRange(range, in: string)
		let range1 = range2.cfRange
		let aFont = CTFontCreateForString(internalFont, string as NSString, range1)
		return Font(ctFont: aFont)
	}
	
	/*
	/// Returns a new font reference that can best map the given string range based on the current font.
	/// - parameter string: A unicode string containing characters that cannot be encoded by the current font.
	/// - parameter range: A range specifying the range of the string that needs to be mapped.
	/// - returns: This function returns the best substitute font that can encode the specified string range.
	///
	/// This function is to be used when the current font does not cover the given range of the string. The current font itself will not be returned, but preference is given to fonts in its cascade list.
	public func font<S, R>(for string: S, range: R) -> Font where R : RangeExpression, S : StringProtocol, R.Bound == String.Index, S.Index == String.Index {
		let range2 = NSRange(range, in: string)
		let range1 = CFRangeMake(range2.location, range2.length)
		let aFont = CTFontCreateForString(internalFont, String(string) as NSString, range1)
		return Font(ctFont: aFont)
	}*/

	/// Returns a new font reference that can best map the given string range based on the current font.
	/// - parameter string: A unicode string containing characters that cannot be encoded by the current font.
	/// - parameter range: A range specifying the range of the string that needs to be mapped.
	/// - returns: This function returns the best substitute font that can encode the specified string range.
	///
	/// This function is to be used when the current font does not cover the given range of the string. The current font itself will not be returned, but preference is given to fonts in its cascade list.
	public func font(for string: Substring, range: Range<Substring.Index>) -> Font {
		let range2 = NSRange(range, in: string)
		let range1 = range2.cfRange
		let aFont = CTFontCreateForString(internalFont, string as NSString, range1)
		return Font(ctFont: aFont)
	}

	// MARK: - Font Accessors
	/*! --------------------------------------------------------------------------
	@group Font Accessors
	*/
	//--------------------------------------------------------------------------
	
	/// Returns the normalized font descriptors for the given font reference.
	///
	/// A normalized font descriptor for a font. The font descriptor contains enough information to recreate this font at a later time.
	public var fontDescriptor: CTFontDescriptor {
		return CTFontCopyFontDescriptor(internalFont)
	}
	
	/// Returns the value associated with an arbitrary attribute.
	/// - parameter attribute: The requested attribute.
	/// - returns: If the requested attribute is not present, `nil` is returned. Refer to the attribute definitions for documentation as to how each attribute is packaged as a `CFTypeRef`.
	public func value(for attribute: String) -> Any? {
		return CTFontCopyAttribute(internalFont, attribute as NSString)
	}
	
	/// The point size of the font reference.
	///
	/// This is the point size provided when the font was created.
	public var size: CGFloat {
		return CTFontGetSize(internalFont)
	}
	
	/// The transformation matrix of the font.
	///
	/// This is the matrix that was provided when the font was created.
	public var matrix: CGAffineTransform {
		return CTFontGetMatrix(internalFont)
	}
	
	/// The symbolic font traits.
	///
	/// This getter returns the symbolic traits of the font. This is equivalent to the `kCTFontSymbolicTrait` of traits dictionary. See *CTFontTraits.h* for a definition of the font traits.
	public var symbolicTraits: CTFontSymbolicTraits {
		return CTFontGetSymbolicTraits(internalFont)
	}
	
	/// Returns the font traits dictionary.
	///
	/// Individual traits can be accessed with the trait key constants. See *CTFontTraits.h* for a definition of the font traits.
	public var traits: [String: Any] {
		return CTFontCopyTraits(internalFont) as NSDictionary as! [String: Any]
	}
	
	// MARK: - Font Names
	/*! --------------------------------------------------------------------------
	@group Font Names
	*/
	//--------------------------------------------------------------------------
	
	/// The PostScript name.
	public var postScriptName: String {
		return CTFontCopyPostScriptName(internalFont) as String
	}
	
	/// The family name.
	public var familyName: String {
		return CTFontCopyFamilyName(internalFont) as String
	}
	
	/// The full name.
	public var fullName: String {
		return CTFontCopyFullName(internalFont) as String
	}
	
	/// The localized display name of the font
	public var displayName: String {
		return CTFontCopyDisplayName(internalFont) as String
	}
	
	/// Returns the requested name.
	/// - parameter nameKey: The name specifier. See name specifier constants.
	/// - returns: This function creates the requested name for the font, or `nil` if the font does not have an entry for the requested name. The Unicode version of the name will be preferred, otherwise the first available will be used.
	public func name(ofKey nameKey: FontNameKey) -> String? {
		return CTFontCopyName(internalFont, nameKey.cfString) as String?
	}
	
	/// Returns a localized font name and the actual language, if present.
	/// - parameter nameKey: The name specifier. See name specifier constants.
	/// - returns: This function returns a specific localized name from the font. The name is localized based on the user's global language precedence. If the font does not have an entry for the requested name, NULL will be returned. <br/>
	/// `actualLanguage`: A `String` of the language identifier of the returned name string. The format of the language identifier will conform to *UTS #35*.
	/// If CoreText can supply its own localized string where the font cannot, this value will be `nil`.
	public func localizedName(ofKey nameKey: FontNameKey) -> (name: String, actualLanguage: String?)? {
		var actualName: Unmanaged<CFString>? = nil
		guard let name = CTFontCopyLocalizedName(internalFont, nameKey.cfString, &actualName) as String? else {
			return nil
		}
		return (name, actualName?.takeRetainedValue() as String?)
	}

	// MARK: - Font Encoding
	/*! --------------------------------------------------------------------------
	@group Font Encoding
	*/
	//--------------------------------------------------------------------------

	/// the Unicode character set of the font.
	///
	/// This character set covers the nominal referenced by the font's Unicode *cmap* table (or equivalent).
	public var characterSet: CharacterSet {
		return CTFontCopyCharacterSet(internalFont) as CharacterSet
	}
	
	/// The best string encoding for legacy format support.
	public var stringEncoding: String.Encoding {
		let cfEnc = CTFontGetStringEncoding(internalFont)
		let nsEnc = CFStringConvertEncodingToNSStringEncoding(cfEnc)
		return String.Encoding(rawValue: nsEnc)
	}
	
	/// An array of languages supported by the font.
	///
	/// The array contains language identifier strings as `String`s. The format of the language identifier will conform to *UTS #35*.
	public var supportedLanguages: [String] {
		return CTFontCopySupportedLanguages(internalFont) as NSArray? as! [String]? ?? []
	}
	
	/// Performs basic character-to-glyph mapping.
	///
	/// This function only provides the nominal mapping as specified by the font's Unicode cmap (or equivalent); such mapping does not constitute proper Unicode layout: it is the caller's responsibility to handle the Unicode properties of the characters.
	/// - parameter characters: An array of characters (UTF-16 code units). Non-BMP characters must be encoded as surrogate pairs.
	/// - returns: `glyphs`: Glyphs for non-BMP characters are sparse: the first glyph corresponds to the full character and the second glyph will be `0`. <br/>
	/// `allMapped`: Indicates whether all provided characters were successfully mapped. A return value of true indicates that the font mapped all characters. A return value of false indicates that some or all of the characters were not mapped; glyphs for unmapped characters will be `0` (with the exception of those corresponding non-BMP characters as described above).
	public func glyphs(for characters: [unichar]) -> (glyphs: [CGGlyph], allMapped: Bool) {
		var glyphs = [CGGlyph](repeating: 0, count: characters.count)
		let allMapped = CTFontGetGlyphsForCharacters(internalFont, characters, &glyphs, characters.count)
		return (glyphs, allMapped)
	}
	
	// MARK: - Font Metrics
	/*! --------------------------------------------------------------------------
	@group Font Metrics
	*/
	//--------------------------------------------------------------------------

	/// The scaled font ascent metric.
	///
	/// The font ascent metric scaled based on the point size and matrix of the font reference.
	public var ascent: CGFloat {
		return CTFontGetAscent(internalFont)
	}
	
	/// The scaled font descent metric.
	///
	/// The font descent metric scaled based on the point size and matrix of the font reference.
	public var descent: CGFloat {
		return CTFontGetDescent(internalFont)
	}

	/// The scaled font leading metric.
	///
	/// The font leading metric scaled based on the point size and matrix of the font reference.
	public var leading: CGFloat {
		return CTFontGetLeading(internalFont)
	}
	
	/// The units per em metric.
	///
	/// The units per em of the font.
	public var unitsPerEm: UInt32 {
		return CTFontGetUnitsPerEm(internalFont)
	}
	
	/// The number of glyphs.
	///
	/// The number of glyphs in the font.
	public var countOfGlyphs: Int {
		return CTFontGetGlyphCount(internalFont)
	}
	
	/// The scaled bounding box.
	///
	/// The design bounding box of the font, which is the rectangle defined by *xMin*, *yMin*, *xMax*, and *yMax* values for the font.
	public var boundingBox: CGRect {
		return CTFontGetBoundingBox(internalFont)
	}
	
	/// The scaled underline position.
	///
	/// The font underline position metric scaled based on the point size and matrix of the font reference.
	public var underlinePosition: CGFloat {
		return CTFontGetUnderlinePosition(internalFont)
	}
	
	/// The scaled underline thickness metric.
	///
	/// The font underline thickness metric scaled based on the point size and matrix of the font reference.
	public var underlineThickness: CGFloat {
		return CTFontGetUnderlineThickness(internalFont)
	}
	
	/// The slant angle of the font.
	///
	/// The transformed slant angle of the font. This is equivalent to the italic or caret angle with any skew from the transformation matrix applied.
	public var slantAngle: CGFloat {
		return CTFontGetSlantAngle(internalFont)
	}
	
	/// The cap height metric.
	///
	/// The font cap height metric scaled based on the point size and matrix of the font reference.
	public var capHeight: CGFloat {
		return CTFontGetCapHeight(internalFont)
	}
	
	/// The X height metric.
	///
	/// The font X height metric scaled based on the point size and matrix of the font reference.
	public var xHeight: CGFloat {
		return CTFontGetXHeight(internalFont)
	}
	
	// MARK: - Font Glyphs
	/*! --------------------------------------------------------------------------
	@group Font Glyphs
	*/
	//--------------------------------------------------------------------------

	/// Returns the CGGlyph for the specified glyph name.
	/// - parameter glyphName: The glyph name as a `String`.
	/// - returns: The glyph with the specified name or `0` if the name is not recognized; this glyph can be used with other Core Text glyph data accessors or with Quartz.
	public func glyph(named glyphName: String) -> CGGlyph {
		return CTFontGetGlyphWithName(internalFont, glyphName as NSString)
	}
	
	/// Calculates the bounding rects for an array of glyphs and returns the overall bounding rect for the run.
	/// - parameter orientation: The intended drawing orientation of the glyphs. Used to determined which glyph metrics to return.<br>
	/// Default is `.default`.
	/// - parameter glyphs: An array of glyphs.
	/// - returns: This function returns the overall bounding rectangle for an array or run of glyphs, returned in the `.all` part of the returned tuple. The bounding rects of the individual glyphs are returned through the `.perGlyph` part of the returned tuple. These are the design metrics from the font transformed in font space.
	public func boundingRects(for glyphs: [CGGlyph], orientation: Orientation = .`default`) -> (all: CGRect, perGlyph: [CGRect]) {
		var bounds = [CGRect](repeating: CGRect(), count: glyphs.count)
		let finalRect = CTFontGetBoundingRectsForGlyphs(internalFont, orientation, glyphs, &bounds, glyphs.count)
		return (finalRect, bounds)
	}
	
	/// Calculates the optical bounding rects for an array of glyphs and returns the overall optical bounding rect for the run.
	/// - parameter glyphs: An array of count number of glyphs.
	/// - parameter options: Reserved, set to zero.
	/// - returns: `all`: This function returns the overall bounding rectangle for an array or run of glyphs. The bounding rects of the individual glyphs are returned through the boundingRects parameter. These are the design metrics from the font transformed in font space.<br>
	/// `perGlyph`: The computed glyph rects.
	///
	/// Fonts may specify the optical edges of glyphs that can be used to make the edges of lines of text line up in a more visually pleasing way. This function returns bounding rects corresponding to this information if present in a font, otherwise it returns typographic bounding rects (composed of the font's ascent and descent and a glyph's advance width).
	public func opticalBounds(for glyphs: [CGGlyph], options: CFOptionFlags = 0) -> (all: CGRect, perGlyph: [CGRect]) {
		var boundingRects = [CGRect](repeating: CGRect(), count: glyphs.count)
		let allBounds = CTFontGetOpticalBoundsForGlyphs(internalFont, glyphs, &boundingRects, glyphs.count, options)
		return (allBounds, boundingRects)
	}
	
	/// Calculates the advances for an array of glyphs and returns the summed advance.
	/// - parameter glyphs: An array of glyphs.
	/// - parameter orientation:
	/// The intended drawing orientation of the glyphs. Used to determined which glyph metrics to return.<br>
	/// Default is `.default`
	/// - returns: `all`: This method returns the summed glyph advance of an array of glyphs. Individual glyph advances are passed back via the advances parameter. These are the ideal metrics for each glyph scaled and transformed in font space.<br>
	/// `perGlyph`: An array of count number of `CGSize` to receive the computed glyph advances.
	public func advances(for glyphs: [CGGlyph], orientation: Orientation = .`default`) -> (all: Double, perGlyph: [CGSize]) {
		var advances = [CGSize](repeating: CGSize(), count: glyphs.count)
		let summedAdvance = CTFontGetAdvancesForGlyphs(internalFont, orientation, glyphs, &advances, glyphs.count)
		return (summedAdvance, advances)
	}
	
	/// Calculates the offset from the default (horizontal) origin to the vertical origin for an array of glyphs.
	/// - parameter glyphs: An array of glyphs.
	/// - returns: An array of `CGSize` to receive the computed origin offsets.
	public func verticalTranslations(for glyphs: [CGGlyph]) -> [CGSize] {
		var trans = [CGSize](repeating: CGSize(), count: glyphs.count)
		
		CTFontGetVerticalTranslationsForGlyphs(internalFont, glyphs, &trans, glyphs.count)
		
		return trans
	}
	
	/// Creates a path for the specified glyph.
	///
	/// Creates a path from the outlines of the glyph for the specified font. The path will reflect the font point size, matrix, and transform parameter, in that order. The transform parameter will most commonly be used to provide a translation to the desired glyph origin.
	/// - parameter glyph: The glyph.
	/// - parameter matrix: An affine transform applied to the path. Can be `nil`, in which case `CGAffineTransformIdentity` will be used.<br/>
	/// Default is `nil`.
	public func path(for glyph: CGGlyph, matrix: CGAffineTransform? = nil) -> CGPath? {
		let aPath: CGPath?
		if var matrix = matrix {
			aPath = CTFontCreatePathForGlyph(internalFont, glyph, &matrix)
		} else {
			aPath = CTFontCreatePathForGlyph(internalFont, glyph, nil)
		}
		return aPath
	}
	
	// MARK: - Font Variations
	/*! --------------------------------------------------------------------------
		@group Font Variations
	*/
	//--------------------------------------------------------------------------
	
	
	/// an array of variation axis dictionaries.
	///
	/// This function returns an array of variation axis dictionaries or `nil` if the font does not support variations. Each variation axis dictionary contains the five `kCTFontVariationAxis`* keys above.
	public var variationAxes: [[String: Any]]? {
		return CTFontCopyVariationAxes(internalFont) as! [[String: Any]]?
	}
	
	/// A variation dictionary.
	///
	/// This function describes the current configuration of a variation font: a dictionary of number values with variation identifier number keys. As of macOS 10.12 and iOS 10.0, only non-default values (as determined by the variation axis) are returned.
	///
	/// - seealso: kCTFontVariationAxisIdentifierKey
	/// - seealso: kCTFontVariationAxisDefaultValueKey
	public var variationInfo: [String: Any]? {
		return CTFontCopyVariation(internalFont) as! [String: Any]?
	}
	
	// MARK: - Font Features
	/*! --------------------------------------------------------------------------
	@group Font Features
	*/
	//--------------------------------------------------------------------------
	
	/// An array of font features
	public var features: [[String: Any]]? {
		return CTFontCopyFeatures(internalFont) as! [[String : Any]]?
	}
	
	/// An array of font feature setting tuples.
	///
	/// A setting tuple is a dictionary of a `kCTFontFeatureTypeIdentifierKey` key-value pair and a `kCTFontFeatureSelectorIdentifierKey` key-value pair. Each tuple corresponds to an enabled non-default setting. It is the caller's responsibility to handle exclusive and non-exclusive settings as necessary.
	/// This function returns a normalized array of font feature setting dictionaries. The array will only contain the non-default settings that should be applied to the font, or `nil` if the default settings should be used.
	public var featureSettings: [[String: Any]]? {
		return CTFontCopyFeatureSettings(internalFont) as! [[String: Any]]?
	}
	
	// MARK: - Font Conversion
	/*! --------------------------------------------------------------------------
	@group Font Conversion
	*/
	//--------------------------------------------------------------------------
	
	// - returns: This function returns a `CGFont` for the given font reference. Additional attributes from the font will be passed back as a font descriptor via the attributes parameter.
	public func graphicsFont() -> (font: CGFont, attributes: CTFontDescriptor?) {
		var attribs: Unmanaged<CTFontDescriptor>? = nil
		let aFont = CTFontCopyGraphicsFont(internalFont, &attribs)
		return (aFont, attribs?.takeRetainedValue())
	}
	
	
	/// Creates a new font object from a `CGFont`.
	/// - parameter graphicsFont: A valid `CGFont`.
	/// - parameter size: The point size for the font reference. If `0.0` is specified, the default font size of `12.0` will be used.
	/// - parameter matrix: The transformation matrix for the font. If `nil`, the identity matrix will be used.<br/>
	/// Default value is `nil`.
	/// - parameter attributes: A `CTFontDescriptor` containing additional attributes that should be matched.<br/>
	/// Default value is `nil`.
	public convenience init(graphicsFont: CGFont, size: CGFloat, matrix: CGAffineTransform? = nil, attributes: CTFontDescriptor? = nil) {
		let aFont: CTFont
		if var matrix = matrix {
			aFont = CTFontCreateWithGraphicsFont(graphicsFont, size, &matrix, attributes)
		} else {
			aFont = CTFontCreateWithGraphicsFont(graphicsFont, size, nil, attributes)
		}
		
		self.init(ctFont: aFont)
	}
	
	// MARK: - Font Tables
	/*! --------------------------------------------------------------------------
	@group Font Tables
	*/
	//--------------------------------------------------------------------------
	
	/// Returns an array of font table tags.
	/// - parameter options: The options used when copying font tables.<br>
	/// Default is no options.
	/// - returns: This function returns an array of `CTFontTableTag` values for the given font and the supplied options.
	public func availableTables(options: TableOptions = []) -> [CTFontTableTag]? {
		guard let numArr = __CTAFontCopyAvailableTables(internalFont, options) else {
			return nil
		}
		
		return numArr.map({$0.uint32Value})
	}
	
	/// Returns a reference to the font table data.
	///
	/// - returns: This function returns a data of the font table as `Data` or `nil` if the table is not present.
	/// - parameter table: The font table identifier as a CTFontTableTag.
	/// - parameter options: The options used when copying font table.<br>
	/// Default is no options.
	public func data(for table: CTFontTableTag, options: TableOptions = []) -> Data? {
		return CTFontCopyTable(internalFont, table, options) as Data?
	}
	
	/// Renders the given glyphs from the CTFont at the given positions in the CGContext.
	///
	/// This function will modify the `CGContext`'s font, text size, and text matrix if specified in the `Font`. These attributes will not be restored.
	/// The given glyphs should be the result of proper Unicode text layout operations (such as `CTLine`). Results from `glyphs(for:)` (or similar APIs) do not perform any Unicode text layout.
	/// - parameter context: `CGContext` used to render the glyphs.
	/// - parameter gp: The glyphs and positions (origins) to be rendered. The positions are in user space.
	public func draw(glyphsAndPositions gp: [(glyph: CGGlyph, position: CGPoint)], context: CGContext) {
		let glyphs = gp.map({return $0.glyph})
		let positions = gp.map({return $0.position})
		CTFontDrawGlyphs(internalFont, glyphs, positions, gp.count, context)
	}
	
	/// Renders the given glyphs from the CTFont at the given positions in the CGContext.
	///
	/// This function will modify the `CGContext`'s font, text size, and text matrix if specified in the `Font`. These attributes will not be restored.
	/// The given glyphs should be the result of proper Unicode text layout operations (such as `CTLine`). Results from `glyphs(for:)` (or similar APIs) do not perform any Unicode text layout.
	/// - parameter context: `CGContext` used to render the glyphs.
	/// - parameter glyphs: The glyphs to be rendered. See above discussion of how the glyphs should be derived.
	/// - parameter positions: The positions (origins) for each glyph. The positions are in user space. The number of positions passed in must be equivalent to the number of glyphs.
	func draw(glyphs: [CGGlyph], positions: [CGPoint], context: CGContext) {
		let gp = zip(glyphs, positions).map({return $0})
		draw(glyphsAndPositions: gp, context: context)
	}
	
	/// Returns caret positions within a glyph.
	/// - parameter glyph: The glyph.
	/// - parameter maxPositions: The maximum number of positions to return.
	///
	/// This function is used to obtain caret positions for a specific glyph.
	/// The return value is the max number of positions possible, and the function
	/// will populate the caller's positions buffer with available positions if possible.
	/// This function may not be able to produce positions if the font does not
	/// have the appropriate data, in which case it will return `nil`.
	public func ligatureCaretPositions(for glyph: CGGlyph, maxPositions: Int? = nil) -> [CGFloat]? {
		if let maxPositions = maxPositions {
			var pos = [CGFloat](repeating: 0, count: maxPositions)
			let neededCount = CTFontGetLigatureCaretPositions(internalFont, glyph, &pos, maxPositions)
			guard neededCount != 0 else {
				return nil
			}
			return pos
		} else {
			let neededCount = CTFontGetLigatureCaretPositions(internalFont, glyph, nil, 0)
			guard neededCount != 0 else {
				return nil
			}
			var pos = [CGFloat](repeating: 0, count: neededCount)
			CTFontGetLigatureCaretPositions(internalFont, glyph, &pos, neededCount)
			return pos
		}
	}
	
	// MARK: - Baseline Alignment
	/*! --------------------------------------------------------------------------
	@group Baseline Alignment
	*/
	//--------------------------------------------------------------------------
	
	/// Return an ordered list of `CTFontDescriptor`s for font fallback derived from the system default fallback region according to the given language preferences. The style of the given is also matched as well as the weight and width of the font is not one of the system UI font, otherwise the UI font fallback is applied.
	/// - parameter languagePrefList: The language preference list - ordered array of `String`s of ISO language codes.
	/// - returns: The ordered list of fallback fonts - ordered array of `CTFontDescriptor`s.
	@available(OSX 10.8, iOS 6.0, watchOS 2.0, tvOS 9.0, *)
	public func defaultCascadeList(forLanguages languagePrefList: [String]?) -> [CTFontDescriptor]? {
		return CTFontCopyDefaultCascadeListForLanguages(internalFont, languagePrefList as NSArray?) as! [CTFontDescriptor]?
	}
}
