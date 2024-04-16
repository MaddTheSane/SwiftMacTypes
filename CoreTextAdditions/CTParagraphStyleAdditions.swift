//
//  CTParagraphStyleAdditions.swift
//  CoreTextAdditions
//
//  Created by C.W. Betts on 2/27/20.
//  Copyright © 2020 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText

public extension CTParagraphStyle {
	/// These constants specify text alignment.
	typealias Alignment = CTTextAlignment
	
	/// These constants specify what happens when a line is too long for its frame.
	typealias LineBreakMode = CTLineBreakMode
	
	/// These constants specify the writing direction.
	typealias WritingDirection = CTWritingDirection
	
    /// These constants are used to query and modify the `CTParagraphStyle`
    /// object.
	///
	/// Each specifier has a type and a default value associated with it.
	/// The type must always be observed when setting or fetching the
	/// value from the `CTParagraphStyle` object. In addition, some
	/// specifiers affect the behavior of both the framesetter and
	/// the typesetter, and others only affect the behavior of the
	/// framesetter; this is also noted below.
	typealias Specifier = CTParagraphStyleSpecifier
	
	/// This structure is used to alter the paragraph style.
	typealias Setting = CTParagraphStyleSetting
	
	/// Creates an immutable paragraph style.
	/// - parameter settings: The settings that you wish to pre-load the paragraph style
	/// with. If you wish to specify the default set of settings,
	/// then this parameter may be set to `nil`.
	/// - returns: If the paragraph style creation was successful, this function
	/// will return a valid reference to an immutable `CTParagraphStyle`
	/// object. Otherwise, this function will return `nil`.
	///
	/// Using this function is the easiest and most efficient way to
	/// create a paragraph style. Paragraph styles should be kept
	/// immutable for totally lock-free operation.
	///
	/// If an invalid paragraph style setting specifier is passed into
	/// the "settings" parameter, nothing bad will happen but just don't
	/// expect to be able to query for this value. This is to allow
	/// backwards compatibility with style setting specifiers that may
	/// be introduced in future versions.
	class func create(settings: [Setting]?) -> CTParagraphStyle {
		return CTParagraphStyleCreate(settings, settings?.count ?? 0)
	}
	
	/// Creates an immutable copy of the paragraph style.
	/// - returns: If the "paragraphStyle" reference is valid, then this
	/// function will return valid reference to an immutable
	/// CTParagraphStyle object that is a copy of the one passed into
	/// "paragraphStyle".
	@inlinable func copy() -> CTParagraphStyle {
		return CTParagraphStyleCreateCopy(self)
	}
	
	/// Obtains the current value for a single setting specifier.
	/// - parameter specifier: The setting specifier that you want to get the value for.
	/// - parameter valueBufferSize: The size of the buffer pointed to by the
	/// "valueBuffer" parameter. This value must be at least as large as the size the
	/// required by the `Specifier` value set in the "spec" parameter.
	/// - parameter valueBuffer: The buffer where the requested setting value will be
	/// written upon successful completion. The buffer's size needs to be at least as
	/// large as the value passed into "valueBufferSize".
	/// - returns: This function will return "true" if the `valueBuffer` had been
	/// successfully filled. Otherwise, this function will return `false`,
	/// indicating that one or more of the parameters is not valid.
	///
	/// This function will return the current value of the specifier
	/// whether or not the user had actually set it. If the user has
	/// not set it, this function will return the default value.
	///
	/// If an invalid paragraph style setting specifier is passed into
	/// the "spec" parameter, nothing bad will happen and the buffer
	/// value will simply be zeroed out. This is to allow backwards
	/// compatibility with style setting specifier that may be introduced
	/// in future versions.
	@inlinable func value(for specifier: Specifier, bufferSize valueBufferSize: Int, buffer valueBuffer: UnsafeMutableRawPointer) -> Bool {
		return CTParagraphStyleGetValueForSpecifier(self, specifier, valueBufferSize, valueBuffer)
	}
}

