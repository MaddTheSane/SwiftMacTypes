//
//  CTFontAdditions.swift
//  CoreTextAdditions
//
//  Created by C.W. Betts on 11/3/17.
//  Copyright © 2017 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText
import FoundationAdditions
#if SWIFT_PACKAGE
@_implementationOnly import CTAdditionsSwiftHelpers
#endif

public extension CTFont {
	/// Font table tags provide access to font table data.
	typealias TableTag = CTFontTableTag
	
	/// Options for descriptor match and font creation.
	typealias Options = CTFontOptions
	
	/// These constants represent the specific user interface purpose to specify for font creation.
	///
	/// Use these constants with `CTFont.create(uiType:size:forLanguage:)` to indicate the intended
	/// user interface usage of the font reference to be created.
	typealias UIFontType = CTFontUIFontType
	
	/// These constants describe font table options.
	typealias TableOptions = CTFontTableOptions
	
	/// Specifies the intended rendering orientation of the font for obtaining glyph metrics.
	typealias Orientation = CTFontOrientation
	
	/// Symbolic representation of stylistic font attributes.
	///
	/// `SymbolicTraits` symbolically describes stylistic aspects of a font. The top 4 bits is used to describe
	/// appearance of the font while the lower 28 bits for typeface. The font appearance information represented
	/// by the upper 4 bits can be used for stylistic font matching.
	typealias SymbolicTraits = CTFontSymbolicTraits
	
	/// Returns a new font reference for the given name.
	///
	/// This function uses font descriptor matching so only registered fonts can be returned; see
	/// *CTFontManager.h* for more information.
	/// - parameter name: The font name for which you wish to create a new font reference. A valid PostScript
	/// name is preferred, although other font name types will be matched in a fallback manner.
	/// - parameter size: The point size for the font reference. If *0.0* is specified, the default font
	/// size of *12.0* will be used.
	/// - parameter matrix: The transformation matrix for the font. If unspecified, the identity matrix
	/// will be used. Optional.
	/// - returns: This function will return a `CTFont` that best matches the name provided with size and
	/// matrix attributes. The `name` parameter is the only required parameter, and default values will
	/// be used for unspecified parameters. A best match will be found if all parameters cannot be
	/// matched identically.
	class func create(withName name: String, size: CGFloat, matrix: CGAffineTransform? = nil) -> CTFont {
		if var matrix {
			return CTFontCreateWithName(name as NSString, size, &matrix)
		} else {
			return self.init(name as NSString, size: size)
		}
	}
	
	/// Returns a new font reference that best matches the font descriptor.
	/// - parameter descriptor: A font descriptor containing attributes that specify the requested font.
	/// - parameter size: The point size for the font reference. If *0.0* is specified, the default font
	/// size of *12.0* will be used.
	/// - parameter matrix: The transformation matrix for the font. If unspecified, the identity matrix
	/// will be used. Optional.
	/// - returns: This function will return a `CTFont` that best matches the attributes provided with the
	/// font descriptor. The `size` and `matrix` parameters will override any specified in the font
	/// descriptor, unless they are unspecified. A best match font will always be returned, and default
	/// values will be used for any unspecified.
	class func create(with descriptor: CTFontDescriptor, size: CGFloat, matrix: CGAffineTransform? = nil) -> CTFont {
		if var matrix {
			return CTFontCreateWithFontDescriptor(descriptor, size, &matrix)
		} else {
			return CTFont(descriptor, size: size)
		}
	}
	
	/// Returns a new font reference for the given name.
	/// This function uses font descriptor matching so only registered fonts can be returned; see
	/// *CTFontManager.h* for more information.
	/// - parameter name: The font name for which you wish to create a new font reference. A valid PostScript
	/// name is preferred, although other font name types will be matched in a fallback manner.
	/// - parameter size: The point size for the font reference. If *0.0* is specified, the default font
	/// size of *12.0* will be used.
	/// - parameter matrix: The transformation matrix for the font. If unspecified, the identity matrix
	/// will be used. Optional.
	/// - parameter options: Options flags.
	/// - returns: This function will return a `CTFont` that best matches the name provided with size and
	/// matrix attributes. The `name` parameter is the only required parameter, and default values will
	/// be used for unspecified parameters. A best match will be found if all parameters cannot be
	/// matched identically.
	class func create(withName name: String, size: CGFloat, matrix: CGAffineTransform? = nil, options: Options) -> CTFont {
		if var matrix {
			return CTFontCreateWithNameAndOptions(name as NSString, size, &matrix, options)
		} else {
			return CTFontCreateWithNameAndOptions(name as NSString, size, nil, options)
		}
	}

	/// Returns a new font reference that best matches the font descriptor.
	/// - parameter descriptor: A font descriptor containing attributes that specify the requested font.
	/// - parameter size: The point size for the font reference. If *0.0* is specified, the default font
	/// size of *12.0* will be used.
	/// - parameter matrix: The transformation matrix for the font. If unspecified, the identity matrix
	/// will be used. Optional.
	/// - parameter options: Options flags.
	/// - returns: This function will return a `CTFont` that best matches the attributes provided with the
	/// font descriptor. The `size` and `matrix` parameters will override any specified in the font
	/// descriptor, unless they are unspecified. A best match font will always be returned, and default
	/// values will be used for any unspecified.
	class func create(with descriptor: CTFontDescriptor, size: CGFloat, matrix: CGAffineTransform? = nil, options: Options) -> CTFont {
		if var matrix {
			return CTFontCreateWithFontDescriptorAndOptions(descriptor, size, &matrix, options)
		} else {
			return CTFontCreateWithFontDescriptorAndOptions(descriptor, size, nil, options)
		}
	}

	/// Returns the special UI font for the given language and UI type.
	/// - parameter uiType: A uiType constant specifying the intended UI use for the requested font reference.
	/// - parameter size: The point size for the font reference. If *0.0* is specified, the default size for the
	/// requested uiType is used.
	/// - parameter language: Language identifier to select a font for a particular localization. If unspecified,
	/// the current system language is used. The format of the language identifier should conform to *UTS #35*.
	/// - returns: This function returns the correct font for various UI uses. The only required parameter is
	/// the `uiType` selector, unspecified optional parameters will use default values.
	class func create(uiType: UIFontType, size: CGFloat, forLanguage language: String?) -> CTFont? {
		return CTFontCreateUIFontForLanguage(uiType, size, language as NSString?)
	}
	
	/// Creates a new font reference from an existing Core Graphics font reference.
	/// - parameter graphicsFont: A valid Core Graphics font reference.
	/// - parameter size: The point size for the font reference. If *0.0* is specified the default font size of *12.0* is used.
	/// - parameter matrix: The transformation matrix for the font. In most cases, set this parameter to be `nil`.
	/// If `nil`, the identity matrix is used. Optional.
	/// - parameter attributes: Additional attributes that should be matched. Can be `nil`, default is `nil`.
	class func create(graphicsFont: CGFont, size: CGFloat, matrix: CGAffineTransform? = nil, attributes: CTFontDescriptor? = nil) -> CTFont {
		if var matrix {
			return CTFontCreateWithGraphicsFont(graphicsFont, size, &matrix, attributes)
		} else {
			return CTFontCreateWithGraphicsFont(graphicsFont, size, nil, attributes)
		}
	}
	
