//
//  ColorSyncProfileClass.swift
//  ColorSyncHelpers
//
//  Created by C.W. Betts on 2/13/16.
//  Copyright © 2016 C.W. Betts. All rights reserved.
//

import Foundation
import ColorSync

func sanitize(options: [String: Any]?) -> [String: Any]? {
	guard var options = options else {
		return nil
	}
	
#if os(macOS)
	if let cmm = options[kColorSyncPreferredCMM.takeUnretainedValue() as String] as? CSCMM {
		options[kColorSyncPreferredCMM.takeUnretainedValue() as String] = cmm.cmmInt
	}
#endif
	
	return options
}

/// Makes sure we don't pass our own `CSProfile`, but the `ColorSyncProfileRef` the API expects.
func sanitize(profileInfo profileSequence: [[String: Any]]) -> [[String: Any]] {
	let colorSyncProfKey = kColorSyncProfile.takeUnretainedValue() as String
	// make sure we don't pass our own CSProfile, but the ColorSyncProfileRef the API expects
	let filtered = profileSequence.map { (TheDict) -> [String: Any] in
		var tmpDict: [String: Any] = TheDict
		if let csProfile = tmpDict[colorSyncProfKey] as? CSProfile {
			tmpDict[colorSyncProfKey] = csProfile.profile
		}
		return tmpDict
	}
	return filtered
}

//TODO: add dictionary generater
/// A class that references a ColorSync profile.
@available(macOS 10.4, tvOS 16.0, iOS 16.0, macCatalyst 16.0, *)
public class CSProfile: CustomStringConvertible, CustomDebugStringConvertible {
	/// Internal ColorSync profile reference that the class wraps around.
	public let profile: ColorSyncProfile
	
	/// Returns all of the installed profiles.
	public static func allProfiles() throws -> [CSProfile] {
		let profs = NSMutableArray()

		try iterateInstalledProfiles(using: { profileInfo, userInfo in
			// Callback routine with a description of a profile that is
			// called during an iteration through the available profiles.
			guard let profileInfo = profileInfo as? [String: Any], let userInfo = userInfo else {
				return false
			}
			let array = Unmanaged<NSMutableArray>.fromOpaque(userInfo).takeUnretainedValue()
			
			if let prof = CSProfile(iterateData: profileInfo) {
				array.add(prof)
			} else {
				print("Failed adding the following dictionary: \(profileInfo)")
			}
			
			return true

		}, userInfo: Unmanaged.passUnretained(profs).toOpaque())
		
		return profs as NSArray as! [CSProfile]
	}
	
	public static func iterateInstalledProfiles(using callback: @escaping ColorSyncProfileIterateCallback, userInfo: UnsafeMutableRawPointer? = nil, seed: UnsafeMutablePointer<UInt32>? = nil) throws {
		var errVal: Unmanaged<CFError>?
		
		ColorSyncIterateInstalledProfiles(callback, seed, userInfo, &errVal)
		
		if let errVal = errVal?.takeRetainedValue() {
			throw errVal
		}
	}

	public static func iterateInstalledProfiles(using block: @escaping ([String: Any]) -> Bool, seed: UnsafeMutablePointer<UInt32>? = nil) throws {
		let callback2 = block as AnyObject
		let callback3 = Unmanaged<AnyObject>.passUnretained(callback2)
		
		try iterateInstalledProfiles(using: { (aDict, rawPoint) -> Bool in
			let callback4 = Unmanaged<AnyObject>.fromOpaque(rawPoint!)
			let callback5 = callback4.takeUnretainedValue() as! ([String: Any]) -> Bool
			return callback5(aDict as! [String: Any])
		}, userInfo: callback3.toOpaque(), seed: seed)
	}
	
	convenience init?(iterateData: [String: Any]) {
		guard let mURL = iterateData[kColorSyncProfileURL.takeUnretainedValue() as String] as? URL else {
			return nil
		}
		do {
			try self.init(contentsOf: mURL)
		} catch _ {
			return nil
		}
	}
	
	fileprivate init(internalPtr: ColorSyncProfile) {
		profile = internalPtr
	}
	
	/// Creates a profile from ICC data.
	/// - parameter data: Profile data.
	public convenience init(data: Data) throws {
		var errVal: Unmanaged<CFError>?
		if let csVal = ColorSyncProfileCreate(data as NSData, &errVal)?.takeRetainedValue() {
			self.init(internalPtr: csVal)
		} else {
			guard let errStuff = errVal?.takeRetainedValue() else {
				throw CSError.unwrappingError
			}
			throw errStuff
		}
	}
	
