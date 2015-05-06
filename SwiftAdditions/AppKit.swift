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
		CGWindowLevelForKey(Int32(kCGBaseWindowLevelKey))
	
	public let kCGMinimumWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(Int32(kCGMinimumWindowLevelKey))

	public let kCGDesktopWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(Int32(kCGDesktopWindowLevelKey))
	
	public let kCGBackstopMenuLevel: CGWindowLevel =
		CGWindowLevelForKey(Int32(kCGBackstopMenuLevelKey))
	
	public let kCGNormalWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(Int32(kCGNormalWindowLevelKey))
	
	public let kCGFloatingWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(Int32(kCGFloatingWindowLevelKey))

	public let kCGTornOffMenuWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(Int32(kCGTornOffMenuWindowLevelKey))

	public let kCGDockWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(Int32(kCGDockWindowLevelKey))

	public let kCGMainMenuWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(Int32(kCGMainMenuWindowLevelKey))

	public let kCGStatusWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(Int32(kCGStatusWindowLevelKey))

	public let kCGModalPanelWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(Int32(kCGModalPanelWindowLevelKey))

	public let kCGPopUpMenuWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(Int32(kCGPopUpMenuWindowLevelKey))
	
	public let kCGDraggingWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(Int32(kCGDraggingWindowLevelKey))
	
	public let kCGScreenSaverWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(Int32(kCGScreenSaverWindowLevelKey))
	
	public let kCGMaximumWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(Int32(kCGMaximumWindowLevelKey))
	
	public let kCGOverlayWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(Int32(kCGOverlayWindowLevelKey))
	
	public let kCGHelpWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(Int32(kCGHelpWindowLevelKey))

	public let kCGUtilityWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(Int32(kCGUtilityWindowLevelKey))
	
	public var kCGDesktopIconWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(Int32(kCGDesktopIconWindowLevelKey))
	
	public let kCGCursorWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(Int32(kCGCursorWindowLevelKey))
	
	public let kCGAssistiveTechHighWindowLevel: CGWindowLevel =
		CGWindowLevelForKey(Int32(kCGAssistiveTechHighWindowLevelKey))
	
	
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

#endif
