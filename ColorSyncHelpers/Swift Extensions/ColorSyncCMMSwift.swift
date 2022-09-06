//
//  ColorSyncCMMSwift.swift
//  ColorSyncHelpers
//
//  Created by C.W. Betts on 9/19/18.
//  Copyright © 2018 C.W. Betts. All rights reserved.
//

import Foundation
import ApplicationServices

public extension ColorSyncCMM {
	/// The type identifier of all `ColorSyncCMM` instances.
	@inlinable static var typeID: CFTypeID {
		return ColorSyncCMMGetTypeID()
	}

	/// Will return `nil` for Apple's built-in CMM
	@inlinable var bundle: Bundle? {
		if let cfBundle = ColorSyncCMMGetBundle(self)?.takeUnretainedValue() {
			let aURL = CFBundleCopyBundleURL(cfBundle) as URL
			return Bundle(url: aURL)!
		}
		return nil
	}
	
	/// Returns the localized name of the ColorSync module
	@inlinable var localizedName: String {
		return ColorSyncCMMCopyLocalizedName(self)!.takeRetainedValue() as String
	}
	
	/// Returns the identifier of the ColorSync module
	@inlinable var identifier: String {
		return ColorSyncCMMCopyCMMIdentifier(self)!.takeRetainedValue() as String
	}
}