	/// Creates a profile from a URL.
	public convenience init(contentsOf url: URL) throws {
		var errVal: Unmanaged<CFError>?
		if let csVal = ColorSyncProfileCreateWithURL(url as NSURL, &errVal)?.takeRetainedValue() {
			self.init(internalPtr: csVal)
		} else {
			guard let errStuff = errVal?.takeRetainedValue() else {
				throw CSError.unwrappingError
			}
			throw errStuff
		}
	}
	
	/// Creates a profile from a predefined name.
	/// - parameter name: predefined profile name
	public convenience init?(named name: String) {
		guard let retVal = ColorSyncProfileCreateWithName(name as NSString)?.takeRetainedValue() else {
			return nil
		}
		self.init(internalPtr: retVal)
	}
	
	/// Creates a linked CSProfile object.
	/// - parameter profileInfo: array of dictionaries, each one containing a profile object and the
	/// information on the usage of the profile in the transform.
	///
	///       Required keys:
	///       ==============
	///              kColorSyncProfile           : ColorSyncProfileRef or CSProfile
	///              kColorSyncRenderingIntent   : CFStringRef defining rendering intent
	///              kColorSyncTransformTag      : CFStringRef defining which tags to use
	///       Optional key:
	///       =============
	///            kColorSyncBlackPointCompensation : CFBooleanRef to enable/disable BPC
	///
	/// - parameter options: dictionary with additional public global options (e.g. 
	/// preferred CMM, quality, etc…) It can also contain custom options that are CMM specific.
	public convenience init?(profileInfo: [[String: Any]], options: [String: Any]? = nil) {
		guard let prof = ColorSyncProfileCreateLink(sanitize(profileInfo: profileInfo) as NSArray, sanitize(options: options) as NSDictionary?)?.takeRetainedValue() else {
			return nil
		}
		self.init(internalPtr: prof)
	}
	
#if os(macOS)
	/// Creates a CSProfile from a display ID.
	/// - parameter displayID: system-wide unique display ID (defined by IOKIt); pass `0` for main display.
	///
	/// - returns: ColorSyncProfileRef or `nil` in case of failure
	public convenience init?(displayID: UInt32) {
		guard let aRet = ColorSyncProfileCreateWithDisplayID(displayID)?.takeRetainedValue() else {
			return nil
		}
		self.init(internalPtr: aRet)
	}
	
	/// Creates a CSProfile from device info passed to it.
	/// - parameter deviceClass: ColorSync device class
	/// - parameter deviceID: deviceID registered with ColorSync
	/// - parameter profileID: profileID registered with ColorSync; pass `kColorSyncDeviceDefaultProfileID` (the default) to get the default profile.
	///
	/// See ColorSyncDevice.h for more info on `deviceClass`, `deviceID` and `profileID`
	public convenience init?(deviceClass: String, deviceID ID: CFUUID, profileID: AnyObject = kColorSyncDeviceDefaultProfileID.takeUnretainedValue()) {
		if let aRet = ColorSyncProfileCreateDeviceProfile(deviceClass as NSString, ID, profileID)?.takeRetainedValue() {
			self.init(internalPtr: aRet)
		}
		return nil
	}
#endif

	/// Creates a mutable copy of the current object
	public final func mutableCopy() -> CSMutableProfile {
		return CSMutableProfile(internalPtr: profile)
	}
	
	/// The data associated with the signature.
	/// - parameter tag: signature of the tag to be retrieved 
	public subscript (tag: String) -> Data? {
		get {
			if let data = ColorSyncProfileCopyTag(profile, tag as NSString)?.takeRetainedValue() {
				return data as Data
			}
			return nil
		}
	}
	
	/// Tests if the profiles has a specified tag.
	///
	/// - parameter signature: signature of the tag to be searched for
	///
	/// - returns: `true` if tag exists, or `false` if it does not.
	public final func containsTag(_ signature: String) -> Bool {
		return ColorSyncProfileContainsTag(profile, signature as NSString)
	}
	
