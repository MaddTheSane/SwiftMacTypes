//
//  CTFontAdditions.swift
//  CoreTextAdditions
//
//  Created by C.W. Betts on 11/3/17.
//  Copyright © 2017 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText.CTFont
import SwiftAdditions

extension CTFont {
	/// Returns a new font with additional attributes based on the original font.
	/// - parameter size: The point size for the font reference. If `0.0` is specified, the original font's size will be preserved.
	/// - parameter matrix: The transformation matrix for the font. If `nil`, the original font matrix will be preserved.<br>
	/// Default is `nil`.
	/// - parameter attributes: A font descriptor containing additional attributes that the new font should contain.
	///
	/// This function provides a mechanism to quickly change attributes on a given font reference in response to user actions. For instance, the size can be changed in response to a user manipulating a size slider.
	/// - returns: Returns a new font reference converted from the original with the specified attributes.
	public func copy(withAttributes attributes: CTFontDescriptor?, size: CGFloat, matrix: CGAffineTransform? = nil) -> CTFont {
		if var matrix = matrix {
			return CTFontCreateCopyWithAttributes(self, size, &matrix, attributes)
		} else {
			return CTFontCreateCopyWithAttributes(self, size, nil, attributes)
		}
	}
	
	/// Returns a new font based on the original font with the specified symbolic traits.
	/// - parameter size: The point size for the font reference. If `0.0` is specified, the original font's size will be preserved.
	/// - parameter matrix: The transformation matrix for the font. If `nil`, the original font matrix will be preserved.<br/>
	/// Default is `nil`.
	/// - parameter symTraits: The value of the symbolic traits. This bitfield is used to indicate the desired value for the traits specified by the `.mask` parameter. Used in conjunction, they can allow for trait removal as well as addition.
	/// - returns: a new font reference in the same family with the given symbolic traits, or `nil` if none found in the system.
	public func copy(withSymbolicTraits symTraits: (traits: CTFontSymbolicTraits, mask: CTFontSymbolicTraits), size: CGFloat, matrix: CGAffineTransform? = nil) -> CTFont? {
		if var matrix = matrix {
			return CTFontCreateCopyWithSymbolicTraits(self, size, &matrix, symTraits.traits, symTraits.mask)
		} else {
			return CTFontCreateCopyWithSymbolicTraits(self, size, nil, symTraits.traits, symTraits.mask)
		}
	}
	