	enum FontNameKey: RawLosslessStringConvertibleCFString, Hashable, Codable, @unchecked Sendable {
		public typealias RawValue = CFString
		
		/// Creates a `FontNameKey` from a supplied string.
		/// If `rawValue` doesn't match any of the `kCTFont...NameKey`s, returns `nil`.
		/// - parameter rawValue: The string value to attempt to init `FontNameKey` into.
		public init?(rawValue: CFString) {
			switch rawValue {
			case kCTFontCopyrightNameKey:
				self = .copyright
				
			case kCTFontFamilyNameKey:
				self = .family
				
			case kCTFontSubFamilyNameKey:
				self = .subFamily
				
			case kCTFontStyleNameKey:
				self = .style
				
			case kCTFontUniqueNameKey:
				self = .unique
				
			case kCTFontFullNameKey:
				self = .full
				
			case kCTFontVersionNameKey:
				self = .version
				
			case kCTFontPostScriptNameKey:
				self = .postScript
				
			case kCTFontCopyrightNameKey:
				self = .copyright
				
			case kCTFontTrademarkNameKey:
				self = .trademark
				
			case kCTFontManufacturerNameKey:
				self = .manufacturer
				
			case kCTFontDesignerNameKey:
				self = .designer
				
			case kCTFontDescriptionNameKey:
				self = .fontDescription
				
			case kCTFontVendorURLNameKey:
				self = .vendorURL
				
			case kCTFontDesignerURLNameKey:
				self = .designerURL
				
			case kCTFontLicenseNameKey:
				self = .license
				
			case kCTFontLicenseURLNameKey:
				self = .licenseURL
				
			case kCTFontSampleTextNameKey:
				self = .sampleText
				
			case kCTFontPostScriptCIDNameKey:
				self = .postScriptCID
				
			default:
				return nil
			}
		}
		
		public var rawValue: CFString {
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
		
		/// Creates a `FontNameKey` from a supplied string.
		/// If `stringValue` doesn't match any of the `kCTFont...NameKey`s, returns `nil`.
		/// - parameter stringValue: The string value to attempt to init `FontNameKey` from.
		public init?(stringValue: String) {
			self.init(rawValue: stringValue as CFString)
		}
	}
	
	/// Returns a new font with additional attributes based on the original font.
	/// - parameter size: The point size for the font reference. If `0.0` is specified, the original font's
	/// size will be preserved.
	/// - parameter matrix: The transformation matrix for the font. If `nil`, the original font matrix will be
	/// preserved.<br>
	/// Default is `nil`.
	/// - parameter attributes: A font descriptor containing additional attributes that the new font should
	/// contain.
	///
	/// This method provides a mechanism to quickly change attributes on a given font reference in response
	/// to user actions. For instance, the size can be changed in response to a user manipulating a size
	/// slider.
	/// - returns: A new font reference converted from the original with the specified attributes.
	func copy(withAttributes attributes: CTFontDescriptor?, size: CGFloat, matrix: CGAffineTransform? = nil) -> CTFont {
		if var matrix {
			return CTFontCreateCopyWithAttributes(self, size, &matrix, attributes)
		} else {
			return CTFontCreateCopyWithAttributes(self, size, nil, attributes)
		}
	}
	
	/// Returns a new font based on the original font with the specified symbolic traits.
	/// - parameter size: The point size for the font reference. If `0.0` is specified, the original font's
	/// size will be preserved.
	/// - parameter matrix: The transformation matrix for the font. If `nil`, the original font matrix will be
	/// preserved.<br/>
	/// Default is `nil`.
	/// - parameter symTraits: The value of the symbolic traits. This bitfield is used to indicate the desired
	/// value for the traits specified by the `.mask` parameter. Used in conjunction, they can allow for trait
	/// removal as well as addition.
	/// - returns: a new font reference in the same family with the given symbolic traits, or `nil` if none
	/// found in the system.
	func copy(withSymbolicTraits symTraits: (traits: SymbolicTraits, mask: SymbolicTraits), size: CGFloat, matrix: CGAffineTransform? = nil) -> CTFont? {
		if var matrix {
			return CTFontCreateCopyWithSymbolicTraits(self, size, &matrix, symTraits.traits, symTraits.mask)
		} else {
			return CTFontCreateCopyWithSymbolicTraits(self, size, nil, symTraits.traits, symTraits.mask)
		}
	}
	
	/// Returns a new font in the specified family based on the traits of the original font.
	/// - parameter size: The point size for the font reference. If `0.0` is specified, the original font's
	/// size will be preserved.
	/// - parameter matrix: The transformation matrix for the font. If `nil`, the original font matrix will be
	/// preserved.<br/>
	/// Default is `nil`
	/// - parameter family: The name of the desired family.
	/// - returns: Returns a new font reference with the original traits in the given family. `nil` if not
	/// found in the system.
	func copy(withFamilyName family: String, size: CGFloat, matrix: CGAffineTransform? = nil) -> CTFont? {
		if var matrix {
			return CTFontCreateCopyWithFamily(self, size, &matrix, family as NSString)
		} else {
			return CTFontCreateCopyWithFamily(self, size, nil, family as NSString)
		}
	}

	// MARK: - Font Cascading
	/*! --------------------------------------------------------------------------
	@group Font Cascading
	*/
	//--------------------------------------------------------------------------
	
	/// Returns a new font reference that can best map the given string range based on the current font.
	/// - parameter string: A unicode string containing characters that cannot be encoded by the current font.
	/// - parameter range: A range specifying the range of the string that needs to be mapped.
	/// - returns: The best substitute font that can encode the specified string range.
	///
	/// This method is to be used when the current font does not cover the given range of the string. The
	/// current font itself will not be returned, but preference is given to fonts in its cascade list.
	func font(for string: String, range: Range<String.Index>) -> CTFont {
		let range2 = NSRange(range, in: string)
		let range1 = range2.cfRange
		return font(for: string as NSString, range: range1)
	}
	
	/// Returns a new font reference that can best map the given string range based on the current font.
	/// - parameter string: A unicode string containing characters that cannot be encoded by the current font.
	/// - parameter range: A range specifying the range of the string that needs to be mapped.
	/// - returns: The best substitute font that can encode the specified string range.
	///
	/// This method is to be used when the current font does not cover the given range of the string. The
	/// current font itself will not be returned, but preference is given to fonts in its cascade list.
	@inlinable func font(for string: CFString, range: CFRange) -> CTFont {
		let aFont = CTFontCreateForString(self, string, range)
		return aFont
	}
	
