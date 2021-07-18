//
//  CTRunAdditions.swift
//  CoreTextAdditions
//
//  Created by C.W. Betts on 10/20/17.
//  Copyright © 2017 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText

public extension CTRun {
	/// A bitfield passed back by the `CTRun.status` getter that is used to indicate the disposition of the
	/// run.
	typealias Status = CTRunStatus
	
	/// Gets the glyph count for the run.
	///
	/// The number of glyphs that the run contains. It is totally
	/// possible that this function could return a value of zero,
	/// indicating that there are no glyphs in this run.
	@inlinable var glyphCount: Int {
		return CTRunGetGlyphCount(self)
	}
	
	/// Returns the attribute dictionary that was used to create the
	/// glyph run.
	///
	/// This dictionary returned is either the same exact one that was
	/// set as an attribute dictionary on the original attributed string
	/// or a dictionary that has been manufactured by the layout engine.
	/// Attribute dictionaries can be manufactured in the case of font
	/// substitution or if they are missing critical attributes.
	var attributes: [String: Any]? {
		return CTRunGetAttributes(self) as? [String: Any]
	}
	
	/// The run's current status.
	///
	/// In addition to attributes, runs also have status that can be
	/// used to expedite certain operations. Knowing the direction and
	/// ordering of a run's glyphs can aid in string index analysis,
	/// whereas knowing whether the positions reference the identity
	/// text matrix can avoid expensive comparisons. Note that this
	/// status is provided as a convenience, since this information is
	/// not strictly necessary but can certainly be helpful.
	@inlinable var status: Status {
		return CTRunGetStatus(self)
	}
	
	/// All the glyphs in the run.
	///
	/// The glyph array will have a length equal to the value returned by
	/// `CTRun.glyphCount`.
	///
	/// The returned value might reference internal memory used by the `CTRun`
	/// object. If you want to keep the buffer beyond the scope of the run, copy
	/// the collection by passing it to the `Array` constructor.
	var glyphs: AnyRandomAccessCollection<CGGlyph> {
		if let preGlyph = CTRunGetGlyphsPtr(self) {
			return AnyRandomAccessCollection(UnsafeBufferPointer(start: preGlyph, count: glyphCount))
		} else if glyphCount > 0 {
			var preArr = [CGGlyph](repeating: 0, count: glyphCount)
			CTRunGetGlyphs(self, CFRange(location: 0, length: 0), &preArr)
			return AnyRandomAccessCollection(preArr)
		} else {
			return AnyRandomAccessCollection([])
		}
	}

	/// Copies a range of glyphs.
	/// - parameter range:
	/// The range of glyphs to be copied, with the entire range having a
	/// location of `0` and a length of `CTRun.glyphCount`. If the length
	/// of the range is set to `0`, then the operation will continue from
	/// the range's start index to the end of the run.
	/// - returns: The glyphs in the specified range.
	func glyphs(in range: CFRange) -> [CGGlyph] {
		guard range.length != 0 else {
			return Array(glyphs)
		}
		var preArr = [CGGlyph](repeating: 0, count: range.length)
		CTRunGetGlyphs(self, range, &preArr)
		return preArr
	}
	
	/// The glyph positions in the run.
	///
	/// The glyph positions in a run are relative to the origin of the
	/// line containing the run. The position array will have a length
	/// equal to the value returned by `CTRun.glyphCount`.
	///
	/// The returned value might reference internal memory used by the `CTRun`
	/// object. If you want to keep the buffer beyond the scope of the run, copy
	/// the collection by passing it to the `Array` constructor.
	var positions: AnyRandomAccessCollection<CGPoint> {
		if let preGlyph = CTRunGetPositionsPtr(self) {
			return AnyRandomAccessCollection(UnsafeBufferPointer(start: preGlyph, count: glyphCount))
		} else if glyphCount > 0 {
			var preArr = [CGPoint](repeating: CGPoint(), count: glyphCount)
			CTRunGetPositions(self, CFRange(location: 0, length: 0), &preArr)
			return AnyRandomAccessCollection(preArr)
		} else {
			return AnyRandomAccessCollection([])
		}
	}
	