	/// Returns MD5 digest for the profile calculated as defined by
	/// ICC specification, or `nil` in case of failure.
	public final var md5: ColorSyncMD5? {
		let toRet = ColorSyncProfileGetMD5(profile)
		var theMD5 = toRet
		return withUnsafePointer(to: &theMD5.digest) { (TheT) -> ColorSyncMD5? in
			let newErr = UnsafeRawPointer(TheT).assumingMemoryBound(to: UInt.self)
			let toCheck = UnsafeBufferPointer<UInt>(start: newErr, count: MemoryLayout<ColorSyncMD5>.size / MemoryLayout<UInt>.size)
			for i in toCheck {
				if i != 0 {
					return toRet
				}
			}
			return nil
		}
	}
	
	/// The URL of the profile, or `nil` on error.
	public final var url: URL? {
		return ColorSyncProfileGetURL(profile, nil)?.takeUnretainedValue() as URL?
	}
	
	/// `Data` containing the header data in host endianess.
	public var header: Data? {
		return ColorSyncProfileCopyHeader(profile)?.takeRetainedValue() as Data?
	}
	
#if os(macOS)
	/// Estimates the gamma of the profile.
	public final func estimateGamma() throws -> Float {
		var errVal: Unmanaged<CFError>?
		let aRet = ColorSyncProfileEstimateGamma(profile, &errVal)
		
		if aRet == 0.0 {
			guard let errStuff = errVal?.takeRetainedValue() else {
				throw CSError.unwrappingError
			}
			throw errStuff
		}
		return aRet
	}
#endif
	
	final public var description: String {
		return ColorSyncProfileCopyDescriptionString(profile)!.takeRetainedValue() as String
	}
	
	public var debugDescription: String {
		return CFCopyDescription(profile) as String
	}
	
	/// Array of signatures of tags in the profile
	public final var tagSignatures: [String] {
		return ColorSyncProfileCopyTagSignatures(profile)!.takeRetainedValue() as NSArray as! [String]
	}
	
	/// Return the flattened data.
	public final func rawData() throws -> Data {
		var errVal: Unmanaged<CFError>?
		guard let aDat = ColorSyncProfileCopyData(profile, &errVal)?.takeRetainedValue() else {
			guard let errStuff = errVal?.takeRetainedValue() else {
				throw CSError.unwrappingError
			}
			throw errStuff
		}
		return aDat as Data
	}
	
#if os(macOS)
	/// An utility function creating three tables of floats (redTable, greenTable, blueTable)
	/// each of size `samplesPerChannel`, packed into contiguous memory contained in the `Data`
	/// to be returned from the `vcgt` tag of the profile (if `vcgt` tag exists in the profile).
	public final func displayTransferTablesFromVCGT(_ samplesPerChannel: inout Int) -> Data? {
		return ColorSyncProfileCreateDisplayTransferTablesFromVCGT(profile, &samplesPerChannel)?.takeRetainedValue() as Data?
	}
	
	/// Installs the profile
	///
	/// - parameter domain: either `kColorSyncProfileComputerDomain` or `kColorSyncProfileUserDomain`.<br>
	///             `kColorSyncProfileComputerDomain` is for sharing the profiles (from `/Library/ColorSync/Profiles`).<br>
	///             `kColorSyncProfileUserDomain` is for user custom profiles (installed under home directory, i.e. in
	///             `~/Library/ColorSync/Profiles`.<br>
	/// Default is `kColorSyncProfileUserDomain`.
	/// - parameter subpath:	String created from the file system representation of the path of
	/// the file to contain the installed profile. The last component of the path is interpreted 
	/// as a file name if it ends with the extension ".icc". Otherwise, the subpath is interpreted
	/// as the directory path and file name will be created from the profile description tag, appended 
	/// with the ".icc" extension.
	/// - throws: on error.
	public final func install(domain: CFString = kColorSyncProfileUserDomain.takeUnretainedValue(), subpath: String? = nil) throws {
		var errVal: Unmanaged<CFError>?
		guard ColorSyncProfileInstall(profile, domain, subpath as NSString?, &errVal) else {
			guard let errStuff = errVal?.takeRetainedValue() else {
				throw CSError.unwrappingError
			}
			throw errStuff
		}
	}
	
	/// This profile must return a valid url for `URL`,
	/// i.e. it must be created with `init(contentsOfURL:)`. Also, the url
	/// must be in either in `kColorSyncProfileComputerDomain` or
	/// `kColorSyncProfileUserDomain`, including subfolders of those.
	public final func uninstall() throws {
		var errVal: Unmanaged<CFError>?
		guard ColorSyncProfileUninstall(profile, &errVal) else {
			guard let errStuff = errVal?.takeRetainedValue() else {
				throw CSError.unwrappingError
			}
			throw errStuff
		}
	}
	