	/// Returns a new font reference that can best map the given string range based on the current font.
	/// - parameter string: A unicode string containing characters that cannot be encoded by the current font.
	/// - parameter range: A range specifying the range of the string that needs to be mapped.
	/// - returns: The best substitute font that can encode the specified string range.
	///
	/// This method is to be used when the current font does not cover the given range of the string. The
	/// current font itself will not be returned, but preference is given to fonts in its cascade list.
	func font(for string: Substring, range: Range<Substring.Index>) -> CTFont {
		let range2 = NSRange(range, in: string)
		let range1 = range2.cfRange
		return font(for: string as NSString, range: range1)
	}
	
	// MARK: - Font Accessors
	/*! --------------------------------------------------------------------------
	@group Font Accessors
	*/
	//--------------------------------------------------------------------------
	
	/// Returns the normalized font descriptors for the given font reference.
	///
	/// A normalized font descriptor for a font. The font descriptor contains enough information to recreate
	/// this font at a later time.
	@inlinable var fontDescriptor: CTFontDescriptor {
		return CTFontCopyFontDescriptor(self)
	}
	
	/// Returns the value associated with an arbitrary attribute.
	/// - parameter attribute: The requested attribute.
	/// - returns: If the requested attribute is not present, `nil` is returned. Refer to the attribute
	/// definitions for documentation as to how each attribute is packaged as a `CFTypeRef`.
	func value(for attribute: String) -> Any? {
		return CTFontCopyAttribute(self, attribute as NSString)
	}
	
	/// The point size of the font reference.
	///
	/// This is the point size provided when the font was created.
	@inlinable var size: CGFloat {
		return CTFontGetSize(self)
	}
	
	/// The transformation matrix of the font.
	///
	/// This is the matrix that was provided when the font was created.
	@inlinable var matrix: CGAffineTransform {
		return CTFontGetMatrix(self)
	}
	
	/// The symbolic font traits.
	///
	/// This getter returns the symbolic traits of the font. This is equivalent to the `kCTFontSymbolicTrait`
	/// of `traits` dictionary. See *CTFontTraits.h* for a definition of the font traits.
	@inlinable var symbolicTraits: SymbolicTraits {
		return CTFontGetSymbolicTraits(self)
	}
	
	/// Returns the font traits dictionary.
	///
	/// Individual traits can be accessed with the trait key constants. See *CTFontTraits.h* for a definition
	/// of the font traits.
	var traits: [String: Any] {
		return CTFontCopyTraits(self) as NSDictionary as! [String: Any]
	}
	
	// MARK: - Font Names
	/*! --------------------------------------------------------------------------
	@group Font Names
	*/
	//--------------------------------------------------------------------------
	
	/// The PostScript name.
	@inlinable var postScriptName: String {
		return CTFontCopyPostScriptName(self) as String
	}
	
	/// The family name.
	@inlinable var familyName: String {
		return CTFontCopyFamilyName(self) as String
	}
	
	/// The full name.
	@inlinable var fullName: String {
		return CTFontCopyFullName(self) as String
	}
	
	/// The localized display name of the font
	@inlinable var displayName: String {
		return CTFontCopyDisplayName(self) as String
	}

	/// Returns the requested name.
	/// - parameter nameKey: The name specifier. See name specifier constants.
	/// - returns: The requested name for the font, or `nil` if the font does not have an entry for the
	/// requested name. The Unicode version of the name will be preferred, otherwise the first available
	/// will be used.
	func name(of nameKey: FontNameKey) -> String? {
		return CTFontCopyName(self, nameKey.rawValue) as String?
	}
	
