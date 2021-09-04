//
//  CTLineAdditions.swift
//  CoreTextAdditions
//
//  Created by C.W. Betts on 10/20/17.
//  Copyright © 2017 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText

public extension CTLine {
	/// Options for `CTLine.bounds(with:)`.
	///
	/// Passing `[]` (no options) returns the typographic bounds,
	/// including typographic leading and shifts.
	typealias BoundsOptions = CTLineBoundsOptions
	
	/// Truncation types required by `CTLine.truncate(width:, type:, token:)`. These
	/// will tell truncation engine which type of truncation is being
	/// requested.
	typealias TruncationType = CTLineTruncationType
	
	/// Creates a truncated line from an existing line.
	/// - parameter width:
	/// The width at which truncation will begin. The line will be
	/// truncated if its width is greater than the width passed in this.
	/// - parameter truncationType: The type of truncation to perform if needed.
	/// - parameter truncationToken:
	/// This token will be added to the point where truncation took place
	/// to indicate that the line was truncated. Usually, the truncation
	/// token is the ellipsis character (`U+2026`). If this parameter is
	/// set to `nil`, then no truncation token is used, and the line is
	/// simply cut off. The line specified in `truncationToken` should have
	/// a width less than the width specified by the `width` parameter. If
	/// the `width` of the line specified in `truncationToken` is greater,
	/// this function will return `nil` if truncation is needed.
	/// - returns: This function will return a reference to a truncated `CTLine`
	/// object if the call was successful. Otherwise, it will return
	/// `nil`.
	@inlinable func truncate(width: Double, type truncationType: TruncationType, token truncationToken: CTLine?) -> CTLine? {
		return CTLineCreateTruncatedLine(self, width, truncationType, truncationToken)
	}
	
	/// Creates a justified line from an existing line.
	/// - parameter justificationFactor:
	/// Allows for full or partial justification. When set to `1.0` or
	/// greater indicates, full justification will be performed. If less
	/// than `1.0`, varying degrees of partial justification will be
	/// performed. If set to `0` or less, then no justification will be
	/// performed.
	/// - parameter justificationWidth:
	/// The width to which the resultant line will be justified. If
	/// justificationWidth is less than the actual width of the line,
	/// then negative justification will be performed ("text squishing").
	/// - returns: This function will return a reference to a justified CTLine
	/// object if the call was successful. Otherwise, it will return
	/// `nil`.
	@inlinable func justifiedLine(factor justificationFactor: CGFloat, width justificationWidth: Double) -> CTLine? {
		return CTLineCreateJustifiedLine(self, justificationFactor, justificationWidth)
	}
	
	/// Returns the total glyph count for the line object.
	///
	/// The total glyph count is equal to the sum of all of the glyphs in
	/// the glyph runs forming the line.
	@inlinable var glyphCount: Int {
		return CTLineGetGlyphCount(self)
	}
	
	/// Returns the array of glyph runs that make up the line object.
	///
	/// An `Array` containing the `CTRun` objects that make up the line.
	var glyphRuns: [CTRun] {
		return CTLineGetGlyphRuns(self) as! [CTRun]
	}
	
	/// Gets the range of characters that originally spawned the glyphs
	/// in the line.
	///
	/// A `CFRange` that contains the range over the backing store string
	/// that spawned the glyphs. If the function fails for any reason, an
	/// empty range will be returned.
	@inlinable var stringRange: CFRange {
		return CTLineGetStringRange(self)
	}
	
	/// Gets the pen offset required to draw flush text.
	/// - parameter flushFactor:
	/// Specifies what kind of flushness you want. A `flushFactor` of `0` or
	/// less indicates left flush. A `flushFactor` of `1.0` or more indicates
	/// right flush. Flush factors between `0` and `1.0` indicate varying
	/// degrees of center flush, with a value of `0.5` being totally center
	/// flush.
	/// - parameter flushWidth: Specifies the width that the flushness
	/// operation should apply to.
	/// - returns: A value which can be used to offset the current pen position for
	/// the flush operation.
	@inlinable func penOffsetForFlush(factor flushFactor: CGFloat, width flushWidth: Double) -> Double {
		return CTLineGetPenOffsetForFlush(self, flushFactor, flushWidth)
	}
	
	/// Draws a line.
	///
	/// This is a convenience call, since the line could be drawn
	/// run-by-run by getting the glyph runs and accessing the glyphs out
	/// of them. This call may leave the graphics context in any state and
	/// does not flush the context after drawing. This call also expects
	/// a text matrix with *'y'* values increasing from bottom to top; a
	/// flipped text matrix may result in misplaced diacritics.
	/// - parameter context: The context to which the line will be drawn.
	@inlinable func draw(in context: CGContext) {
		CTLineDraw(self, context)
	}
	
	// MARK: - Line Measurement
	/* --------------------------------------------------------------------------- */
	/* Line Measurement */
	/* --------------------------------------------------------------------------- */
	
	/// Calculates the typographic bounds for a line.
	///
	/// A line's typographic width is the distance to the rightmost
	/// glyph advance width edge. Note that this distance includes
	/// trailing whitespace glyphs.
	var typographicBounds: (width: Double, ascent: CGFloat, descent: CGFloat, leading: CGFloat) {
		var asc: CGFloat = 0
		var des: CGFloat = 0
		var lead: CGFloat = 0
		let width = CTLineGetTypographicBounds(self, &asc, &des, &lead)
		return (width, asc, des, lead)
	}
	