	/// A utility function converting `vcgt` tag (if `vcgt` tag exists in the profile and 
	/// conversion possible) to formula components used by `CGSetDisplayTransferByFormula`.
	public final func displayTransferFormulaFromVCGT() -> (red: (min: Float, max: Float, gamma: Float), green: (min: Float, max: Float, gamma: Float), blue: (min: Float, max: Float, gamma: Float))? {
		typealias Component = (min: Float, max: Float, gamma: Float)
		var red = Component(0, 0, 0)
		var green = Component(0, 0, 0)
		var blue = Component(0, 0, 0)
		guard ColorSyncProfileGetDisplayTransferFormulaFromVCGT(profile, &red.min, &red.max, &red.gamma, &green.min, &green.max, &green.gamma, &blue.min, &blue.max, &blue.gamma) else {
			return nil
		}
		
		return (red, green, blue)
	}
#endif
	
	/// Verify the current profile.
	/// - throws: If the profile cannot be used.
	/// - returns: Warnings indicating problems due to lack of
	/// conformance with the ICC specification, but not preventing
	/// use of the profile.<br>
	/// Will be `nil` if there is no problems.
	public final func verify() throws -> Error? {
		var errors: Unmanaged<CFError>? = nil
		var warnings: Unmanaged<CFError>? = nil
		let usable = ColorSyncProfileVerify(profile, &errors, &warnings)
		
		guard usable else {
			guard let errors = errors?.takeRetainedValue() else {
				throw CSError.unwrappingError
			}
			throw errors
		}
		return warnings?.takeRetainedValue()
	}
	
	/// A variable estimating gamut of a display profile.
	public final var isWideGamut: Bool {
		return profile.isWideGamut
	}
	
	/// A variable verifying if a profile is matrix-based.
	public final var isMatrixBased: Bool {
		return profile.isMatrixBased
	}
	
	/// A variable verifying if a profile is using ITU BT.2100 PQ transfer functions.
	public final var isPQBased: Bool {
		return profile.isPQBased
	}
	
	/// A variable verifying if a profile is using ITU BT.2100 HLG transfer functions.
	public final var isHLGBased: Bool {
		return profile.isHLGBased
	}
}

#if os(macOS)
/// Estimates the display gamma for the passed-in display.
/// - parameter displayID: system-wide unique display ID (defined by IOKIt)
public func estimateGamma(displayID: Int32) throws -> Float {
	var errVal: Unmanaged<CFError>?
	let aRet = ColorSyncProfileEstimateGammaWithDisplayID(displayID, &errVal)
	
	guard aRet != 0.0 else {
		guard let errStuff = errVal?.takeRetainedValue() else {
			throw CSError.unwrappingError
		}
		throw errStuff
	}
	return aRet
}
#endif

/// A mutable version of `CSProfile`.
public final class CSMutableProfile: CSProfile {
	private let mutPtr: ColorSyncMutableProfile
	
	/// Creates an empty `CSMutableProfile`.
	public init() {
		mutPtr = ColorSyncProfileCreateMutable()!.takeRetainedValue()
		super.init(internalPtr: mutPtr)
	}
	
	fileprivate override init(internalPtr: ColorSyncProfile) {
		mutPtr = ColorSyncProfileCreateMutableCopy(internalPtr)!.takeRetainedValue()
		super.init(internalPtr: mutPtr)
	}
	
	/// `Data` containing the header data in host endianess
	override public var header: Data? {
		get {
			return super.header
		}
		set {
			if let aHeader = newValue {
				ColorSyncProfileSetHeader(mutPtr, aHeader as NSData)
			} else {
				print("header was sent nil, not doing anything!")
			}
		}
	}

	/// Removes a tag named `named`.
	public func removeTag(_ named: String) {
		ColorSyncProfileRemoveTag(mutPtr, named as NSString)
	}
	
	/// The data associated with the signature.
	/// - parameter tag: signature of the tag to be retrieved
	override public subscript (tag: String) -> Data? {
		get {
			return super[tag]
		}
		set {
			if let data = newValue {
				ColorSyncProfileSetTag(mutPtr, tag as NSString, data as NSData)
			} else {
				removeTag(tag)
			}
		}
	}
}