	/// Returns a localized font name and the actual language, if present.
	/// - parameter nameKey: The name specifier. See name specifier constants.
	/// - returns: A specific localized name from the font. The name is localized based on the user's global
	/// language precedence. If the font does not have an entry for the requested name, `nil` will be
	/// returned.<br/>
	/// `actualLanguage`: A `String` of the language identifier of the returned name string. The format of the
	/// language identifier will conform to *UTS #35*.
	/// If CoreText can supply its own localized string where the font cannot, this value will be `nil`.
	func localizedName(of nameKey: FontNameKey) -> (name: String, actualLanguage: String?)? {
		var actualName: Unmanaged<CFString>? = nil
		guard let name = CTFontCopyLocalizedName(self, nameKey.rawValue, &actualName) as String? else {
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
	var characterSet: CharacterSet {
		return CTFontCopyCharacterSet(self) as CharacterSet
	}
	
	/// The best string encoding for legacy format support.
	var stringEncoding: String.Encoding {
		let cfEnc = CTFontGetStringEncoding(self)
		let nsEnc = CFStringConvertEncodingToNSStringEncoding(cfEnc)
		return String.Encoding(rawValue: nsEnc)
	}
	
	/// An array of languages supported by the font.
	///
	/// The array contains language identifier strings as `String`s. The format of the language identifier will
	/// conform to *UTS #35*.
	var supportedLanguages: [String] {
		return CTFontCopySupportedLanguages(self) as NSArray? as? [String] ?? []
	}
	
	/// Performs basic character-to-glyph mapping.
	///
	/// This method only provides the nominal mapping as specified by the font's Unicode `cmap` (or
	/// equivalent); such mapping does not constitute proper Unicode layout: it is the caller's responsibility
	/// to handle the Unicode properties of the characters.
	/// - parameter characters: An array of characters (UTF-16 code units). Non-BMP characters must
	/// be encoded as surrogate pairs.
	/// - returns: `glyphs`: Glyphs for non-BMP characters are sparse: the first glyph corresponds to the full
	/// character and the second glyph will be `0`.<br/>
	/// `allMapped`: Indicates whether all provided characters were successfully mapped. A return value of true
	/// indicates that the font mapped all characters. A return value of false indicates that some or all of
	/// the characters were not mapped; glyphs for unmapped characters will be `0` (with the exception of those
	/// corresponding non-BMP characters as described above).
	func glyphs(forCharacters characters: [unichar]) -> (glyphs: [CGGlyph], allMapped: Bool) {
		var glyphs = [CGGlyph](repeating: 0, count: characters.count)
		let allMapped = CTFontGetGlyphsForCharacters(self, characters, &glyphs, characters.count)
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
	@inlinable var ascent: CGFloat {
		return CTFontGetAscent(self)
	}
	
	/// The scaled font descent metric.
	///
	/// The font descent metric scaled based on the point size and matrix of the font reference.
	@inlinable var descent: CGFloat {
		return CTFontGetDescent(self)
	}
	
	/// The scaled font leading metric.
	///
	/// The font leading metric scaled based on the point size and matrix of the font reference.
	@inlinable var leading: CGFloat {
		return CTFontGetLeading(self)
	}
	
	/// The units per em metric.
	///
	/// The units per em of the font.
	@inlinable var unitsPerEm: UInt32 {
		return CTFontGetUnitsPerEm(self)
	}
	
	/// The number of glyphs.
	///
	/// The number of glyphs in the font.
	@inlinable var countOfGlyphs: Int {
		return CTFontGetGlyphCount(self)
	}
	
	/// The scaled bounding box.
	///
	/// The design bounding box of the font, which is the rectangle defined by *xMin*, *yMin*, *xMax*, and
	/// *yMax* values for the font.
	@inlinable var boundingBox: CGRect {
		return CTFontGetBoundingBox(self)
	}
	
	/// The scaled underline position.
	///
	/// The font underline position metric scaled based on the point size and matrix of the font reference.
	@inlinable var underlinePosition: CGFloat {
		return CTFontGetUnderlinePosition(self)
	}
	
	/// The scaled underline thickness metric.
	///
	/// The font underline thickness metric scaled based on the point size and matrix of the font reference.
	@inlinable var underlineThickness: CGFloat {
		return CTFontGetUnderlineThickness(self)
	}
	
	/// The slant angle of the font.
	///
	/// The transformed slant angle of the font. This is equivalent to the italic or caret angle with any skew
	/// from the transformation matrix applied.
	@inlinable var slantAngle: CGFloat {
		return CTFontGetSlantAngle(self)
	}
	
	/// The cap height metric.
	///
	/// The font cap height metric scaled based on the point size and matrix of the font reference.
	@inlinable var capHeight: CGFloat {
		return CTFontGetCapHeight(self)
	}
	
	/// The X height metric.
	///
	/// The font X height metric scaled based on the point size and matrix of the font reference.
	@inlinable var xHeight: CGFloat {
		return CTFontGetXHeight(self)
	}
	
	// MARK: - Font Glyphs
	/*! --------------------------------------------------------------------------
	@group Font Glyphs
	*/
	//--------------------------------------------------------------------------
	
	/// Returns the CGGlyph for the specified glyph name.
	/// - parameter glyphName: The glyph name as a `String`.
	/// - returns: The glyph with the specified name or `0` if the name is not recognized; this glyph can be
	/// used with other Core Text glyph data accessors or with Quartz.
	func glyph(named glyphName: String) -> CGGlyph {
		return CTFontGetGlyphWithName(self, glyphName as NSString)
	}
	
	/// Returns the name for the specified glyph.
	/// - parameter glyph: The glyph.
	/// - returns: The glyph name as a `String` or `nil` if the glyph is invalid.
	func name(forGlyph glyph: CGGlyph) -> String? {
		return CTFontCopyNameForGlyph(self, glyph) as String?
	}
	
	/// Calculates the bounding rects for an array of glyphs and returns the overall bounding rect for the run.
	/// - parameter orientation: The intended drawing orientation of the glyphs. Used to determined which glyph
	/// metrics to return.<br>
	/// Default is `.default`.
	/// - parameter glyphs: An array of glyphs.
	/// - returns: The overall bounding rectangle for an array or run of glyphs, returned in the `.all` part of
	/// the returned tuple. The bounding rects of the individual glyphs are returned through the `.perGlyph`
	/// part of the returned tuple. These are the design metrics from the font transformed in font space.
	func boundingRects(forGlyphs glyphs: [CGGlyph], orientation: Orientation = .`default`) -> (all: CGRect, perGlyph: [CGRect]) {
		var bounds = [CGRect](repeating: CGRect(), count: glyphs.count)
		let finalRect = CTFontGetBoundingRectsForGlyphs(self, orientation, glyphs, &bounds, glyphs.count)
		return (finalRect, bounds)
	}

	/// Calculates the optical bounding rects for an array of glyphs and returns the overall optical bounding
	/// rect for the run.
	/// - parameter glyphs: An array of count number of glyphs.
	/// - parameter options: Reserved, set to zero.<br>
	/// Default is `0`.
	/// - returns: `all`: The overall bounding rectangle for an array or run of glyphs.
	/// The bounding rects of the individual glyphs are available through the `perGlyph` tuple. These
	/// are the design metrics from the font transformed in font space.<br>
	/// `perGlyph`: The computed glyph rects.
	///
	/// Fonts may specify the optical edges of glyphs that can be used to make the edges of lines of text
	/// line up in a more visually pleasing way. This method returns bounding rects corresponding to this
	/// information if present in a font, otherwise it returns typographic bounding rects (composed of the
	/// font's ascent and descent and a glyph's advance width).
	func opticalBounds(forGlyphs glyphs: [CGGlyph], options: CFOptionFlags = 0) -> (all: CGRect, perGlyph: [CGRect]) {
		var boundingRects = [CGRect](repeating: CGRect(), count: glyphs.count)
		let allBounds = CTFontGetOpticalBoundsForGlyphs(self, glyphs, &boundingRects, glyphs.count, options)
		return (allBounds, boundingRects)
	}
	
	/// Calculates the advances for an array of glyphs and returns the summed advance.
	/// - parameter glyphs: An array of glyphs.
	/// - parameter orientation:
	/// The intended drawing orientation of the glyphs. Used to determined which glyph metrics to return.<br>
	/// Default is `.default`
	/// - returns: `all`: This method returns the summed glyph advance of an array of glyphs. Individual glyph
	/// advances are passed back via the advances parameter. These are the ideal metrics for each glyph scaled
	/// and transformed in font space.<br>
	/// `perGlyph`: An array of count number of `CGSize` to receive the computed glyph advances.
	func advances(forGlyphs glyphs: [CGGlyph], orientation: Orientation = .`default`) -> (all: Double, perGlyph: [CGSize]) {
		var advances = [CGSize](repeating: CGSize(), count: glyphs.count)
		let summedAdvance = CTFontGetAdvancesForGlyphs(self, orientation, glyphs, &advances, glyphs.count)
		return (summedAdvance, advances)
	}
	
	/// Calculates the offset from the default (horizontal) origin to the vertical origin for an array of
	/// glyphs.
	/// - parameter glyphs: An array of glyphs.
	/// - returns: An array of `CGSize` to receive the computed origin offsets.
	func verticalTranslations(forGlyphs glyphs: [CGGlyph]) -> [CGSize] {
		var trans = [CGSize](repeating: CGSize(), count: glyphs.count)
		
		CTFontGetVerticalTranslationsForGlyphs(self, glyphs, &trans, glyphs.count)
		
		return trans
	}
	
	/// Creates a path for the specified glyph.
	///
	/// Creates a path from the outlines of the glyph for the specified font. The path will reflect the font
	/// point size, matrix, and transform parameter, in that order. The transform parameter will most commonly
	/// be used to provide a translation to the desired glyph origin.
	/// - parameter glyph: The glyph.
	/// - parameter matrix: An affine transform applied to the path. Can be `nil`, in which case
	/// `CGAffineTransformIdentity` will be used.<br/>
	/// Default is `nil`.
	/// - returns: A `CGPath` object containing the glyph outlines, `nil` on error.
	func path(forGlyph glyph: CGGlyph, matrix: CGAffineTransform? = nil) -> CGPath? {
		let aPath: CGPath?
		if var matrix {
			aPath = CTFontCreatePathForGlyph(self, glyph, &matrix)
		} else {
			aPath = CTFontCreatePathForGlyph(self, glyph, nil)
		}
		return aPath
	}
	
	// MARK: - Font Variations
	/*! --------------------------------------------------------------------------
	@group Font Variations
	*/
	//--------------------------------------------------------------------------
	
	/// Font Variation Axis Dictionary Keys
	///
	/// These constants provide keys to font variation axis dictionary values.
	enum VariationAxisKey: Hashable, RawLosslessStringConvertibleCFString, Codable, @unchecked Sendable {
		
		/// Key to get the variation axis identifier.
		///
		/// This key is used with a variation axis dictionary to get the axis identifier value as a `CFNumber`.
		case identifier
		
		/// Key to get the variation axis minimum value.
		///
		/// This key is used with a variation axis dictionary to get the minimum axis value as a `CFNumber`.
		case minimumValue
		
		/// Key to get the variation axis maximum value.
		///
		/// This key is used with a variation axis dictionary to get the maximum axis value as a `CFNumber`.
		case maximumValue
		
		/// Key to get the variation axis default value.
		///
		/// This key is used with a variation axis dictionary to get the default axis value as a `CFNumber`.
		case defaultValue
		
		/// Key to get the variation axis name string.
		///
		/// This key is used with a variation axis dictionary to get the localized variation axis name.
		case name
		
		/// Key to get the hidden axis flag.
		///
		/// This key contains a `CFBoolean` value that is true when the font designer recommends the axis
		/// not be exposed directly to end users in application interfaces.
		@available(macOS 10.13, iOS 11.0, watchOS 4.0, tvOS 11.0, *)
		case isHidden
		
		public init?(rawValue: CFString) {
			if #available(macOS 10.13, iOS 11.0, watchOS 4.0, tvOS 11.0, *) {
				if rawValue == kCTFontVariationAxisHiddenKey {
					self = .isHidden
					return
				}
			}
			switch rawValue {
			case kCTFontVariationAxisIdentifierKey:
				self = .identifier
				
			case kCTFontVariationAxisMinimumValueKey:
				self = .minimumValue
				
			case kCTFontVariationAxisMaximumValueKey:
				self = .maximumValue
				
			case kCTFontVariationAxisDefaultValueKey:
				self = .defaultValue
				
			case kCTFontVariationAxisNameKey:
				self = .name
				
			default:
				return nil
			}
		}

		public var rawValue: CFString {
			if #available(macOS 10.13, iOS 11.0, watchOS 4.0, tvOS 11.0, *) {
				if self == .isHidden {
					return kCTFontVariationAxisHiddenKey
				}
			}
			switch self {
			case .identifier:
				return kCTFontVariationAxisIdentifierKey

			case .minimumValue:
				return kCTFontVariationAxisMinimumValueKey

			case .maximumValue:
				return kCTFontVariationAxisMaximumValueKey

			case .defaultValue:
				return kCTFontVariationAxisDefaultValueKey

			case .name:
				return kCTFontVariationAxisNameKey
				
			case .isHidden:
				fatalError("We shouldn't be getting here!")
			}
		}
	}
	
	/// An array of variation axis dictionaries.
	///
	/// This getter returns an array of variation axis dictionaries or `nil` if the font does not support
	/// variations. Each variation axis dictionary contains the five `kCTFontVariationAxis`* keys.
	var variationAxes: [[VariationAxisKey: Any]]? {
		guard let val = CTFontCopyVariationAxes(self) as? [[CFString: Any]] else {
			return nil
		}
		return val.map { val1 -> [VariationAxisKey: Any] in
			let val3 = val1.compactMap { (key: CFString, value: Any) -> (VariationAxisKey, Any)? in
				guard let key2 = VariationAxisKey(rawValue: key) else {
					print("\((CFCopyDescription(self) as String?) ?? "Unknown Font"): Unknown key \(key)?")
					return nil
				}
				return (key2, value)
			}
			return Dictionary(uniqueKeysWithValues: val3)
		}
	}
	
	/// A variation dictionary.
	///
	/// This getter describes the current configuration of a variation font: a dictionary of number values
	/// with variation identifier number keys. As of macOS 10.12 and iOS 10.0, only non-default values (as
	/// determined by the variation axis) are returned.
	///
	/// - seealso: kCTFontVariationAxisIdentifierKey
	/// - seealso: kCTFontVariationAxisDefaultValueKey
	var variationInfo: [OSType: Double]? {
		guard let tmp = CTFontCopyVariation(self) as? [CFNumber: CFNumber] else {
			return nil
		}
		let aval = tmp.map { (key: CFNumber, value: CFNumber) -> (OSType, Double) in
			return ((key as NSNumber).uint32Value, (value as NSNumber).doubleValue)
		}
		return Dictionary(uniqueKeysWithValues: aval)
	}
	
	// MARK: - Font Features
	/*! --------------------------------------------------------------------------
	@group Font Features
	*/
	//--------------------------------------------------------------------------
	
	/// An array of font features
	var features: [[FeatureKey: Any]]? {
		guard let feats = CTFontCopyFeatures(self) as? [[CFString : Any]] else {
			return nil
		}
		return feats.map { sa in
			let preDict = sa.compactMap { (key: CFString, value: Any) -> (FeatureKey, Any)? in
				guard let feat = FeatureKey(rawValue: key) else {
					return nil
				}
				if feat == .typeSelectors, let valArr = value as? [[CFString: Any]] {
					let newVal = valArr.map { sa2 in
						let preDict2 = sa2.compactMap { (key2: CFString, value2: Any) -> (FeatureKey.SelectorKey, Any)? in
							guard let newKey = FeatureKey.SelectorKey(rawValue: key2) else {
								return nil
							}
							return (newKey, value2)
						}
						return Dictionary(uniqueKeysWithValues: preDict2)
					}
					return (.typeSelectors, newVal)
				} else {
					return (feat, value)
				}
			}
			return Dictionary(uniqueKeysWithValues: preDict)
		}
	}
	
	/// An array of font feature setting tuples.
	///
	/// A setting tuple is a dictionary of a `kCTFontFeatureTypeIdentifierKey` key-value pair and a
	/// `kCTFontFeatureSelectorIdentifierKey` key-value pair. Each tuple corresponds to an enabled non-default
	/// setting. It is the caller's responsibility to handle exclusive and non-exclusive settings as necessary.
	/// This getter returns a normalized array of font feature setting dictionaries. The array will only
	/// contain the non-default settings that should be applied to the font, or `nil` if the default settings
	/// should be used.
	///
	/// The feature settings are verified against those that the font supports and any that do not apply are removed.
	/// Further, feature settings that represent a default setting for the font are also removed.
	var featureSettings: [[String: Any]]? {
		return CTFontCopyFeatureSettings(self) as? [[String: Any]]
	}
	
	// MARK: - Font Conversion
	/*! --------------------------------------------------------------------------
	@group Font Conversion
	*/
	//--------------------------------------------------------------------------
	
	/// Returns a Core Graphics font reference and attributes.
	/// - returns: A `CGFont` for the given font reference. Additional attributes from the font will be
	/// returned as a font descriptor via the `attributes` tuple.
	func graphicsFont() -> (font: CGFont, attributes: CTFontDescriptor?) {
		var attribs: Unmanaged<CTFontDescriptor>? = nil
		let aFont = CTFontCopyGraphicsFont(self, &attribs)
		return (aFont, attribs?.takeRetainedValue())
	}
	
	// MARK: - Font Tables
	/*! --------------------------------------------------------------------------
	@group Font Tables
	*/
	//--------------------------------------------------------------------------
	
	/// Returns an array of font table tags.
	/// - parameter options: The options used when copying font tables.<br>
	/// Default is no options.
	/// - returns: An array of `CTFont.TableTag` values for the given font and the
	/// supplied options.
	func availableTables(options: TableOptions = []) -> [TableTag]? {
		guard let numArr = __CTAFontCopyAvailableTables(self, options) else {
			return nil
		}
		
		return numArr.map({$0.uint32Value})
	}
	
	/// Returns a reference to the font table data.
	///
	/// - returns: A data of the font table as `Data` or `nil` if the table is not
	/// present.
	/// - parameter table: The font table identifier as a `CTFont.TableTag`.
	/// - parameter options: The options used when copying font table.<br>
	/// Default is no options.
	func data(for table: TableTag, options: TableOptions = []) -> Data? {
		return CTFontCopyTable(self, table, options) as Data?
	}
	
	/// Renders the given glyphs from the CTFont at the given positions in the CGContext.
	///
	/// This method will modify the `CGContext`'s font, text size, and text matrix if specified in the
	/// `Font`. These attributes will not be restored.
	/// The given glyphs should be the result of proper Unicode text layout operations (such as `CTLine`).
	/// Results from `glyphs(forCharacters:)` (or similar APIs) do not perform any Unicode text layout.
	/// - parameter context: `CGContext` used to render the glyphs.
	/// - parameter gp: The glyphs and positions (origins) to be rendered. The positions are in user space.
	func draw(glyphsAndPositions gp: [(glyph: CGGlyph, position: CGPoint)], in context: CGContext) {
		let glyphs = gp.map({return $0.glyph})
		let positions = gp.map({return $0.position})
		CTFontDrawGlyphs(self, glyphs, positions, gp.count, context)
	}
	
	/// Renders the given glyphs from the CTFont at the given positions in the CGContext.
	///
	/// This method will modify the `CGContext`'s font, text size, and text matrix if specified in the
	/// `Font`. These attributes will not be restored.
	/// The given glyphs should be the result of proper Unicode text layout operations (such as `CTLine`).
	/// Results from `glyphs(for:)` (or similar APIs) do not perform any Unicode text layout.
	/// - parameter context: `CGContext` used to render the glyphs.
	/// - parameter glyphs: The glyphs to be rendered. See above discussion of how the glyphs should be
	/// derived.
	/// - parameter positions: The positions (origins) for each glyph. The positions are in user space. The
	/// number of positions passed in must be equivalent to the number of glyphs.
	func draw(glyphs: [CGGlyph], atPositions positions: [CGPoint], in context: CGContext) {
		let gp = zip(glyphs, positions).map({return $0})
		draw(glyphsAndPositions: gp, in: context)
	}
	
	/// Returns caret positions within a glyph.
	/// - parameter glyph: The glyph.
	/// - parameter maxPositions: The maximum number of positions to return.
	///
	/// This method is used to obtain caret positions for a specific glyph.
	/// The return value is the max number of positions possible, and the method
	/// will populate the caller's positions buffer with available positions if possible.
	/// This method may not be able to produce positions if the font does not
	/// have the appropriate data, in which case it will return `nil`.
	func ligatureCaretPositions(forGlyph glyph: CGGlyph, maxPositions: Int? = nil) -> [CGFloat]? {
		if let maxPositions = maxPositions {
			var pos = [CGFloat](repeating: 0, count: maxPositions)
			let neededCount = CTFontGetLigatureCaretPositions(self, glyph, &pos, maxPositions)
			guard neededCount != 0 else {
				return nil
			}
			return pos
		} else {
			let neededCount = CTFontGetLigatureCaretPositions(self, glyph, nil, 0)
			guard neededCount != 0 else {
				return nil
			}
			var pos = [CGFloat](repeating: 0, count: neededCount)
			CTFontGetLigatureCaretPositions(self, glyph, &pos, neededCount)
			return pos
		}
	}
	
	// MARK: - Baseline Alignment
	/*! --------------------------------------------------------------------------
	@group Baseline Alignment
	*/
	//--------------------------------------------------------------------------
	
	/// Return an ordered list of `CTFontDescriptor`s for font fallback derived from the system default
	/// fallback region according to the given language preferences. The style of the given is also matched as
	/// well as the weight and width of the font is not one of the system UI font, otherwise the UI font
	/// fallback is applied.
	/// - parameter languagePrefList: The language preference list - ordered array of `String`s of ISO
	/// language codes.
	/// - returns: The ordered list of fallback fonts - ordered array of `CTFontDescriptor`s.
	@available(OSX 10.8, iOS 6.0, watchOS 2.0, tvOS 9.0, *)
	func defaultCascadeList(forLanguages languagePrefList: [String]?) -> [CTFontDescriptor]? {
		return CTFontCopyDefaultCascadeListForLanguages(self, languagePrefList as NSArray?) as! [CTFontDescriptor]?
	}
	
	/// Font Features
	enum FeatureKey: RawLosslessStringConvertibleCFString, Hashable, Codable, @unchecked Sendable {
		public typealias RawValue = CFString
		
		/// Creates a `FontNameKey` from a supplied string.
		/// If `rawValue` doesn't match any of the `kCTFont...NameKey`s, returns `nil`.
		/// - parameter rawValue: The string value to attempt to init `FontNameKey` into.
		public init?(rawValue: CFString) {
			if #available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *) {
				if rawValue == kCTFontFeatureSampleTextKey {
					self = .sampleText
					return
				} else if rawValue == kCTFontFeatureTooltipTextKey {
					self = .tooltipText
					return
				}
			}
			switch rawValue {
			case kCTFontOpenTypeFeatureTag:
				self = .openTypeTag
				
			case kCTFontOpenTypeFeatureValue:
				self = .openTypeValue
				
			case kCTFontFeatureTypeIdentifierKey:
				self = .typeIdentifier
				
			case kCTFontFeatureTypeNameKey:
				self = .typeName
				
			case kCTFontFeatureTypeExclusiveKey:
				self = .typeExclusive
				
			case kCTFontFeatureTypeSelectorsKey:
				self = .typeSelectors
				
			default:
				return nil
			}
		}
		
		public var rawValue: CFString {
			if #available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *) {
				switch self {
				case .sampleText:
					return kCTFontFeatureSampleTextKey
				case .tooltipText:
					return kCTFontFeatureTooltipTextKey

				default:
					break
				}
			}
			switch self {
			case .openTypeTag:
				return kCTFontOpenTypeFeatureTag
			case .openTypeValue:
				return kCTFontOpenTypeFeatureValue
			case .typeIdentifier:
				return kCTFontFeatureTypeIdentifierKey
			case .typeName:
				return kCTFontFeatureTypeNameKey
			case .typeExclusive:
				return kCTFontFeatureTypeExclusiveKey
			case .typeSelectors:
				return kCTFontFeatureTypeSelectorsKey
			case .sampleText, .tooltipText:
				fatalError("We shouldn't have got here!")
			}
		}
		
