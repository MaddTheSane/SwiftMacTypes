//
//  KextManager.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 12/28/24.
//  Copyright © 2024 C.W. Betts. All rights reserved.
//

import Foundation
import IOKit.kext

/// Namespace for Kext Manager functions
public enum KextManager {
	/// Create a URL locating a kext with a given bundle identifier.
	/// - parameter ident: The bundle identifier to look up.
	/// - returns: A `URL` locating a kext with the requested bundle identifier. Returns `nil` if the kext cannot be found, or on error.
	///
	/// Kexts are looked up first by whether they are loaded, second by version. Specifically, if `ident` identifies a kext
	/// that is currently loaded, the returned URL will locate that kext if it’s still present on disk. If the requested kext is not
	/// loaded, or if its bundle is not at the location it was originally loaded from, the returned URL will locate the latest version
	/// of the desired kext, if one can be found within the system extensions folder. If no version of the kext can be found,
	/// `nil` is returned.
	@inlinable public static func URLForBundleIdentifier(_ ident: String) -> URL? {
		return KextManagerCreateURLForBundleIdentifier(kCFAllocatorDefault, ident as NSString).takeRetainedValue() as URL
	}
	
	/// Request the kext loading system to load a kext with a given bundle identifier.
	/// - parameter kextIdentifier: The bundle identifier of the kext to look up and load.
	/// - parameter dependencies: An array of additional URLs, of individual kexts and of folders that may contain kexts.
	/// - returns: `kOSReturnSuccess` if the kext is successfully loaded (or is already loaded), otherwise returns on error.
	///
	/// `kextIdentifier` is looked up in the system extensions folder and among any kexts from
	/// `dependencies`. Any non-kext URLs in `dependencies` are scanned at the top level for kexts and plugins of kexts.
	///
	/// Either the calling process must have an effective user id of 0 (superuser), or the kext being loaded and all its dependencies
	/// must reside in */System* and have an *OSBundleAllowUserLoad* property of `true`.
	@inlinable public static func loadKextWithIdentifier(_ kextIdentifier: String, dependencies: [URL]) -> OSReturn {
		return KextManagerLoadKextWithIdentifier(kextIdentifier as NSString, dependencies as NSArray)
	}
	
	/// Request the kext loading system to load a kext with a given URL.
	/// - parameter kextURL: The URL of the kext to load.
	/// - parameter dependencies: An array of additional URLs, of individual kexts and of folders that may contain kexts.
	/// - returns: `kOSReturnSuccess` if the kext is successfully loaded (or is already loaded), otherwise returns on error.
	///
	/// Any non-kext URLs in `dependencies` are scanned at the top level for kexts and plugins of kexts.
	///
	/// Either the calling process must have an effective user id of 0 (superuser), or the kext being loaded and all
	/// its dependencies must reside in /System and have an *OSBundleAllowUserLoad* property of `true`.
	@inlinable public static func loadKext(with kextURL: URL, dependencies: [URL]) -> OSReturn {
		return KextManagerLoadKextWithURL(kextURL as NSURL, dependencies as NSArray)
	}
	
	/// Request the kernel to unload a kext with a given bundle identifier.
	/// - parameter identifier: The bundle identifier of the kext to unload.
	/// - returns: `kOSReturnSuccess` if the kext is found and successfully unloaded, otherwise returns on error.
	/// See */usr/include/libkern/OSKextLib.h* for error codes.
	///
	/// The calling process must have an effective user id of 0 (superuser).
	@inlinable public static func unloadKext(with identifier: CFString) -> OSReturn {
		return KextManagerUnloadKextWithIdentifier(identifier as CFString)
	}
	
	/// Returns information about loaded kexts in a dictionary.
	/// - parameter identifiers: An array of kext identifiers to read from the kernel. Pass `nil` to read info for all loaded kexts.
	/// - parameter infoKeys: An array of info keys to read from the kernel. Pass `nil` to read all information.
	/// - returns: A dictionary, keyed by bundle identifier, of dictionaries containing information about loaded kexts.
	///
	/// The information keys returned by this function are listed below. Some are taken directly from the kext’s information
	/// property list, and some are generated at run time. Never assume a given key will be present for a kext.
	/// * `CFBundleIdentifier` - CFString
	/// * `CFBundleVersion` - CFString (note: version strings may be canonicalized
	/// but their numeric values will be the same; "1.2.0" may become "1.2", for example)
	/// * `OSBundleCompatibleVersion` - CFString
	/// * `OSBundleIsInterface` - CFBoolean
	/// * `OSKernelResource` - CFBoolean
	/// * `OSBundleCPUType` - CFNumber
	/// * `OSBundleCPUSubtype` - CFNumber
	/// * `OSBundlePath` - CFString (this is merely a hint stored in the kernel;
	/// the kext is not guaranteed to be at this path)
	/// * `OSBundleExecutablePath` - CFString
	/// (the absolute path to the executable within the kext bundle; a hint as above)
	/// * `OSBundleUUID` - CFData (the UUID of the kext executable, if it has one)
	/// * `OSBundleStarted` - CFBoolean (true if the kext is running)
	/// * `OSBundlePrelinked` - CFBoolean (true if the kext is loaded from a prelinked kernel)
	/// * `OSBundleLoadTag` - CFNumber (the "Index" given by kextstat)
	/// * `OSBundleLoadAddress` - CFNumber
	/// * `OSBundleLoadSize` - CFNumber
	/// * `OSBundleWiredSize` - CFNumber
	/// * `OSBundleDependencies` - CFArray of load tags identifying immediate link dependencies
	/// * `OSBundleRetainCount` - CFNumber (the OSObject retain count of the kext itself)
	/// * `OSBundleClasses` - CFArray of CFDictionary containing info on C++ classes
	/// defined by the kext:
	/// * * `OSMetaClassName` - CFString
	/// * * `OSMetaClassSuperclassName` - CFString, absent for root classes
	/// * * `OSMetaClassTrackingCount` - CFNumber giving the instance count
	/// of the class itself, *plus* 1 for each direct subclass with any instances
	static public func loadedKextInfo(forIdentifiers identifiers: [String]?, infoKeys: [String]?) -> [String: [String: Any]]? {
		return KextManagerCopyLoadedKextInfo(identifiers as NSArray?, infoKeys as NSArray?)?.takeRetainedValue() as? [String: [String: Any]]
	}
}
