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


	// MARK: NSWindowLevel values
	
	public var NSNormalWindowLevel: Int {
		return Int(kCGNormalWindowLevel)
	}
	public var NSFloatingWindowLevel: Int {
		return Int(kCGFloatingWindowLevel)
	}
	public var NSSubmenuWindowLevel: Int {
		return Int(kCGTornOffMenuWindowLevel)
	}
	public var NSTornOffMenuWindowLevel: Int {
		return Int(kCGTornOffMenuWindowLevel)
	}
	public var NSMainMenuWindowLevel: Int {
		return Int(kCGMainMenuWindowLevel)
	}
	public var NSStatusWindowLevel: Int {
		return Int(kCGStatusWindowLevel)
	}
	public var NSModalPanelWindowLevel: Int {
		return Int(kCGModalPanelWindowLevel)
	}
	public var NSPopUpMenuWindowLevel: Int {
		return Int(kCGPopUpMenuWindowLevel)
	}
	public var NSScreenSaverWindowLevel: Int {
		return Int(kCGScreenSaverWindowLevel)
	}

	extension AffineTransform {
		public init(CGTransform cgAff: CGAffineTransform) {
			m11 = cgAff.a
			m12 = cgAff.b
			m21 = cgAff.c
			m22 = cgAff.d
			tX = cgAff.tx
			tY = cgAff.ty
		}
	}
	
	extension NSAffineTransform {
		public convenience init(CGTransform cgTransform: CGAffineTransform) {
			let preStruct = AffineTransform(CGTransform: cgTransform)
			self.init()
			transformStruct = preStruct
		}
	}
	
#endif