		/// Key to get the OpenType feature tag.
		///
		/// This key can be used with a font feature dictionary to get the tag as a `CFString`.
		@available(macOS 10.10, iOS 8.0, watchOS 2.0, tvOS 9.0, *)
		case openTypeTag
		
		/// Key to get the OpenType feature value.
		///
		/// This key can be used with a font feature dictionary to get the value as a `CFNumber`.
		@available(macOS 10.10, iOS 8.0, watchOS 2.0, tvOS 9.0, *)
		case openTypeValue

		/// Key to get the font feature type value.
		///
		/// This key can be used with a font feature dictionary to get the type identifier as a `CFNumber`.
		@available(macOS 10.5, iOS 3.2, watchOS 2.0, tvOS 9.0, *)
		case typeIdentifier
		
		/// Key to get the font feature name.
		///
		/// This key can be used with a font feature dictionary to get the localized type name string as a `CFString`.
		@available(macOS 10.5, iOS 3.2, watchOS 2.0, tvOS 9.0, *)
		case typeName

		/// Key to get the font feature exclusive setting.
		///
		/// This key can be used with a font feature dictionary to get the the exclusive setting of the feature as
		/// a `CFBoolean`. The value associated with this key indicates whether the feature selectors associated
		/// with this type should be mutually exclusive.
		@available(macOS 10.5, iOS 3.2, watchOS 2.0, tvOS 9.0, *)
		case typeExclusive
		
