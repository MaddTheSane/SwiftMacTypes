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
	public let kCGBaseWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.baseWindow)
	
	public let kCGMinimumWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.minimumWindow)

	public let kCGDesktopWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.desktopWindow)
	
	public let kCGBackstopMenuLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.backstopMenu)
	
	public let kCGNormalWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.normalWindow)
	
	public let kCGFloatingWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.floatingWindow)

	public let kCGTornOffMenuWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.tornOffMenuWindow)

	public let kCGDockWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.dockWindow)

	public let kCGMainMenuWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.mainMenuWindow)

	public let kCGStatusWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.statusWindow)

	public let kCGModalPanelWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.modalPanelWindow)

	public let kCGPopUpMenuWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.popUpMenuWindow)
	
	public let kCGDraggingWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.draggingWindow)
	
	public let kCGScreenSaverWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.screenSaverWindow)
	
	public let kCGMaximumWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.maximumWindow)
	
	public let kCGOverlayWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.overlayWindow)
	
	public let kCGHelpWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.helpWindow)

	public let kCGUtilityWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.utilityWindow)
	
	public let kCGDesktopIconWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.desktopIconWindow)
	
	public let kCGCursorWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.cursorWindow)
	
	public let kCGAssistiveTechHighWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.assistiveTechHighWindow)
	
	
	// MARK: NSWindowLevel values
	
	public let NSNormalWindowLevel = Int(kCGNormalWindowLevel)
	public let NSFloatingWindowLevel = Int(kCGFloatingWindowLevel)
	public let NSSubmenuWindowLevel = Int(kCGTornOffMenuWindowLevel)
	public let NSTornOffMenuWindowLevel = Int(kCGTornOffMenuWindowLevel)
	public let NSMainMenuWindowLevel = Int(kCGMainMenuWindowLevel)
	public let NSStatusWindowLevel = Int(kCGStatusWindowLevel)
	public let NSModalPanelWindowLevel = Int(kCGModalPanelWindowLevel)
	public let NSPopUpMenuWindowLevel = Int(kCGPopUpMenuWindowLevel)
	public let NSScreenSaverWindowLevel = Int(kCGScreenSaverWindowLevel)

	extension NSAffineTransformStruct {
		private init(_ cgAff: CGAffineTransform) {
			m11 = cgAff.a
			m12 = cgAff.b
			m21 = cgAff.c
			m22 = cgAff.d
			tX = cgAff.tx
			tY = cgAff.ty
		}
	}
	
	extension NSAffineTransform {
		public convenience init(cgTransform: CGAffineTransform) {
			let preStruct = NSAffineTransformStruct(cgTransform)
			self.init()
			transformStruct = preStruct
		}
	}
	
#endif
