//
//  CTStringAttributesAdditions.swift
//  CoreTextAdditions
//
//  Created by C.W. Betts on 10/19/17.
//  Copyright © 2017 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText

extension NSAttributedString.Key {
	
	/// Namespace of CoreText attributed string keys.
	///
	/// Note that these may overlap *or* be different than the ones provided by AppKit/UIKit.
	public enum CoreText {
		/// Allows the setting of an underline to be applied at render time.
		///
		/// Value must be a raw value of `CTUnderlineStyle`. Default is `CTUnderlineStyle.none`.
		/// Set a value of something other than `.none` to draw
		/// an underline. In addition, the `CTUnderlineStyleModifiers` can be
		/// used to modify the look of the underline. The underline color
		/// will be determined by the text's foreground color.
		///
		/// Remember to unwrap `enum`s and `OptionSet`s when interacting with
		/// CoreFoundation/Objective-C code by calling `.rawValue`, otherwise Foundation
		/// won't know how to read it.
		public static var underlineStyle: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTUnderlineStyleAttributeName as String)
		}
		
		/// The font.
		///
		/// Value must be a `CTFont`. Default is Helvetica 12.
		public static var font: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTFontAttributeName as String)
		}
		
		/// The dictionary of font traits for stylistic information.
		public static var fontTraits: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTFontTraitsAttribute as String)
		}
		
		/// Never set a foreground color in the CGContext; use what is set as the context's fill color.
		///
		/// Value must be a `Bool`. Default is `false`. The reason
		/// why this exists is because an `NSAttributedString` defaults to a
		/// black color if no color attribute is set. This forces CoreText to
		/// set the color in the context. This will allow developers to
		/// sidestep this, making CoreText set nothing but font information
		/// in the `CGContext`. If set, this attribute also determines the
		/// color used by `.underlineStyle`, in which case it
		/// overrides the foreground color.
		public static var foregroundColorFromContext: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTForegroundColorFromContextAttributeName as String)
		}
		
		/// Key to reference a `CTRubyAnnotation`.
		@available(OSX 10.10, iOS 8.0, watchOS 2.0, tvOS 9.0, *)
		public static var rubyAnnotation: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTRubyAnnotationAttributeName as String)
		}
		
		/// A kerning adjustment.
		///
		/// Value must be a `Float`. Default is standard kerning.
		/// The kerning attribute indicate how many points the following
		/// character should be shifted from its default offset as defined
		/// by the current character's font in points; a positive kern
		/// indicates a shift farther along and a negative kern indicates a
		/// shift closer to the current character. If this attribute is not
		/// present, standard kerning will be used. If this attribute is
		/// set to `0.0`, no kerning will be done at all.
		public static var kern: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTKernAttributeName as String)
		}
		
		/// Controls ligature formation.
		///
		/// Value must be an `Int`. Default is int value `1`. The ligature
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
		public static var ligature: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTLigatureAttributeName as String)
		}
		
		/// The foreground color.
		///
		/// Value must be a `CGColor`. Default value is black.
		public static var foregroundColor: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTForegroundColorAttributeName as String)
		}
		
		/// The background color.
		///
		/// Value must be a `CGColor`. Default is no background color.
		@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
		public static var backgroundColor: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTBackgroundColorAttributeName as String)
		}
		
		/// A `CTParagraphStyle` object which is used to specify things like line alignment, tab rulers,
		/// writing direction, etc.
		///
		/// Value must be a `CTParagraphStyle`. Default is an empty
		/// `CTParagraphStyle` object: see CTParagraphStyle.h for more
		/// information. The value of this attribute must be uniform over
		/// the range of any paragraphs to which it is applied.
		public static var paragraphStyle: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTParagraphStyleAttributeName as String)
		}
		
		/// The stroke width.
		///
		/// Value must be a `Float`. Default value is `0.0`, or no stroke.
		/// This attribute, interpreted as a percentage of font point size,
		/// controls the text drawing mode: positive values effect drawing
		/// with stroke only; negative values are for stroke and fill. A
		/// typical value for outlined text is `3.0`.
		public static var strokeWidth: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTStrokeWidthAttributeName as String)
		}
		
		/// The stroke color.
		///
		/// Value must be a `CGColor`. Default is the foreground color.
		public static var strokeColor: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTStrokeColorAttributeName as String)
		}
		
		/// Controls vertical text positioning.
		///
		/// Value must be an `Int`. Default is `0`. If supported
		/// by the specified font, a value of `1` enables superscripting and a
		/// value of `-1` enables subscripting.
		public static var superscript: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTSuperscriptAttributeName as String)
		}

		/// The underline color.
		///
		/// Value must be a `CGColor`. Default is the foreground color.
		public static var underlineColor: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTUnderlineColorAttributeName as String)
		}
		
		/// Controls glyph orientation.
		///
		/// Value must be a `Bool`. Default is `false`. A value of `false`
		/// indicates that horizontal glyph forms are to be used, `true`
		/// indicates that vertical glyph forms are to be used.
		public static var verticalForms: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTVerticalFormsAttributeName as String)
		}

		/// Setting text in tate-chu-yoko form (horizontal numerals in vertical text).
		///
		/// Value must be an `Int`. Default is value `0`. A value of `1`
		/// to `4` indicates the number of digits or letters to set in horizontal
		/// form. This is to apply the correct feature settings for the text.
		/// This attribute only works when `.verticalForms` is set to `true`.
		@available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
		public static var horizontalInVerticalForms: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTHorizontalInVerticalFormsAttributeName as String)
		}
		
		/// Allows the use of unencoded glyphs.
		///
		/// Value must be a `CTGlyphInfo`. The glyph specified by this
		/// `CTGlyphInfo` object is assigned to the entire attribute range,
		/// provided that its contents match the specified base string and
		/// that the specified glyph is available in the font specified by
		/// `.font`. See **CTGlyphInfo.h** for more information.
		public static var glyphInfo: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTGlyphInfoAttributeName as String)
		}

		/// Specifies text language.
		///
		/// Value must be a `String` containing a locale identifier. Default
		/// is unset. When this attribute is set to a valid identifier, it will
		/// be used to select localized glyphs (if supported by the font) and
		/// locale-specific line breaking rules.
		public static var language: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTLanguageAttributeName as String)
		}
		
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
		/// CTRunDelegate.h for more information.
		public static var runDelegate: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTRunDelegateAttributeName as String)
		}

		/// Key to reference a baseline class override.
		///
		/// Value must be one of the `kCTBaselineClass` constants. Normally,
		/// glyphs on the line will be assigned baseline classes according to
		/// the *'bsln'* or *'BASE'* table in the font. This attribute may be
		/// used to change this assignment.
		public static var baselineClass: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTBaselineClassAttributeName as String)
		}
		
		/// Key to reference a baseline info dictionary.
		///
		/// Value must be a `Dictionary`. Normally, baseline offsets will
		/// be assigned based on the *'bsln'* or *'BASE'* table in the font. This
		/// attribute may be used to assign different offsets. Each key in
		/// the dictionary is one of the `kCTBaselineClass` constants and the
		/// value is a `Float` of the baseline offset in points. You only
		/// need to specify the offsets you wish to change.
		public static var baselineInfo: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTBaselineInfoAttributeName as String)
		}
		
		/// Key to reference a baseline info dictionary for the reference baseline.
		///
		/// Value must be a `Dictionary`. All glyphs in a run are assigned
		/// a baseline class and then aligned to the offset for that class in
		/// the reference baseline baseline info. See the discussion of
		/// `.baselineInfo` for information about the contents
		/// of the dictionary. You can also use the `kCTBaselineReferenceFont`
		/// key to specify that the baseline offsets of a particular
		/// `CTFont` should be used as the reference offsets.
		public static var baselineReferenceInfo: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTBaselineReferenceInfoAttributeName as String)
		}
		
		/// Controls vertical text positioning.
		///
		/// Value must be a `Float`. Default is standard positioning.
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
		@available(OSX 10.13, iOS 11.0, watchOS 4.0, tvOS 11.0, *)
		public static var baselineOffset: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTBaselineOffsetAttributeName as String)
		}

		/// Specifies a bidirectional override or embedding.
		///
		/// Value must be a `CFArray` of `CFNumber`s, each of which should
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
		public static var writingDirection: NSAttributedString.Key {
			return NSAttributedString.Key(rawValue: kCTWritingDirectionAttributeName as String)
		}
	}
}