		/// Key to get the font feature selectors.
		///
		/// This key can be used with a font feature dictionary to get the array of font feature selectors as a `CFArray`.
		/// This is an array of selector dictionaries that contain the values for the following selector keys.
		@available(macOS 10.5, iOS 3.2, watchOS 2.0, tvOS 9.0, *)
		case typeSelectors

		public enum SelectorKey: RawLosslessStringConvertibleCFString, Hashable, Codable, @unchecked Sendable {
			public typealias RawValue = CFString

			/// Key to get the font feature selector identifier.
			///
			/// This key can be used with a selector dictionary corresponding to a feature type to obtain the selector identifier value
			/// as a `CFNumber`.
			case identifier
			
			/// Key to get the font feature selector name.
			///
			/// This key is used with a selector dictionary to get the localized name string for the selector as a `CFString`.
			case name
			
			/// Key to get the font feature selector default setting value.
			///
			/// This key is used with a selector dictionary to get the default indicator for the selector.
			/// This value is a `CFBoolean` which if present and true indicates that this selector is the default setting
			/// for the current feature type.
			case `default`
			
			/// Key to get or specify the current feature setting.
			///
			/// This key is used with a selector dictionary to get or specify the current setting for the selector. This value
			/// is a `CFBoolean` to indicate whether this selector is on or off. If this key is not present, the default
			/// setting is used.
			case setting
			
