//
//  AppKit.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 2/1/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

#if os(OSX)
import Cocoa

	// MARK: CGWindowLevel values
	@inlinable public var kCGBaseWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.baseWindow)
	}
	
	@inlinable public var kCGMinimumWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.minimumWindow)
	}

	@inlinable public var kCGDesktopWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.desktopWindow)
	}
	
	@inlinable public var kCGMaximumWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.maximumWindow)
	}
	
	@inlinable public var kCGDesktopIconWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.desktopIconWindow)
	}
	
	@inlinable public var kCGCursorWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.cursorWindow)
	}
	
	public extension AffineTransform {
		init(cgTransform cgAff: CGAffineTransform) {
			self.init(m11: cgAff.a, m12: cgAff.b, m21: cgAff.c, m22: cgAff.d, tX: cgAff.tx, tY: cgAff.ty)
		}
		
		var cgTransform: CGAffineTransform {
			return CGAffineTransform(a: m11, b: m12, c: m21, d: m22, tx: tX, ty: tY)
		}
	}
	
	public extension NSAffineTransform {
		convenience init(cgTransform: CGAffineTransform) {
			let preStruct = AffineTransform(cgTransform: cgTransform)
			self.init()
			transformStruct = (preStruct as NSAffineTransform).transformStruct
		}
	}
	
	public extension NSBitmapImageRep {
		/// Returns an array of all available compression types that can be used when writing
		/// a TIFF image.
		///
		/// This is an `UnsafeBufferPointer` C array of `NSBitmapImageRep.TIFFCompression` constants.
		/// This array belongs to the `NSBitmapImageRep` class; it shouldn’t be freed or
		/// altered. See `NSBitmapImageRep.TIFFCompression` for the supported TIFF
		/// compression types.
		///
		/// Note that not all compression types can be used for all images:
		/// `NSBitmapImageRep.TIFFCompression.next` can be used only to retrieve image data.
		/// Because future releases may include other compression types, always use this
		/// method to get the available compression types—for example, when you implement a
		/// user interface for selecting compression types.
		static var tiffCompressionTypes: UnsafeBufferPointer<NSBitmapImageRep.TIFFCompression> {
			var compPtr: UnsafePointer<NSBitmapImageRep.TIFFCompression>? = nil
			var count = 0
			getTIFFCompressionTypes(&compPtr, count: &count)
			
			let bufPtr = UnsafeBufferPointer(start: compPtr, count: count)
			return bufPtr
		}
	}
	
	public extension NSBitmapImageRep.Format {
		/// The native 32-bit byte order format.
		@inlinable static var thirtyTwoBitNativeEndian: NSBitmapImageRep.Format {
			#if _endian(little)
				return .thirtyTwoBitLittleEndian
			#elseif _endian(big)
				return .thirtyTwoBitBigEndian
			#else
				fatalError("Unknown endianness")
			#endif
		}
		
		/// The native 16-bit byte order format.
		@inlinable static var sixteenBitNativeEndian: NSBitmapImageRep.Format {
			#if _endian(little)
				return .sixteenBitLittleEndian
			#elseif _endian(big)
				return .sixteenBitBigEndian
			#else
				fatalError("Unknown endianness")
			#endif
		}
	}

#endif