	/// Copies a range of glyph positions.
	/// - parameter range:
	/// The range of glyph positions to be copied, with the entire range
	/// having a location of `0` and a length of `CTRun.glyphCount`. If the
	/// length of the range is set to `0`, then the operation will continue
	/// from the range's start index to the end of the run.
	/// - returns: The glyph positions.
	func positions(in range: CFRange) -> [CGPoint] {
		guard range.length != 0 else {
			return Array(positions)
		}
		var preArr = [CGPoint](repeating: CGPoint(), count: range.length)
		CTRunGetPositions(self, range, &preArr)
		return preArr
	}
	
	/// The glyph advance array used in the run.
	///
	/// The advance array will have a length equal to the value returned
	/// by `CTRun.glyphCount`.
	/// Note that advances alone are not sufficient for correctly
	/// positioning glyphs in a line, as a run may have a non-identity
	/// matrix or the initial glyph in a line may have a non-zero origin;
	/// callers should consider using positions instead.
	///
	/// The returned value might reference internal memory used by the `CTRun`
	/// object. If you want to keep the buffer beyond the scope of the run, copy
	/// the collection by passing it to the `Array` constructor.
	var advances: AnyRandomAccessCollection<CGSize> {
		if let preAdv = CTRunGetAdvancesPtr(self) {
			return AnyRandomAccessCollection(UnsafeBufferPointer(start: preAdv, count: glyphCount))
		} else if glyphCount > 0 {
			var preArr = [CGSize](repeating: CGSize(), count: glyphCount)
			CTRunGetAdvances(self, CFRange(location: 0, length: 0), &preArr)
			return AnyRandomAccessCollection(preArr)
		} else {
			return AnyRandomAccessCollection([])
		}
	}
	
	/// Copies a range of glyph advances.
	/// - parameter range:
	/// The range of glyph advances to be copied, with the entire range
	/// having a location of `0` and a length of `CTRun.glyphCount`. If the
	/// length of the range is set to `0`, then the operation will continue
	/// from the range's start index to the end of the run.
	/// - returns: An array of glyph advances.
	func advances(in range: CFRange) -> [CGSize] {
		guard range.length != 0 else {
			return Array(advances)
		}
		var preArr = [CGSize](repeating: CGSize(), count: range.length)
		CTRunGetAdvances(self, range, &preArr)
		return preArr
	}
	
	/// The string indices used in the run.
	///
	/// The indices are the character indices that originally spawned the
	/// glyphs that make up the run. They can be used to map the glyphs in
	/// the run back to the characters in the backing store. The string
	/// indices array will have a length equal to the value returned by
	/// `CTRun.glyphCount`.
	///
	/// The returned value might reference internal memory used by the `CTRun`
	/// object. If you want to keep the buffer beyond the scope of the run, copy
	/// the collection by passing it to the `Array` constructor.
	var stringIndices: AnyRandomAccessCollection<CFIndex> {
		if let preGlyph = CTRunGetStringIndicesPtr(self) {
			return AnyRandomAccessCollection(UnsafeBufferPointer(start: preGlyph, count: glyphCount))
		} else if glyphCount > 0 {
			var preArr = [CFIndex](repeating: 0, count: glyphCount)
			CTRunGetStringIndices(self, CFRange(location: 0, length: 0), &preArr)
			return AnyRandomAccessCollection(preArr)
		} else {
			return AnyRandomAccessCollection([])
		}
	}
	
	/// Copies a range of string indices.
	/// - parameter range:
	/// The range of string indices to be copied, with the entire range
	/// having a location of `0` and a length of `CTRun.glyphCount`. If the
	/// length of the range is set to `0`, then the operation will continue
	/// from the range's start index to the end of the run.
	/// - returns: The string indices in the specified range.
	///
	/// The indices are the character indices that originally spawned the
	/// glyphs that make up the run. They can be used to map the glyphs
	/// in the run back to the characters in the backing store.
	func stringIndicies(in range: CFRange) -> [CFIndex] {
		guard range.length != 0 else {
			return Array(stringIndices)
		}
		var preArr = [CFIndex](repeating: 0, count: range.length)
		CTRunGetStringIndices(self, range, &preArr)
		return preArr
	}
	
	/// Gets the range of characters that originally spawned the glyphs
	/// in the run.
	///
	/// Returns the range of characters that originally spawned the
	/// glyphs. If run is invalid, this will return an empty range.
	@inlinable var stringRange: CFRange {
		return CTRunGetStringRange(self)
	}
	