			/// Key to get the OpenType feature tag.
			///
			/// This key can be used with a font feature dictionary to get the tag as a `CFString`.
			@available(macOS 10.10, iOS 8.0, watchOS 2.0, tvOS 9.0, *)
			case openTypeTag
			
			/// Key to get the OpenType feature value.
			///
			/// This key can be used with a font feature dictionary to get the value as a `CFNumber`.
			@available(macOS 10.10, iOS 8.0, watchOS 2.0, tvOS 9.0, *)
			case openTypeValue
			
			public var rawValue: CFString {
				switch self {
				case .identifier:
					return kCTFontFeatureSelectorIdentifierKey
				case .name:
					return kCTFontFeatureSelectorNameKey
				case .default:
					return kCTFontFeatureSelectorDefaultKey
				case .setting:
					return kCTFontFeatureSelectorSettingKey
				case .openTypeTag:
					return kCTFontOpenTypeFeatureTag
				case .openTypeValue:
					return kCTFontOpenTypeFeatureValue
				}
			}
			
			public init?(rawValue: CFString) {
				switch rawValue {
				case kCTFontFeatureSelectorIdentifierKey:
					self = .identifier
					
				case kCTFontFeatureSelectorNameKey:
					self = .name
					
				case kCTFontFeatureSelectorDefaultKey:
					self = .default
					
				case kCTFontFeatureSelectorSettingKey:
					self = .setting
					
				case kCTFontOpenTypeFeatureTag:
					self = .openTypeTag
					
				case kCTFontOpenTypeFeatureValue:
					self = .openTypeValue
					
				default:
					return nil
				}
			}
		}

		/// Key to get the font feature sample text.
		///
		/// This key can be used with a font feature dictionary to get the localized sample text as a `CFString`.
		@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
		case sampleText

		/// Key to get the font feature tooltip text.
		///
		/// This key can be used with a font feature dictionary to get the localized tooltip text as a `CFString`.
		@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
		case tooltipText
	}
}