	/// Returns a new font in the specified family based on the traits of the original font.
	/// - parameter size: The point size for the font reference. If `0.0` is specified, the original font's size will be preserved.
	/// - parameter matrix: The transformation matrix for the font. If `nil`, the original font matrix will be preserved.<br/>
	/// Default is `nil`
	/// - parameter family: The name of the desired family.
	/// - returns: Returns a new font reference with the original traits in the given family. `nil` if non found in the system.
	public func copy(withFamilyName family: String, size: CGFloat, matrix: CGAffineTransform? = nil) -> CTFont? {
		if var matrix = matrix {
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
	/// - returns: This function returns the best substitute font that can encode the specified string range.
	///
	/// This function is to be used when the current font does not cover the given range of the string. The current font itself will not be returned, but preference is given to fonts in its cascade list.
	public func font(for string: String, range: Range<String.Index>) -> CTFont {
		let range2 = NSRange(range, in: string)
		let range1 = range2.cfRange
		return CTFontCreateForString(self, string as NSString, range1)
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
	public func font(for string: Substring, range: Range<Substring.Index>) -> CTFont {
		let range2 = NSRange(range, in: string)
		let range1 = range2.cfRange
		return CTFontCreateForString(self, string as NSString, range1)
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
		return CTFontCopyFontDescriptor(self)
	}
	
	/// Returns the value associated with an arbitrary attribute.
	/// - parameter attribute: The requested attribute.
	/// - returns: If the requested attribute is not present, `nil` is returned. Refer to the attribute definitions for documentation as to how each attribute is packaged as a `CFTypeRef`.
	public func value(for attribute: String) -> Any? {
		return CTFontCopyAttribute(self, attribute as NSString)
	}
	
	/// The point size of the font reference.
	///
	/// This is the point size provided when the font was created.
	public var size: CGFloat {
		return CTFontGetSize(self)
	}
	
	/// The transformation matrix of the font.
	///
	/// This is the matrix that was provided when the font was created.
	public var matrix: CGAffineTransform {
		return CTFontGetMatrix(self)
	}
	
	/// The symbolic font traits.
	///
	/// This getter returns the symbolic traits of the font. This is equivalent to the `kCTFontSymbolicTrait` of traits dictionary. See *CTFontTraits.h* for a definition of the font traits.
	public var symbolicTraits: CTFontSymbolicTraits {
		return CTFontGetSymbolicTraits(self)
	}
	
	/// Returns the font traits dictionary.
	///
	/// Individual traits can be accessed with the trait key constants. See *CTFontTraits.h* for a definition of the font traits.
	public var traits: [String: Any] {
		return CTFontCopyTraits(self) as NSDictionary as! [String: Any]
	}
	
	// MARK: - Font Names
	/*! --------------------------------------------------------------------------
	@group Font Names
	*/
	//--------------------------------------------------------------------------
	
	/// The PostScript name.
	public var postScriptName: String {
		return CTFontCopyPostScriptName(self) as String
	}
	
	/// The family name.
	public var familyName: String {
		return CTFontCopyFamilyName(self) as String
	}
	
	/// The full name.
	public var fullName: String {
		return CTFontCopyFullName(self) as String
	}
	
	/// The localized display name of the font
	public var displayName: String {
		return CTFontCopyDisplayName(self) as String
	}

	/// Returns the requested name.
	/// - parameter nameKey: The name specifier. See name specifier constants.
	/// - returns: This function creates the requested name for the font, or `nil` if the font does not have an entry for the requested name. The Unicode version of the name will be preferred, otherwise the first available will be used.
	public func name(ofKey nameKey: Font.FontNameKey) -> String? {
		return CTFontCopyName(self, nameKey.cfString) as String?
	}
	
	/// Returns a localized font name and the actual language, if present.
	/// - parameter nameKey: The name specifier. See name specifier constants.
	/// - returns: This function returns a specific localized name from the font. The name is localized based on the user's global language precedence. If the font does not have an entry for the requested name, NULL will be returned. <br/>
	/// `actualLanguage`: A `String` of the language identifier of the returned name string. The format of the language identifier will conform to *UTS #35*.
	/// If CoreText can supply its own localized string where the font cannot, this value will be `nil`.
	public func localizedName(ofKey nameKey: Font.FontNameKey) -> (name: String, actualLanguage: String?)? {
		var actualName: Unmanaged<CFString>? = nil
		guard let name = CTFontCopyLocalizedName(self, nameKey.cfString, &actualName) as String? else {
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
		return CTFontCopyCharacterSet(self) as CharacterSet
	}
	
	/// The best string encoding for legacy format support.
	public var stringEncoding: String.Encoding {
		let cfEnc = CTFontGetStringEncoding(self)
		let nsEnc = CFStringConvertEncodingToNSStringEncoding(cfEnc)
		return String.Encoding(rawValue: nsEnc)
	}
	
	/// An array of languages supported by the font.
	///
	/// The array contains language identifier strings as `String`s. The format of the language identifier will conform to *UTS #35*.
	public var supportedLanguages: [String] {
		return CTFontCopySupportedLanguages(self) as NSArray? as! [String]? ?? []
	}
	
	/// Performs basic character-to-glyph mapping.
	///
	/// This function only provides the nominal mapping as specified by the font's Unicode cmap (or equivalent); such mapping does not constitute proper Unicode layout: it is the caller's responsibility to handle the Unicode properties of the characters.
	/// - parameter characters: An array of characters (UTF-16 code units). Non-BMP characters must be encoded as surrogate pairs.
	/// - returns: `glyphs`: Glyphs for non-BMP characters are sparse: the first glyph corresponds to the full character and the second glyph will be `0`. <br/>
	/// `allMapped`: Indicates whether all provided characters were successfully mapped. A return value of true indicates that the font mapped all characters. A return value of false indicates that some or all of the characters were not mapped; glyphs for unmapped characters will be `0` (with the exception of those corresponding non-BMP characters as described above).
	public func glyphs(for characters: [unichar]) -> (glyphs: [CGGlyph], allMapped: Bool) {
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
	public var ascent: CGFloat {
		return CTFontGetAscent(self)
	}
	
	/// The scaled font descent metric.
	///
	/// The font descent metric scaled based on the point size and matrix of the font reference.
	public var descent: CGFloat {
		return CTFontGetDescent(self)
	}
	
	/// The scaled font leading metric.
	///
	/// The font leading metric scaled based on the point size and matrix of the font reference.
	public var leading: CGFloat {
		return CTFontGetLeading(self)
	}
	
	/// The units per em metric.
	///
	/// The units per em of the font.
	public var unitsPerEm: UInt32 {
		return CTFontGetUnitsPerEm(self)
	}
	
	/// The number of glyphs.
	///
	/// The number of glyphs in the font.
	public var countOfGlyphs: Int {
		return CTFontGetGlyphCount(self)
	}
	
	/// The scaled bounding box.
	///
	/// The design bounding box of the font, which is the rectangle defined by *xMin*, *yMin*, *xMax*, and *yMax* values for the font.
	public var boundingBox: CGRect {
		return CTFontGetBoundingBox(self)
	}
	
	/// The scaled underline position.
	///
	/// The font underline position metric scaled based on the point size and matrix of the font reference.
	public var underlinePosition: CGFloat {
		return CTFontGetUnderlinePosition(self)
	}
	
	/// The scaled underline thickness metric.
	///
	/// The font underline thickness metric scaled based on the point size and matrix of the font reference.
	public var underlineThickness: CGFloat {
		return CTFontGetUnderlineThickness(self)
	}
	
	/// The slant angle of the font.
	///
	/// The transformed slant angle of the font. This is equivalent to the italic or caret angle with any skew from the transformation matrix applied.
	public var slantAngle: CGFloat {
		return CTFontGetSlantAngle(self)
	}
	
	/// The cap height metric.
	///
	/// The font cap height metric scaled based on the point size and matrix of the font reference.
	public var capHeight: CGFloat {
		return CTFontGetCapHeight(self)
	}
	
	/// The X height metric.
	///
	/// The font X height metric scaled based on the point size and matrix of the font reference.
	public var xHeight: CGFloat {
		return CTFontGetXHeight(self)
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
		return CTFontGetGlyphWithName(self, glyphName as NSString)
	}
	
	/// Calculates the bounding rects for an array of glyphs and returns the overall bounding rect for the run.
	/// - parameter orientation: The intended drawing orientation of the glyphs. Used to determined which glyph metrics to return.<br>
	/// Default is `.default`.
	/// - parameter glyphs: An array of glyphs.
	/// - returns: This function returns the overall bounding rectangle for an array or run of glyphs, returned in the `.all` part of the returned tuple. The bounding rects of the individual glyphs are returned through the `.perGlyph` part of the returned tuple. These are the design metrics from the font transformed in font space.
	public func boundingRects(for glyphs: [CGGlyph], orientation: Font.Orientation = .`default`) -> (all: CGRect, perGlyph: [CGRect]) {
		var bounds = [CGRect](repeating: CGRect(), count: glyphs.count)
		let finalRect = CTFontGetBoundingRectsForGlyphs(self, orientation, glyphs, &bounds, glyphs.count)
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
		let allBounds = CTFontGetOpticalBoundsForGlyphs(self, glyphs, &boundingRects, glyphs.count, options)
		return (allBounds, boundingRects)
	}
	
	/// Calculates the advances for an array of glyphs and returns the summed advance.
	/// - parameter glyphs: An array of glyphs.
	/// - parameter orientation:
	/// The intended drawing orientation of the glyphs. Used to determined which glyph metrics to return.<br>
	/// Default is `.default`
	/// - returns: `all`: This method returns the summed glyph advance of an array of glyphs. Individual glyph advances are passed back via the advances parameter. These are the ideal metrics for each glyph scaled and transformed in font space.<br>
	/// `perGlyph`: An array of count number of `CGSize` to receive the computed glyph advances.
	public func advances(for glyphs: [CGGlyph], orientation: Font.Orientation = .`default`) -> (all: Double, perGlyph: [CGSize]) {
		var advances = [CGSize](repeating: CGSize(), count: glyphs.count)
		let summedAdvance = CTFontGetAdvancesForGlyphs(self, orientation, glyphs, &advances, glyphs.count)
		return (summedAdvance, advances)
	}
	
	/// Calculates the offset from the default (horizontal) origin to the vertical origin for an array of glyphs.
	/// - parameter glyphs: An array of glyphs.
	/// - returns: An array of `CGSize` to receive the computed origin offsets.
	public func verticalTranslations(for glyphs: [CGGlyph]) -> [CGSize] {
		var trans = [CGSize](repeating: CGSize(), count: glyphs.count)
		
		CTFontGetVerticalTranslationsForGlyphs(self, glyphs, &trans, glyphs.count)
		
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
	
	
	/// an array of variation axis dictionaries.
	///
	/// This function returns an array of variation axis dictionaries or `nil` if the font does not support variations. Each variation axis dictionary contains the five `kCTFontVariationAxis`* keys above.
	public var variationAxes: [[String: Any]]? {
		return CTFontCopyVariationAxes(self) as! [[String: Any]]?
	}
	
	/// A variation dictionary.
	///
	/// This function describes the current configuration of a variation font: a dictionary of number values with variation identifier number keys. As of macOS 10.12 and iOS 10.0, only non-default values (as determined by the variation axis) are returned.
	///
	/// - seealso: kCTFontVariationAxisIdentifierKey
	/// - seealso: kCTFontVariationAxisDefaultValueKey
	public var variationInfo: [String: Any]? {
		return CTFontCopyVariation(self) as! [String: Any]?
	}
	
	// MARK: - Font Features
	/*! --------------------------------------------------------------------------
	@group Font Features
	*/
	//--------------------------------------------------------------------------
	
	/// An array of font features
	public var features: [[String: Any]]? {
		return CTFontCopyFeatures(self) as! [[String : Any]]?
	}
	
	/// An array of font feature setting tuples.
	///
	/// A setting tuple is a dictionary of a `kCTFontFeatureTypeIdentifierKey` key-value pair and a `kCTFontFeatureSelectorIdentifierKey` key-value pair. Each tuple corresponds to an enabled non-default setting. It is the caller's responsibility to handle exclusive and non-exclusive settings as necessary.
	/// This function returns a normalized array of font feature setting dictionaries. The array will only contain the non-default settings that should be applied to the font, or `nil` if the default settings should be used.
	public var featureSettings: [[String: Any]]? {
		return CTFontCopyFeatureSettings(self) as! [[String: Any]]?
	}
	
	// MARK: - Font Conversion
	/*! --------------------------------------------------------------------------
	@group Font Conversion
	*/
	//--------------------------------------------------------------------------
	
	// - returns: This function returns a `CGFont` for the given font reference. Additional attributes from the font will be passed back as a font descriptor via the attributes parameter.
	public func graphicsFont() -> (font: CGFont, attributes: CTFontDescriptor?) {
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
	/// - returns: This function returns an array of `CTFontTableTag` values for the given font and the supplied options.
	public func availableTables(options: Font.TableOptions = []) -> [CTFontTableTag]? {
		guard let numArr = __CTAFontCopyAvailableTables(self, options) else {
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
	public func data(for table: CTFontTableTag, options: Font.TableOptions = []) -> Data? {
		return CTFontCopyTable(self, table, options) as Data?
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
		CTFontDrawGlyphs(self, glyphs, positions, gp.count, context)
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
	
	/// Return an ordered list of `CTFontDescriptor`s for font fallback derived from the system default fallback region according to the given language preferences. The style of the given is also matched as well as the weight and width of the font is not one of the system UI font, otherwise the UI font fallback is applied.
	/// - parameter languagePrefList: The language preference list - ordered array of `String`s of ISO language codes.
	/// - returns: The ordered list of fallback fonts - ordered array of `CTFontDescriptor`s.
	@available(OSX 10.8, iOS 6.0, watchOS 2.0, tvOS 9.0, *)
	public func defaultCascadeList(forLanguages languagePrefList: [String]?) -> [CTFontDescriptor]? {
		return CTFontCopyDefaultCascadeListForLanguages(self, languagePrefList as NSArray?) as! [CTFontDescriptor]?
	}

}
