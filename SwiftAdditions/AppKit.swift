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
	public var kCGBaseWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.baseWindow)
	}
	
	public var kCGMinimumWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.minimumWindow)
	}

	public var kCGDesktopWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.desktopWindow)
	}
	
	public var kCGBackstopMenuLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.backstopMenu)
	}
	
	public var kCGNormalWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.normalWindow)
	}
	
	public var kCGFloatingWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.floatingWindow)
	}
	
	public var kCGTornOffMenuWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.tornOffMenuWindow)
	}
	
	public var kCGDockWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.dockWindow)
	}
	
	public var kCGMainMenuWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.mainMenuWindow)
	}
	
	public var kCGStatusWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.statusWindow)
	}
	
	public var kCGModalPanelWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.modalPanelWindow)
	}
	
	public var kCGPopUpMenuWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.popUpMenuWindow)
	}
	
	public var kCGDraggingWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.draggingWindow)
	}
	
	public var kCGScreenSaverWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.screenSaverWindow)
	}
	
	public var kCGMaximumWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.maximumWindow)
	}
	
	public var kCGOverlayWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.overlayWindow)
	}
	
	public var kCGHelpWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.helpWindow)
	}
	
	public var kCGUtilityWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.utilityWindow)
	}
	
	public var kCGDesktopIconWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.desktopIconWindow)
	}
	
	public var kCGCursorWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.cursorWindow)
	}
	
	public var kCGAssistiveTechHighWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(CGWindowLevelKey.assistiveTechHighWindow)
	}

	extension AffineTransform {
		@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, message: "Use `AffineTransform(cgTransform:)` instead", renamed: "AffineTransform(cgTransform:)")
		public init(CGTransform cgAff: CGAffineTransform) {
			self.init(cgTransform: cgAff)
		}
		
		public init(cgTransform cgAff: CGAffineTransform) {
			self.init(m11: cgAff.a, m12: cgAff.b, m21: cgAff.c, m22: cgAff.d, tX: cgAff.tx, tY: cgAff.ty)
		}
		
		public var cgTransform: CGAffineTransform {
			return CGAffineTransform(a: m11, b: m12, c: m21, d: m22, tx: tX, ty: tY)
		}
	}
	
	extension NSAffineTransform {
		@available(swift, introduced: 2.0, deprecated: 4.0, obsoleted: 5.0, message: "Use `NSAffineTransform(cgTransform:)` instead", renamed: "NSAffineTransform(cgTransform:)")
		public convenience init(CGTransform cgTransform: CGAffineTransform) {
			let preStruct = AffineTransform(cgTransform: cgTransform)
			self.init()
			transformStruct = (preStruct as NSAffineTransform).transformStruct
		}
		
		public convenience init(cgTransform: CGAffineTransform) {
			let preStruct = AffineTransform(cgTransform: cgTransform)
			self.init()
			transformStruct = (preStruct as NSAffineTransform).transformStruct
		}
	}
	
	extension NSBitmapImageRep {
		/// Returns an array of all available compression types that can be used when writing a TIFF image.
		public class var tiffCompressionTypes: [NSBitmapImageRep.TIFFCompression] {
			var compPtr: UnsafePointer<NSBitmapImageRep.TIFFCompression>? = nil
			var count = 0
			getTIFFCompressionTypes(&compPtr, count: &count)
			
			let bufPtr = UnsafeBufferPointer(start: compPtr!, count: count)
			return Array(bufPtr)
		}
	}
	
	extension NSBitmapImageRep.Format {
		/// The native 32-bit byte order format.
		static var thirtyTwoBitNativeEndian: NSBitmapImageRep.Format {
			#if _endian(little)
				return .thirtyTwoBitLittleEndian
			#elseif _endian(big)
				return .thirtyTwoBitBigEndian
			#else
				fatalError("Unknown endianness")
			#endif
		}
		
		/// The native 16-bit byte order format.
		static var sixteenBitNativeEndian: NSBitmapImageRep.Format {
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