/// Baseline data
@inlinable public var CTFontTableBASE: CTFontTableTag {
	return 0x42415345
}
/// Color bitmap data
@inlinable public var CTFontTableCBDT: CTFontTableTag {
	return 0x43424454
}
/// Color bitmap location data
@inlinable public var CTFontTableCBLC: CTFontTableTag {
	return 0x43424c43
}
/// Compact Font Format 1.0
@inlinable public var CTFontTableCFF: CTFontTableTag {
	return 0x43464620
}
/// Compact Font Format 2.0
@inlinable public var CTFontTableCFF2: CTFontTableTag {
	return 0x43464632
}
/// Color table
@inlinable public var CTFontTableCOLR: CTFontTableTag {
	return 0x434f4c52
}
/// Color palette table
@inlinable public var CTFontTableCPAL: CTFontTableTag {
	return 0x4350414c
}
/// Digital signature
@inlinable public var CTFontTableDSIG: CTFontTableTag {
	return 0x44534947
}
/// Embedded bitmap data
@inlinable public var CTFontTableEBDT: CTFontTableTag {
	return 0x45424454
}
/// Embedded bitmap location data
@inlinable public var CTFontTableEBLC: CTFontTableTag {
	return 0x45424c43
}
/// Embedded bitmap scaling data
@inlinable public var CTFontTableEBSC: CTFontTableTag {
	return 0x45425343
}
/// Glyph definition data
@inlinable public var CTFontTableGDEF: CTFontTableTag {
	return 0x47444546
}
/// Glyph positioning data
@inlinable public var CTFontTableGPOS: CTFontTableTag {
	return 0x47504f53
}
/// Glyph substitution data
@inlinable public var CTFontTableGSUB: CTFontTableTag {
	return 0x47535542
}
/// Horizontal metrics variations
@inlinable public var CTFontTableHVAR: CTFontTableTag {
	return 0x48564152
}
/// Justification data
@inlinable public var CTFontTableJSTF: CTFontTableTag {
	return 0x4a535446
}
/// Linear threshold data
@inlinable public var CTFontTableLTSH: CTFontTableTag {
	return 0x4c545348
}
/// Math layout data
@inlinable public var CTFontTableMATH: CTFontTableTag {
	return 0x4d415448
}
/// Merge
@inlinable public var CTFontTableMERG: CTFontTableTag {
	return 0x4d455247
}
/// Metrics variations
@inlinable public var CTFontTableMVAR: CTFontTableTag {
	return 0x4d564152
}
/// OS/2 and Windows specific metrics
@inlinable public var CTFontTableOS2: CTFontTableTag {
	return 0x4f532f32
}
/// PCL 5 data
@inlinable public var CTFontTablePCLT: CTFontTableTag {
	return 0x50434c54
}
/// Style attributes
@inlinable public var CTFontTableSTAT: CTFontTableTag {
	return 0x53544154
}
/// Scalable vector graphics
@inlinable public var CTFontTableSVG: CTFontTableTag {
	return 0x53564720
}
/// Vertical device metrics
@inlinable public var CTFontTableVDMX: CTFontTableTag {
	return 0x56444d58
}
/// Vertical origin
@inlinable public var CTFontTableVORG: CTFontTableTag {
	return 0x564f5247
}
/// Vertical metrics variations
@inlinable public var CTFontTableVVAR: CTFontTableTag {
	return 0x56564152
}
/// Glyph reference
@inlinable public var CTFontTableZapf: CTFontTableTag {
	return 0x5a617066
}
/// Accent attachment
@inlinable public var CTFontTableAcnt: CTFontTableTag {
	return 0x61636e74
}
/// Anchor points
@inlinable public var CTFontTableAnkr: CTFontTableTag {
	return 0x616e6b72
}
/// Axis variations
@inlinable public var CTFontTableAvar: CTFontTableTag {
	return 0x61766172
}
/// Bitmap data
@inlinable public var CTFontTableBdat: CTFontTableTag {
	return 0x62646174
}
/// Bitmap font header
@inlinable public var CTFontTableBhed: CTFontTableTag {
	return 0x62686564
}
/// Bitmap location
@inlinable public var CTFontTableBloc: CTFontTableTag {
	return 0x626c6f63
}
/// Baseline
@inlinable public var CTFontTableBsln: CTFontTableTag {
	return 0x62736c6e
}
/// CID to glyph mapping
@inlinable public var CTFontTableCidg: CTFontTableTag {
	return 0x63696467
}
/// Character to glyph mapping
@inlinable public var CTFontTableCmap: CTFontTableTag {
	return 0x636d6170
}
/// CVT variations
@inlinable public var CTFontTableCvar: CTFontTableTag {
	return 0x63766172
}
/// Control value table
@inlinable public var CTFontTableCvt: CTFontTableTag {
	return 0x63767420
}
/// Font descriptor
@inlinable public var CTFontTableFdsc: CTFontTableTag {
	return 0x66647363
}
/// Layout feature
@inlinable public var CTFontTableFeat: CTFontTableTag {
	return 0x66656174
}
/// Font metrics
@inlinable public var CTFontTableFmtx: CTFontTableTag {
	return 0x666d7478
}
/// 'FOND' and 'NFNT' data
@inlinable public var CTFontTableFond: CTFontTableTag {
	return 0x666f6e64
}
/// Font program
@inlinable public var CTFontTableFpgm: CTFontTableTag {
	return 0x6670676d
}
/// Font variations
@inlinable public var CTFontTableFvar: CTFontTableTag {
	return 0x66766172
}
/// Grid-fitting/scan-conversion
@inlinable public var CTFontTableGasp: CTFontTableTag {
	return 0x67617370
}
/// Glyph data
@inlinable public var CTFontTableGlyf: CTFontTableTag {
	return 0x676c7966
}
/// Glyph variations
@inlinable public var CTFontTableGvar: CTFontTableTag {
	return 0x67766172
}
/// Horizontal device metrics
@inlinable public var CTFontTableHdmx: CTFontTableTag {
	return 0x68646d78
}
/// Font header
@inlinable public var CTFontTableHead: CTFontTableTag {
	return 0x68656164
}
/// Horizontal header
@inlinable public var CTFontTableHhea: CTFontTableTag {
	return 0x68686561
}
/// Horizontal metrics
@inlinable public var CTFontTableHmtx: CTFontTableTag {
	return 0x686d7478
}
/// Horizontal style
@inlinable public var CTFontTableHsty: CTFontTableTag {
	return 0x68737479
}
/// Justification
@inlinable public var CTFontTableJust: CTFontTableTag {
	return 0x6a757374
}
/// Kerning
@inlinable public var CTFontTableKern: CTFontTableTag {
	return 0x6b65726e
}
/// Extended kerning
@inlinable public var CTFontTableKerx: CTFontTableTag {
	return 0x6b657278
}
/// Ligature caret
@inlinable public var CTFontTableLcar: CTFontTableTag {
	return 0x6c636172
}
/// Index to location
@inlinable public var CTFontTableLoca: CTFontTableTag {
	return 0x6c6f6361
}
/// Language tags
@inlinable public var CTFontTableLtag: CTFontTableTag {
	return 0x6c746167
}
/// Maximum profile
@inlinable public var CTFontTableMaxp: CTFontTableTag {
	return 0x6d617870
}
/// Metadata
@inlinable public var CTFontTableMeta: CTFontTableTag {
	return 0x6d657461
}
/// Morph
@inlinable public var CTFontTableMort: CTFontTableTag {
	return 0x6d6f7274
}
/// Extended morph
@inlinable public var CTFontTableMorx: CTFontTableTag {
	return 0x6d6f7278
}
/// Naming table
@inlinable public var CTFontTableName: CTFontTableTag {
	return 0x6e616d65
}
/// Optical bounds
@inlinable public var CTFontTableOpbd: CTFontTableTag {
	return 0x6f706264
}
/// PostScript information
@inlinable public var CTFontTablePost: CTFontTableTag {
	return 0x706f7374
}
/// CVT program
@inlinable public var CTFontTablePrep: CTFontTableTag {
	return 0x70726570
}
/// Properties
@inlinable public var CTFontTableProp: CTFontTableTag {
	return 0x70726f70
}
/// Bitmap data
@inlinable public var CTFontTableSbit: CTFontTableTag {
	return 0x73626974
}
/// Standard bitmap graphics
@inlinable public var CTFontTableSbix: CTFontTableTag {
	return 0x73626978
}
/// Tracking
@inlinable public var CTFontTableTrak: CTFontTableTag {
	return 0x7472616b
}
/// Vertical header
@inlinable public var CTFontTableVhea: CTFontTableTag {
	return 0x76686561
}
/// Vertical metrics
@inlinable public var CTFontTableVmtx: CTFontTableTag {
	return 0x766d7478
}
/// Cross-reference
@inlinable public var CTFontTableXref: CTFontTableTag {
	return 0x78726566
}
