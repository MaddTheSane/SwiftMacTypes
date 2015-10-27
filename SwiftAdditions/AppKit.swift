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
		CGWindowLevelForKey(CGWindowLevelKey.BaseWindowLevelKey)
	
	public let kCGMinimumWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.MinimumWindowLevelKey)

	public let kCGDesktopWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.DesktopWindowLevelKey)
	
	public let kCGBackstopMenuLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.BackstopMenuLevelKey)
	
	public let kCGNormalWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.NormalWindowLevelKey)
	
	public let kCGFloatingWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.FloatingWindowLevelKey)

	public let kCGTornOffMenuWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.TornOffMenuWindowLevelKey)

	public let kCGDockWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.DockWindowLevelKey)

	public let kCGMainMenuWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.MainMenuWindowLevelKey)

	public let kCGStatusWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.StatusWindowLevelKey)

	public let kCGModalPanelWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.ModalPanelWindowLevelKey)

	public let kCGPopUpMenuWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.PopUpMenuWindowLevelKey)
	
	public let kCGDraggingWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.DraggingWindowLevelKey)
	
	public let kCGScreenSaverWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.ScreenSaverWindowLevelKey)
	
	public let kCGMaximumWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.MaximumWindowLevelKey)
	
	public let kCGOverlayWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.OverlayWindowLevelKey)
	
	public let kCGHelpWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.HelpWindowLevelKey)

	public let kCGUtilityWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.UtilityWindowLevelKey)
	
	public let kCGDesktopIconWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.DesktopIconWindowLevelKey)
	
	public let kCGCursorWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.CursorWindowLevelKey)
	
	public let kCGAssistiveTechHighWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(CGWindowLevelKey.AssistiveTechHighWindowLevelKey)
	
	
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