	/// Gets the typographic bounds of the run.
	/// - parameter range:
	/// The range of glyphs to be measured, with the entire range having
	/// a location of `0` and a length of `CTRun.glyphCount`. If the length
	/// of the range is set to `0`, then the operation will continue from
	/// the range's start index to the end of the run.
	func typographicBounds(in range: CFRange) -> (width: Double, ascent: CGFloat, descent: CGFloat, leading: CGFloat) {
		var ascent: CGFloat = 0, descent: CGFloat = 0, leading: CGFloat = 0
		let width = CTRunGetTypographicBounds(self, range, &ascent, &descent, &leading)
		return (width, ascent, descent, leading)
	}
	
	/// Calculates the image bounds for a glyph range.
	/// - parameter context:
	/// The context which the image bounds will be calculated for or `nil`,
	/// in which case the bounds are relative to `CGPoint.zero`.
	/// - parameter range: The range of glyphs to be measured, with the
	/// entire range having a location of `0` and a length of
	/// `CTRun.glyphCount`. If the length of the range is set to `0`,
	/// then the operation will continue from the range's start index to
	/// the end of the run.
	/// - returns: A rect that tightly encloses the paths of the run's glyphs. The
	/// rect origin will match the drawn position of the requested range;
	/// that is, it will be translated by the supplied context's text
	/// position and the positions of the individual glyphs. If the run
	/// or range is invalid, `nil` will be returned.
	///
	/// The image bounds for a run is the union of all non-empty glyph
	/// bounding rects, each positioned as it would be if drawn using
	/// `CTRunDraw` using the current context (for clients linked against
	/// macOS High Sierra or iOS 11 and later) or the text position of
	/// the supplied context (for all others). Note that the result is
	/// ideal and does not account for raster coverage due to rendering.
	/// This function is purely a convenience for using glyphs as an
	/// image and should not be used for typographic purposes.
	func imageBounds(in range: CFRange, context: CGContext?) -> CGRect? {
		let toRet = CTRunGetImageBounds(self, context, range)
		if toRet.isNull {
			return nil
		}
		return toRet
	}
	
	/// The text matrix needed to draw this run.
	///
	/// To properly draw the glyphs in a run, the fields *'tx'* and *'ty'* of
	/// the `CGAffineTransform` returned by this function should be set to
	/// the current text position.
	@inlinable var textMatrix: CGAffineTransform {
		return CTRunGetTextMatrix(self)
	}
	
	/// Draws a complete run or part of one.
	/// - parameter context: The context to draw the run to.
	/// - parameter range:
	/// The range of glyphs to be drawn, with the entire range having a
	/// location of `0` and a length of `CTRun.glyphCount`. If the length
	/// of the range is set to `0`, then the operation will continue from
	/// the range's start index to the end of the run.
	///
	/// This is a convenience call, since the run could also be drawn by
	/// accessing its glyphs, positions, and text matrix. Unlike when
	/// drawing the entire line containing the run with `CTLineDraw`, the
	/// run's underline (if any) will not be drawn, since the underline's
	/// appearance may depend on other runs in the line. This call may
	/// leave the graphics context in any state and does not flush the
	/// context after drawing. This call also expects a text matrix with
	/// *'y'* values increasing from bottom to top; a flipped text matrix
	/// may result in misplaced diacritics.
	@inlinable func draw(in context: CGContext, range: CFRange) {
		CTRunDraw(self, context, range)
	}
}

// MARK: NSRange additions
public extension CTRun {
	/// Copies a range of glyphs.
	/// - parameter range:
	/// The range of glyphs to be copied, with the entire range having a
	/// location of `0` and a length of `CTRun.glyphCount`. If the length
	/// of the range is set to `0`, then the operation will continue from
	/// the range's start index to the end of the run.
	/// - returns: The glyphs in the specified range.
	func glyphs(in range: NSRange) -> [CGGlyph] {
		return glyphs(in: range.cfRange)
	}
	
