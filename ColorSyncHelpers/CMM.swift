//
//  CMM.swift
//  ColorSyncHelpers
//
//  Created by C.W. Betts on 2/14/16.
//  Copyright © 2016 C.W. Betts. All rights reserved.
//

import Foundation
@preconcurrency import ColorSync

private func cmmIterator(_ cmm: ColorSyncCMM?, userInfo: UnsafeMutableRawPointer?) -> Bool {
	guard let userInfo = userInfo, let cmm = cmm else {
		return false
	}
	let array = Unmanaged<NSMutableArray>.fromOpaque(userInfo).takeUnretainedValue()
	
	array.add(CSCMM(cmm: cmm))
	
	return true
}

public final class CSCMM: CustomStringConvertible, CustomDebugStringConvertible {
	let cmmInt: ColorSyncCMM
	
	/// The system-supplied CMM
	public static var appleCMM: CSCMM {
		let cmms = installedCMMs
		for cmm in cmms {
			if cmm.bundle == nil {
				return cmm
			}
		}
		return cmms.first!
	}
	
	/// Returns all of the available CMMs.
	public static var installedCMMs: [CSCMM] {
		let cmms = NSMutableArray()
		
		ColorSyncIterateInstalledCMMs({ cmm, userInfo in
			guard let userInfo = userInfo, let cmm = cmm else {
				return false
			}
			let array = Unmanaged<NSMutableArray>.fromOpaque(userInfo).takeUnretainedValue()
			
			array.add(CSCMM(cmm: cmm))
			
			return true
		}, UnsafeMutableRawPointer(Unmanaged.passUnretained(cmms).toOpaque()))
		
		return cmms as! [CSCMM]
	}
	
	fileprivate init(cmm: ColorSyncCMM) {
		cmmInt = cmm
	}
	
	/// Creates a CSCMM object from the supplied bundle.
	public convenience init?(bundle: Bundle) {
		if let newBund = CFBundleCreate(kCFAllocatorDefault, bundle.bundleURL as NSURL) {
			self.init(bundle: newBund)
		} else {
			return nil
		}
	}
	
	/// Creates a CSCMM object from the supplied bundle.
	public convenience init?(bundle: CFBundle) {
		guard let newCmm = ColorSyncCMMCreate(bundle)?.takeRetainedValue() else {
			return nil
		}
		self.init(cmm: newCmm)
	}
	
	/// Will return `nil` for Apple's built-in CMM
	public var bundle: Bundle? {
		if let cfBundle = ColorSyncCMMGetBundle(cmmInt)?.takeUnretainedValue() {
			let aURL = CFBundleCopyBundleURL(cfBundle) as URL
			return Bundle(url: aURL)!
		}
		return nil
	}
	
	/// Returns the localized name of the ColorSync module
	public var localizedName: String {
		return ColorSyncCMMCopyLocalizedName(cmmInt)!.takeRetainedValue() as String
	}
	
	/// Returns the identifier of the ColorSync module
	public var identifier: String {
		return ColorSyncCMMCopyCMMIdentifier(cmmInt)!.takeRetainedValue() as String
	}
	
	public var description: String {
		return "\(identifier), \"\(localizedName)\""
	}
	
	public var debugDescription: String {
		return CFCopyDescription(cmmInt) as String
	}
}