public extension CTParagraphStyle {
	/// Obtains the current value for a single setting specifier.
	/// - parameter specifier: The setting specifier that you want to get the value for.
	/// - parameter valueBuffer: The buffer where the requested setting value will be
	/// written upon successful completion. The buffer's size must be at least as large as the size the
	/// required by the `Specifier` value set in the "spec" parameter.
	/// - returns: This function will return "true" if the `valueBuffer` had been
	/// successfully filled. Otherwise, this function will return `false`,
	/// indicating that one or more of the parameters is not valid.
	///
	/// This function will return the current value of the specifier
	/// whether or not the user had actually set it. If the user has
	/// not set it, this function will return the default value.
	///
	/// If an invalid paragraph style setting specifier is passed into
	/// the "spec" parameter, nothing bad will happen and the buffer
	/// value will simply be zeroed out. This is to allow backwards
	/// compatibility with style setting specifier that may be introduced
	/// in future versions.
	@inlinable func value(for specifier: Specifier, buffer valueBuffer: UnsafeMutableRawBufferPointer) -> Bool {
		return CTParagraphStyleGetValueForSpecifier(self, specifier, valueBuffer.count, valueBuffer.baseAddress!)
	}
	
	/// The text alignment. Natural text alignment is realized as
	/// left or right alignment, depending on the line sweep direction
	/// of the first script contained in the paragraph.
	///
	/// Default: `CTTextAlignment.natural`
	/// Application: CTFramesetter
	var alignment: Alignment {
		var toRet = Alignment.natural
		let success = CTParagraphStyleGetValueForSpecifier(self, .alignment, MemoryLayout.size(ofValue: toRet), &toRet)
		return toRet
	}
	
	/// The distance in points from the leading margin of a frame to
	/// the beginning of the paragraph's first line. This value is always
	/// nonnegative.
	///
	/// Default: 0.0
	/// Application: CTFramesetter
	var firstLineHeadIndent: CGFloat {
		var toRet = CGFloat(0)
		let success = CTParagraphStyleGetValueForSpecifier(self, .firstLineHeadIndent, MemoryLayout.size(ofValue: toRet), &toRet)
		return toRet
	}
	
	/// The distance in points from the leading margin of a text
	/// container to the beginning of lines other than the first.
	/// This value is always nonnegative.
	///
	/// Default: 0.0
	/// Application: CTFramesetter
	var headIndent: CGFloat {
		var toRet = CGFloat(0)
		let success = CTParagraphStyleGetValueForSpecifier(self, .headIndent, MemoryLayout.size(ofValue: toRet), &toRet)
		return toRet
	}
	
	/// The distance in points from the margin of a frame to the end of
	/// lines. If positive, this value is the distance from the leading
	/// margin (for example, the left margin in left-to-right text).
	/// If 0 or negative, it's the distance from the trailing margin.
	///
	/// Default: 0.0
	/// Application: CTFramesetter
	var tailIndent: CGFloat {
		var toRet = CGFloat(0)
		let success = CTParagraphStyleGetValueForSpecifier(self, .tailIndent, MemoryLayout.size(ofValue: toRet), &toRet)
		return toRet
	}

	/// The CTTextTab objects, sorted by location, that define the tab
	/// stops for the paragraph style.
	///
	/// Default: 12 left-aligned tabs, spaced by 28.0 points
	/// Application: CTFramesetter, CTTypesetter
	var tabStops: [CTTextTab] {
		var toRet: Unmanaged<CFArray>? = nil
		let success = CTParagraphStyleGetValueForSpecifier(self, .tabStops, MemoryLayout.size(ofValue: toRet), &toRet)
		return toRet?.takeUnretainedValue() as? [CTTextTab] ?? []
	}
	
	/// The document-wide default tab interval. Tabs after the last
	/// specified by `tabStops` are placed at
	/// integer multiples of this distance (if positive).
	///
	/// Default: 0.0
	/// Application: CTFramesetter, CTTypesetter
	var defaultTabInterval: CGFloat {
		var toRet = CGFloat(0)
		let success = CTParagraphStyleGetValueForSpecifier(self, .defaultTabInterval, MemoryLayout.size(ofValue: toRet), &toRet)
		return toRet
	}

	/// The mode that should be used to break lines when laying out
	/// the paragraph's text.
	///
	/// Default: kCTLineBreakByWordWrapping
	/// Application: CTFramesetter
	var lineBreakMode: LineBreakMode {
		var toRet = LineBreakMode.byWordWrapping
		let success = CTParagraphStyleGetValueForSpecifier(self, .alignment, MemoryLayout.size(ofValue: toRet), &toRet)
		return toRet
	}
	