	/// Copies a range of glyphs.
	/// - parameter range:
	/// The range of glyphs to be copied, with the entire range having a
	/// location of `0` and a length of `CTRun.glyphCount`. If the length
	/// of the range is set to `0`, then the operation will continue from
	/// the range's start index to the end of the run.
	/// - returns: The glyphs in the specified range.
	func glyphs(in range: Range<Int>) -> [CGGlyph] {
		return glyphs(in: NSRange(range).cfRange)
	}

	
	/// Gets the typographic bounds of the run.
	/// - parameter range:
	/// The range of glyphs to be measured, with the entire range having
	/// a location of `0` and a length of `CTRun.glyphCount`. If the length
	/// of the range is set to `0`, then the operation will continue from
	/// the range's start index to the end of the run.
	func typographicBounds(in range: NSRange) -> (width: Double, ascent: CGFloat, descent: CGFloat, leading: CGFloat) {
		return typographicBounds(in: range.cfRange)
	}

	/// Gets the typographic bounds of the run.
	/// - parameter range:
	/// The range of glyphs to be measured, with the entire range having
	/// a location of `0` and a length of `CTRun.glyphCount`. If the length
	/// of the range is set to `0`, then the operation will continue from
	/// the range's start index to the end of the run.
	func typographicBounds(in range: Range<Int>) -> (width: Double, ascent: CGFloat, descent: CGFloat, leading: CGFloat) {
		return typographicBounds(in: NSRange(range).cfRange)
	}

	/// Copies a range of string indices.
	/// - parameter range:
	/// The range of string indices to be copied, with the entire range
	/// having a location of `0` and a length of `CTRun.glyphCount`. If the
	/// length of the range is set to `0`, then the operation will continue
	/// from the range's start index to the end of the run.
	/// - returns: The string indices in the specified range.
	///
	/// The indices are the character indices that originally spawned the
	/// glyphs that make up the run. They can be used to map the glyphs
	/// in the run back to the characters in the backing store.
	func stringIndicies(in range: NSRange) -> [CFIndex] {
		return stringIndicies(in: range.cfRange)
	}
	
	/// Copies a range of string indices.
	/// - parameter range:
	/// The range of string indices to be copied, with the entire range
	/// having a location of `0` and a length of `CTRun.glyphCount`. If the
	/// length of the range is set to `0`, then the operation will continue
	/// from the range's start index to the end of the run.
	/// - returns: The string indices in the specified range.
	///
	/// The indices are the character indices that originally spawned the
	/// glyphs that make up the run. They can be used to map the glyphs
	/// in the run back to the characters in the backing store.
	func stringIndicies(in range: Range<Int>) -> [CFIndex] {
		return stringIndicies(in: NSRange(range).cfRange)
	}
	
	/// Copies a range of glyph advances.
	/// - parameter range:
	/// The range of glyph advances to be copied, with the entire range
	/// having a location of 0 and a length of CTRunGetGlyphCount. If the
	/// length of the range is set to 0, then the operation will continue
	/// from the range's start index to the end of the run.
	/// - returns: An array of glyph advances.
	func advances(in range: NSRange) -> [CGSize] {
		return advances(in: range.cfRange)
	}
	
	/// Copies a range of glyph advances.
	/// - parameter range:
	/// The range of glyph advances to be copied, with the entire range
	/// having a location of 0 and a length of CTRunGetGlyphCount. If the
	/// length of the range is set to 0, then the operation will continue
	/// from the range's start index to the end of the run.
	/// - returns: An array of glyph advances.
	func advances(in range: Range<Int>) -> [CGSize] {
		return advances(in: NSRange(range).cfRange)
	}
	
	/// Copies a range of glyph positions.
	/// - parameter range:
	/// The range of glyph positions to be copied, with the entire range
	/// having a location of `0` and a length of `CTRun.glyphCount`. If the
	/// length of the range is set to `0`, then the operation will continue
	/// from the range's start index to the end of the run.
	/// - returns: The glyph positions.
	func positions(in range: NSRange) -> [CGPoint] {
		return positions(in: range.cfRange)
	}
	
	/// Copies a range of glyph positions.
	/// - parameter range:
	/// The range of glyph positions to be copied, with the entire range
	/// having a location of `0` and a length of `CTRun.glyphCount`. If the
	/// length of the range is set to `0`, then the operation will continue
	/// from the range's start index to the end of the run.
	/// - returns: The glyph positions.
	func positions(in range: Range<Int>) -> [CGPoint] {
		return positions(in: NSRange(range).cfRange)
	}
}
