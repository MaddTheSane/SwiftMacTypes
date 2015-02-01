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
		return CGWindowLevelForKey(Int32(kCGBaseWindowLevelKey))
	}
	
	public var kCGMinimumWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(Int32(kCGMinimumWindowLevelKey))
	}

	public var kCGDesktopWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(Int32(kCGDesktopWindowLevelKey))
	}

	public var kCGBackstopMenuLevel: CGWindowLevel {
		return CGWindowLevelForKey(Int32(kCGBackstopMenuLevelKey))
	}
	
	public var kCGNormalWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(Int32(kCGNormalWindowLevelKey))
	}
	
	public var kCGFloatingWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(Int32(kCGFloatingWindowLevelKey))
	}

	public var kCGTornOffMenuWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(Int32(kCGTornOffMenuWindowLevelKey))
	}

	public var kCGDockWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(Int32(kCGDockWindowLevelKey))
	}

	public var kCGMainMenuWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(Int32(kCGMainMenuWindowLevelKey))
	}

	public var kCGStatusWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(Int32(kCGStatusWindowLevelKey))
	}

	public var kCGModalPanelWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(Int32(kCGModalPanelWindowLevelKey))
	}

	public var kCGPopUpMenuWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(Int32(kCGPopUpMenuWindowLevelKey))
	}
	
	public var kCGDraggingWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(Int32(kCGDraggingWindowLevelKey))
	}
	
	public var kCGScreenSaverWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(Int32(kCGScreenSaverWindowLevelKey))
	}
	
	public var kCGMaximumWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(Int32(kCGMaximumWindowLevelKey))
	}
	
	public var kCGOverlayWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(Int32(kCGOverlayWindowLevelKey))
	}
	
	public var kCGHelpWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(Int32(kCGHelpWindowLevelKey))
	}

	public var kCGUtilityWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(Int32(kCGUtilityWindowLevelKey))
	}
	
	public var kCGDesktopIconWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(Int32(kCGDesktopIconWindowLevelKey))
	}
	
	public var kCGCursorWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(Int32(kCGCursorWindowLevelKey))
	}
	
	public var kCGAssistiveTechHighWindowLevel: CGWindowLevel {
		return CGWindowLevelForKey(Int32(kCGAssistiveTechHighWindowLevelKey))
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


#endif