	/// Calculates the bounds for a line.
	/// - parameter options: Desired options or `[]` if none.
	/// - returns: The bounds of the line as specified by the type and options,
	/// such that the coordinate origin is coincident with the line
	/// origin and the rect origin is at the bottom left. If the line
	/// is invalid, this function will return `nil`.
	func bounds(with options: BoundsOptions = []) -> CGRect? {
		let retVal = CTLineGetBoundsWithOptions(self, options)
		if retVal.isNull {
			return nil
		}
		return retVal
	}

	/// Calculates the trailing whitespace width for a line.
	/// - returns: The width of the line's trailing whitespace. If line is invalid,
	/// this function will always return zero.
	///
	/// Creating a line for a width can result in a line that is
	/// actually longer than the desired width due to trailing
	/// whitespace. Normally this is not an issue due to whitespace being
	/// invisible, but this function may be used to determine what amount
	/// of a line's width is due to trailing whitespace.
	@inlinable var trailingWhitespaceWidth: Double {
		return CTLineGetTrailingWhitespaceWidth(self)
	}
	
	/// Calculates the image bounds for a line.
	/// - parameter context:
	/// The context which the image bounds will be calculated for or `nil`,
	/// in which case the bounds are relative to `CGPoint.zero`.
	/// - returns: A rectangle that tightly encloses the paths of the line's glyphs,
	/// which will be translated by the supplied context's text position.
	/// If the line is invalid, `nil` will be returned.
	///
	/// The image bounds for a line is the union of all non-empty glyph
	/// bounding rects, each positioned as it would be if drawn using
	/// CTLineDraw using the current context. Note that the result is
	/// ideal and does not account for raster coverage due to rendering.
	/// This function is purely a convenience for using glyphs as an
	/// image and should not be used for typographic purposes.
	func imageBounds(in context: CGContext?) -> CGRect? {
		let retVal = CTLineGetImageBounds(self, context)
		if retVal.isNull {
			return nil
		}
		return retVal
	}
	
	// MARK: - Line Caret Positioning and Highlighting
	/* --------------------------------------------------------------------------- */
	/* Line Caret Positioning and Highlighting */
	/* --------------------------------------------------------------------------- */

	/// Performs hit testing.
	/// - parameter position: The location of the mouse click relative to the line's origin.
	/// - returns: The string index for the position. Relative to the line's string
	/// range, this value will be no less than the first string index and
	/// no greater than one plus the last string index. In the event of
	/// failure, this function will return `kCFNotFound`.
	///
	/// This function can be used to determine the string index for a
	/// mouse click or other event. This string index corresponds to the
	/// character before which the next character should be inserted.
	/// This determination is made by analyzing the string from which a
	/// typesetter was created and the corresponding glyphs as embodied
	/// by a particular line.
	@inlinable func stringIndex(forPosition position: CGPoint) -> CFIndex {
		return CTLineGetStringIndexForPosition(self, position)
	}
	
	/// Determines the graphical offset(s) for a string index.
	/// - parameter stringIndex: The string index corresponding to the desired position.
	/// - returns: The primary and secondary offsets along the baseline for `charIndex`, or `0.0` in
	/// the event of failure.
	///
	/// This function returns the graphical offset(s) corresponding to
	/// a string index, suitable for movement between adjacent lines or
	/// for drawing a custom caret. For the former, the primary offset
	/// may be adjusted for any relative indentation of the two lines;
	/// a `CGPoint` constructed with the adjusted offset for its x value
	/// and `0.0` for its y value is suitable for passing to
	/// `CTLine.stringIndex(forPosition:)`. In either case, the primary
	/// offset corresponds to the portion of the caret that represents
	/// the visual insertion location for a character whose direction
	/// matches the line's writing direction.
	func offset(stringIndex: Int) -> (primary: CGFloat, secondary: CGFloat) {
		var secondary: CGFloat = 0
		let primary = CTLineGetOffsetForStringIndex(self, stringIndex, &secondary)
		return (primary, secondary)
	}

	/// Enumerates caret offsets for characters in a line.
	/// - parameter block: The `offset` parameter is relative to the line origin. The `leadingEdge`
	/// parameter of this block refers to logical order.
	/// - parameter offset: Relative to the line origin.
	/// - parameter stop: Stops the enumeration.
	/// - parameter leadingEdge: The leading edge in logical order.
	///
	/// The provided block is invoked once for each logical caret edge in the line, in left-to-right visual
	/// order.
	@available(OSX 10.11, iOS 9.0, watchOS 2.0, tvOS 9.0, *)
	func enumerateCaretOffsets(_ block: @escaping (_ offset: Double, _ charIndex: CFIndex, _ leadingEdge: Bool, _ stop: inout Bool) -> Void) {
		CTLineEnumerateCaretOffsets(self) { (offset, charIndex, leadingEdge, stop) in
			block(offset, charIndex, leadingEdge, &stop.pointee)
		}
	}
}
