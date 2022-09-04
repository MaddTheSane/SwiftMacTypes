//
//  CTAttributedStringAdditions.swift
//  CoreTextAdditions
//
//  Created by C.W. Betts on 9/3/22.
//  Copyright © 2022 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public extension AttributeScopes {
	var coreText: AttributeScopes.CoreTextAttributes.Type {
		return CoreTextAttributes.self
	}
	
	struct CoreTextAttributes: AttributeScope {
		/// The font.
		///
		/// Default is Helvetica 12.
		public let font: FontAttribute
		
		/// Never set a foreground color in the CGContext; use what is set as the context's fill color.
		///
		/// Default is `false`. The reason
		/// why this exists is because an `NSAttributedString` defaults to a
		/// black color if no color attribute is set. This forces CoreText to
		/// set the color in the context. This will allow developers to
		/// sidestep this, making CoreText set nothing but font information
		/// in the `CGContext`. If set, this attribute also determines the
		/// color used by `.underlineStyle`, in which case it
		/// overrides the foreground color.
		public let foregroundColorFromContext: ForegroundColorFromContextAttribute

		/// A kerning adjustment.
		///
		/// Default is standard kerning.
		/// The kerning attribute indicate how many points the following
		/// character should be shifted from its default offset as defined
		/// by the current character's font in points; a positive kern
		/// indicates a shift farther along and a negative kern indicates a
		/// shift closer to the current character. If this attribute is not
		/// present, standard kerning will be used. If this attribute is
		/// set to `0.0`, no kerning will be done at all.
		public let kern: KernAttribute
		
		public let rubyAnnotation: RubyAnnotationAttribute
		
		/// Controls vertical text positioning.
		///
		/// Default is `0`. If supported
		/// by the specified font, a value of `1` enables superscripting and a
		/// value of `-1` enables subscripting.
		public let superscript: SuperscriptAttribute

		/// Allows the setting of an underline to be applied at render time.
		///
		/// Default is `CTUnderlineStyle.none`.
		/// Set a value of something other than `.none` to draw
		/// an underline. In addition, the `CTUnderlineStyleModifiers` can be
		/// used to modify the look of the underline. The underline color
		/// will be determined by the text's foreground color.
		public let underline: UnderlineStyleAttribute
		
		/// Controls ligature formation.
		///
		/// Default is int value `1`. The ligature
		/// attribute determines what kinds of ligatures should be used when
		/// displaying the string. A value of `0` indicates that only ligatures
		/// essential for proper rendering of text should be used, `1`
		/// indicates that standard ligatures should be used, and `2` indicates
		/// that all available ligatures should be used. Which ligatures are
		/// standard depends on the script and possibly the font. Arabic
		/// text, for example, requires ligatures for many character
		/// sequences, but has a rich set of additional ligatures that
		/// combine characters. English text has no essential ligatures, and
		/// typically has only two standard ligatures, those for *"fi"* and
		/// *"fl"* -- all others being considered more advanced or fancy.
		public let ligature: LigatureAttribute
		
		/// The foreground color.
		///
		/// Default value is black.
		public let foregroundColor: ForegroundColorAttribute
		
		/// The background color.
		///
		/// Default is no background color.
		public let backgroundColor: BackgroundColorAttribute
		
		/// The stroke width.
		///
		/// Default value is `0.0`, or no stroke.
		/// This attribute, interpreted as a percentage of font point size,
		/// controls the text drawing mode: positive values effect drawing
		/// with stroke only; negative values are for stroke and fill. A
		/// typical value for outlined text is `3.0`.
		public let strokeWidth: StrokeWidthAttribute
		
		/// The stroke color.
		///
		/// Default is the foreground color.
		public let strokeColor: StrokeColorAttribute
		
		/// A `CTParagraphStyle` object which is used to specify things like line alignment, tab rulers,
		/// writing direction, etc.
		///
		/// Default is an empty
		/// `CTParagraphStyle` object: see CTParagraphStyle.h for more
		/// information. The value of this attribute must be uniform over
		/// the range of any paragraphs to which it is applied.
		public let paragraphStyle: ParagraphStyleAttribute
		
		/// Controls glyph orientation.
		///
		/// Default is `false`. A value of `false`
		/// indicates that horizontal glyph forms are to be used, `true`
		/// indicates that vertical glyph forms are to be used.
		public let verticalForms: VerticalFormsAttribute
		
		/// Setting text in tate-chu-yoko form (horizontal numerals in vertical text).
		///
		/// Default is value `0`. A value of `1`
		/// to `4` indicates the number of digits or letters to set in horizontal
		/// form. This is to apply the correct feature settings for the text.
		/// This attribute only works when `.verticalForms` is set to `true`.
		public let horizontalInVerticalForms: HorizontalInVerticalFormsAttribute
		
		/// Allows the use of unencoded glyphs.
		///
		/// The glyph specified by this
		/// `CTGlyphInfo` object is assigned to the entire attribute range,
		/// provided that its contents match the specified base string and
		/// that the specified glyph is available in the font specified by
		/// `.font`. See **CTGlyphInfo.h** for more information.
		public let glyphInfo: GlyphInfoAttribute
		
		/// Specifies text language.
		///
		/// Value must be a `String` containing a locale identifier. Default
		/// is unset. When this attribute is set to a valid identifier, it will
		/// be used to select localized glyphs (if supported by the font) and
		/// locale-specific line breaking rules.
		public let language: LanguageAttribute
		
		/// Allows customization of certain aspects of a range of text's
		/// appearance.
		///
		/// Value must be a `CTRunDelegate`. The values returned by the
		/// embedded object for an attribute range apply to each glyph
		/// resulting from the text in that range. Because an embedded object
		/// is only a display-time modification, care should be taken to
		/// avoid applying this attribute to a range of text with complex
		/// behavior, such as a change of writing direction, combining marks,
		/// etc. Consequently, it is recommended that this attribute be
		/// applied to a range containing the single character *U+FFFC*. See
		/// **CTRunDelegate.h** for more information.
		public let runDelegate: RunDelegateAttribute
		
		/// Key to reference a baseline class override.
		///
		/// Normally,
		/// glyphs on the line will be assigned baseline classes according to
		/// the *'bsln'* or *'BASE'* table in the font. This attribute may be
		/// used to change this assignment.
		public let baselineClass: BaselineClassAttribute
		
		/// Key to reference a baseline info dictionary.
		///
		/// Normally, baseline offsets will
		/// be assigned based on the *'bsln'* or *'BASE'* table in the font. This
		/// attribute may be used to assign different offsets. Each key in
		/// the dictionary is one of the `kCTBaselineClass` constants and the
		/// value is a `Float` of the baseline offset in points. You only
		/// need to specify the offsets you wish to change.
		public let baselineInfo: BaselineInfoAttribute
		
		/// Controls vertical text positioning.
		///
		/// Default is standard positioning.
		/// The baseline attribute indicates how many points the characters
		/// should be shifted perpendicular to their baseline. A positive
		/// baseline value indicates a shift above (or to the right for vertical
		/// text) the text baseline and a negative baseline value indicates a
		/// shift below (or to the left for vertical text) the text baseline.
		/// If this value is set to `0.0`, no baseline shift will be performed.
		///
		/// **Important:** This attribute is different from `NSBaselineOffsetAttributeName`.
		/// If you are writing code for TextKit, you need to use
		/// `NSBaselineOffsetAttributeName`.
		public let baselineOffset: BaselineOffsetAttribute
		
		/// Key to reference a baseline info dictionary for the reference baseline.
		///
		/// Value must be a `Dictionary`. All glyphs in a run are assigned
		/// a baseline class and then aligned to the offset for that class in
		/// the reference baseline baseline info. See the discussion of
		/// `.baselineInfo` for information about the contents
		/// of the dictionary. You can also use the `kCTBaselineReferenceFont`
		/// key to specify that the baseline offsets of a particular
		/// `CTFont` should be used as the reference offsets.
		public let baselineReferenceInfo: BaselineReferenceInfoAttribute
		
		/// Specifies a bidirectional override or embedding.
		///
		/// Value must be an `Array` of `Int`s, each of which should
		/// have a value of either `kCTWritingDirectionLeftToRight` or
		/// `kCTWritingDirectionRightToLeft`, plus one of
		/// `kCTWritingDirectionEmbedding` or `kCTWritingDirectionOverride`.
		/// This array represents a sequence of nested bidirectional
		/// embeddings or overrides, in order from outermost to innermost,
		/// with `(kCTWritingDirectionLeftToRight | kCTWritingDirectionEmbedding)`
		/// corresponding to a LRE/PDF pair in plain text or
		/// `<span dir="ltr"></span>` in HTML,
		/// `(kCTWritingDirectionRightToLeft | kCTWritingDirectionEmbedding)`
		/// corresponding to a RLE/PDF pair in plain text or a `<span dir="rtl"></span>` in HTML,
		/// `(kCTWritingDirectionLeftToRight | kCTWritingDirectionOverride)`
		/// corresponding to a LRO/PDF pair in plain text or
		/// `<bdo dir="ltr"></bdo>` in HTML, and
		/// `(kCTWritingDirectionRightToLeft | kCTWritingDirectionOverride)`
		/// corresponding to a RLO/PDF pair in plain text or `<bdo dir="rtl"></bdo>` in HTML.
		public let writingDirection: WritingDirectionAttribute

		@frozen public enum FontAttribute : AttributedStringKey {			
			public typealias Value = CTFont
						
			public static var name: String {
				return kCTFontAttributeName as String
			}
		}

		@frozen public enum ForegroundColorFromContextAttribute : CodableAttributedStringKey, ObjectiveCConvertibleAttributedStringKey {
			public typealias ObjectiveCValue = NSNumber
			public typealias Value = Bool

			public static func objectiveCValue(for value: Bool) throws -> NSNumber {
				return value as NSNumber
			}
			
			public static func value(for object: NSNumber) throws -> Bool {
				return object.boolValue
			}
			
			public static var name: String {
				return kCTForegroundColorFromContextAttributeName as String
			}
		}

		@frozen public enum KernAttribute : CodableAttributedStringKey, ObjectiveCConvertibleAttributedStringKey {
			public typealias ObjectiveCValue = NSNumber
			public typealias Value = Float

			public static func objectiveCValue(for value: Float) throws -> NSNumber {
				return value as NSNumber
			}
			
			public static func value(for object: NSNumber) throws -> Float {
				return object.floatValue
			}

			public static var name: String {
				return kCTKernAttributeName as String
			}
		}

		@frozen public enum RubyAnnotationAttribute : AttributedStringKey {
			public typealias Value = CTRubyAnnotation

			public static var name: String {
				return kCTRubyAnnotationAttributeName as String
			}
		}
		
		@frozen public enum UnderlineStyleAttribute : CodableAttributedStringKey, ObjectiveCConvertibleAttributedStringKey {
			
			public typealias ObjectiveCValue = NSNumber
			public typealias Value = CTUnderlineStyle

			public static func objectiveCValue(for value: CTUnderlineStyle) throws -> NSNumber {
				return NSNumber(value: value.rawValue)
			}
			
			public static func value(for object: NSNumber) throws -> CTUnderlineStyle {
				return CTUnderlineStyle(rawValue: object.int32Value)
			}

			public static func decode(from decoder: Decoder) throws -> CTUnderlineStyle {
				let a = try Int32(from: decoder)
				return Value(rawValue: a)
			}
			
			public static func encode(_ value: CTUnderlineStyle, to encoder: Encoder) throws {
				try value.rawValue.encode(to: encoder)
			}

			public static var name: String {
				return kCTUnderlineStyleAttributeName as String
			}
		}
		
		@frozen public enum LigatureAttribute : CodableAttributedStringKey, ObjectiveCConvertibleAttributedStringKey {
			public typealias ObjectiveCValue = NSNumber
			public typealias Value = Int

			public static func objectiveCValue(for value: Int) throws -> NSNumber {
				return value as NSNumber
			}
			
			public static func value(for object: NSNumber) throws -> Int {
				return object.intValue
			}

			public static var name: String {
				return kCTLigatureAttributeName as String
			}
		}

		@frozen public enum SuperscriptAttribute : CodableAttributedStringKey, ObjectiveCConvertibleAttributedStringKey {
			public typealias ObjectiveCValue = NSNumber
			public typealias Value = Int

			public static func objectiveCValue(for value: Int) throws -> NSNumber {
				return value as NSNumber
			}
			
			public static func value(for object: NSNumber) throws -> Int {
				return object.intValue
			}

			public static var name: String {
				return kCTSuperscriptAttributeName as String
			}
		}
		
		@frozen public enum ForegroundColorAttribute : AttributedStringKey {
			public typealias Value = CGColor
			
			public static var name: String {
				return kCTForegroundColorAttributeName as String
			}
		}

		@frozen public enum BackgroundColorAttribute : AttributedStringKey {
			public typealias Value = CGColor
			
			public static var name: String {
				return kCTBackgroundColorAttributeName as String
			}
		}
		
		@frozen public enum StrokeWidthAttribute : CodableAttributedStringKey, ObjectiveCConvertibleAttributedStringKey {
			public typealias ObjectiveCValue = NSNumber
			public typealias Value = Float

			public static func objectiveCValue(for value: Float) throws -> NSNumber {
				return value as NSNumber
			}
			
			public static func value(for object: NSNumber) throws -> Float {
				return object.floatValue
			}

			public static var name: String {
				return kCTStrokeWidthAttributeName as String
			}
		}

		@frozen public enum StrokeColorAttribute : AttributedStringKey {
			public typealias Value = CGColor
			
			public static var name: String {
				return kCTStrokeColorAttributeName as String
			}
		}

		@frozen public enum ParagraphStyleAttribute : AttributedStringKey {
			public typealias Value = CTParagraphStyle
			
			public static var name: String {
				return kCTParagraphStyleAttributeName as String
			}
		}
		
		@frozen public enum VerticalFormsAttribute : CodableAttributedStringKey, ObjectiveCConvertibleAttributedStringKey {
			public typealias ObjectiveCValue = NSNumber
			public typealias Value = Bool

			public static func objectiveCValue(for value: Bool) throws -> NSNumber {
				return value as NSNumber
			}
			
			public static func value(for object: NSNumber) throws -> Bool {
				return object.boolValue
			}

			public static var name: String {
				return kCTVerticalFormsAttributeName as String
			}
		}

		@frozen public enum HorizontalInVerticalFormsAttribute : CodableAttributedStringKey, ObjectiveCConvertibleAttributedStringKey {
			public typealias ObjectiveCValue = NSNumber
			public typealias Value = Int

			public static func objectiveCValue(for value: Int) throws -> NSNumber {
				return value as NSNumber
			}
			
			public static func value(for object: NSNumber) throws -> Int {
				return object.intValue
			}

			public static var name: String {
				return kCTHorizontalInVerticalFormsAttributeName as String
			}
		}

		@frozen public enum GlyphInfoAttribute : AttributedStringKey {
			public typealias Value = CTGlyphInfo

			public static var name: String {
				return kCTGlyphInfoAttributeName as String
			}
		}

		@frozen public enum LanguageAttribute : CodableAttributedStringKey, ObjectiveCConvertibleAttributedStringKey {
			public typealias ObjectiveCValue = NSString
			public typealias Value = String
			
			public static func objectiveCValue(for value: String) throws -> NSString {
				return value as NSString
			}
			
			public static func value(for object: NSString) throws -> String {
				return object as String
			}
			
			public static var name: String {
				return kCTLanguageAttributeName as String
			}
		}

		@frozen public enum RunDelegateAttribute : AttributedStringKey {
			public typealias Value = CTRunDelegate

			public static var name: String {
				return kCTRunDelegateAttributeName as String
			}
		}

		@frozen public enum BaselineClassAttribute : CodableAttributedStringKey, ObjectiveCConvertibleAttributedStringKey {
			
			public typealias ObjectiveCValue = NSString
			public typealias Value = CTBaselineClass
			
			public static func objectiveCValue(for value: CTBaselineClass) throws -> NSString {
				return value.rawValue
			}
			
			public static func value(for object: NSString) throws -> CTBaselineClass {
				guard let val = CTBaselineClass(rawValue: object) else {
					throw CocoaError(.coderInvalidValue)
				}
				return val
			}
			
			public static var name: String {
				return kCTBaselineClassAttributeName as String
			}
		}
		
		@frozen public enum BaselineInfoAttribute : CodableAttributedStringKey, ObjectiveCConvertibleAttributedStringKey {
			
			public typealias ObjectiveCValue = NSDictionary
			public typealias Value = [CTBaselineClass: Float]
			
			public static func objectiveCValue(for value: [CTBaselineClass: Float]) throws -> NSDictionary {
				let outDict = NSMutableDictionary(capacity: value.count)
				for (key, val) in value {
					outDict[key.rawValue as String] = val
				}
				return NSDictionary(dictionary: outDict)
			}
			
			public static func value(for object: NSDictionary) throws -> [CTBaselineClass: Float] {
				guard let a = object as? [String: Float] else {
					throw CocoaError(.coderInvalidValue)
				}
				let retDict = try a.map { (key: String, value: Float) -> (CTBaselineClass, Float) in
					guard let val = CTBaselineClass(stringValue: key) else {
						throw CocoaError(.coderInvalidValue)
					}
					return (val, value)
				}
				return Dictionary(uniqueKeysWithValues: retDict)
			}
			
			public static var name: String {
				return kCTBaselineInfoAttributeName as String
			}
		}

		@frozen public enum BaselineOffsetAttribute : CodableAttributedStringKey, ObjectiveCConvertibleAttributedStringKey {
			public typealias ObjectiveCValue = NSNumber
			public typealias Value = Float

			public static func objectiveCValue(for value: Float) throws -> NSNumber {
				return value as NSNumber
			}
			
			public static func value(for object: NSNumber) throws -> Float {
				return object.floatValue
			}

			public static var name: String {
				return kCTBaselineOffsetAttributeName as String
			}
		}

		@frozen public enum BaselineReferenceInfoAttribute : AttributedStringKey, ObjectiveCConvertibleAttributedStringKey {
			public typealias ObjectiveCValue = NSDictionary
			public typealias Value = [String: AnyHashable]

			public static func objectiveCValue(for value: [String: AnyHashable]) throws -> NSDictionary {
				return value as NSDictionary
			}
			
			public static func value(for object: NSDictionary) throws -> [String: AnyHashable] {
				guard let val = object as? [String: AnyHashable] else {
					throw CocoaError(.coderInvalidValue)
				}
				return val
			}

			public static var name: String {
				return kCTBaselineReferenceInfoAttributeName as String
			}
		}
		
		@frozen public enum WritingDirectionAttribute : CodableAttributedStringKey, ObjectiveCConvertibleAttributedStringKey {
			public typealias ObjectiveCValue = NSArray
			public typealias Value = [Int]

			public static func objectiveCValue(for value: [Int]) throws -> NSArray {
				return value as NSArray
			}
			
			public static func value(for object: NSArray) throws -> [Int] {
				guard let toRet = object as? [Int] else {
					throw CocoaError(.coderInvalidValue)
				}
				return toRet
			}

			public static var name: String {
				return kCTWritingDirectionAttributeName as String
			}
		}
		
		public typealias DecodingConfiguration = AttributeScopeCodableConfiguration

		public typealias EncodingConfiguration = AttributeScopeCodableConfiguration
	}
}

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public extension AttributeDynamicLookup {
	subscript<T>(dynamicMember keyPath: KeyPath<AttributeScopes.CoreTextAttributes, T>) -> T where T : AttributedStringKey {
		return self[T.self]
	}
}