	/// The maximum height that any line in the frame will occupy,
	/// regardless of the font size or size of any attached graphic.
	/// Glyphs and graphics exceeding this height will overlap
	/// neighboring lines. A maximum height of 0 implies
	/// no line height limit. This value is always nonnegative.
	///
	/// Default: 0.0
	/// Application: CTFramesetter
	var maximumLineHeight: CGFloat {
		var toRet = CGFloat(0)
		let success = CTParagraphStyleGetValueForSpecifier(self, .maximumLineHeight, MemoryLayout.size(ofValue: toRet), &toRet)
		return toRet
	}
	
	/// The minimum height that any line in the frame will occupy,
	/// regardless of the font size or size of any attached graphic.
	/// This value is always nonnegative.
	///
	/// Default: 0.0
	/// Application: CTFramesetter
	var minimumLineHeight: CGFloat {
		var toRet = CGFloat(0)
		let success = CTParagraphStyleGetValueForSpecifier(self, .minimumLineHeight, MemoryLayout.size(ofValue: toRet), &toRet)
		return toRet
	}

	/// The space added at the end of the paragraph to separate it from
	/// the following paragraph. This value is always nonnegative and is
	/// determined by adding the previous paragraph's
	/// `.paragraphSpacing` setting and the
	/// current paragraph's `.paragraphSpacingBefore`
	/// setting.
	///
	/// Default: 0.0
	/// Application: CTFramesetter
	var paragraphSpacing: CGFloat {
		var toRet = CGFloat(0)
		let success = CTParagraphStyleGetValueForSpecifier(self, .paragraphSpacing, MemoryLayout.size(ofValue: toRet), &toRet)
		return toRet
	}

	/// The distance between the paragraph's top and the beginning of
	/// its text content.
	///
	/// Default: 0.0
	/// Application: CTFramesetter
	var paragraphSpacingBefore: CGFloat {
		var toRet = CGFloat(0)
		let success = CTParagraphStyleGetValueForSpecifier(self, .paragraphSpacingBefore, MemoryLayout.size(ofValue: toRet), &toRet)
		return toRet
	}

	/// The base writing direction of the lines.
	///
	/// Default: `WritingDirection.natural`
	/// Application: CTFramesetter, CTTypesetter
	var baseWritingDirection: WritingDirection {
		var toRet = WritingDirection.natural
		let success = CTParagraphStyleGetValueForSpecifier(self, .baseWritingDirection, MemoryLayout.size(ofValue: toRet), &toRet)
		return toRet
	}
	
	/// The maximum space in points between lines within the paragraph
	/// (commonly known as leading).
	///
	/// Default: some large number.
	/// Application: CTFramesetter
	var maximumLineSpacing: CGFloat {
		var toRet = CGFloat(0)
		let success = CTParagraphStyleGetValueForSpecifier(self, .maximumLineSpacing, MemoryLayout.size(ofValue: toRet), &toRet)
		return toRet
	}

	/// The minimum space in points between lines within the paragraph
	/// (commonly known as leading).
	///
	/// Default: 0.0
	/// Application: CTFramesetter
	var minimumLineSpacing: CGFloat {
		var toRet = CGFloat(0)
		let success = CTParagraphStyleGetValueForSpecifier(self, .minimumLineSpacing, MemoryLayout.size(ofValue: toRet), &toRet)
		return toRet
	}

	/// The space in points added between lines within the paragraph
	/// (commonly known as leading).
	///
	/// Default: 0.0
	/// Application: CTFramesetter
	var lineSpacingAdjustment: CGFloat {
		var toRet = CGFloat(0)
		let success = CTParagraphStyleGetValueForSpecifier(self, .lineSpacingAdjustment, MemoryLayout.size(ofValue: toRet), &toRet)
		return toRet
	}

	/// The options controlling the alignment of the line edges with
	/// the leading and trailing margins.
	///
	/// Default: `[]` (no options)
	/// Application: CTTypesetter
	var lineBoundsOptions: CTLine.BoundsOptions {
		var toRet: CTLineBoundsOptions = []
		let success = CTParagraphStyleGetValueForSpecifier(self, .lineBoundsOptions, MemoryLayout.size(ofValue: toRet), &toRet)
		return toRet
	}
}
