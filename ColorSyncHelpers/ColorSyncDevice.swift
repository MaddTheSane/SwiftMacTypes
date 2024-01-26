//
//  ColorSyncDevice.swift
//  ColorSyncHelpers
//
//  Created by C.W. Betts on 8/22/16.
//  Copyright © 2016 C.W. Betts. All rights reserved.
//

import Foundation
import ColorSync
import FoundationAdditions

public enum CSDevice {
	
	public enum UserScope: RawLosslessStringConvertibleCFString, Codable, @unchecked Sendable, Hashable {
		case `any`
		case current
		
		public init?(rawValue: CFString) {
			switch rawValue {
			case kCFPreferencesCurrentUser:
				self = .current
			case kCFPreferencesAnyUser:
				self = .any
			default:
				return nil
			}
		}
		
		public var rawValue: CFString {
			switch self {
			case .any:
				return kCFPreferencesAnyUser
			case .current:
				return kCFPreferencesCurrentUser
			}
		}
		
		public var description: String {
			return rawValue as String
		}
	}
	
	public enum HostScope: RawLosslessStringConvertibleCFString, Codable, @unchecked Sendable, Hashable {
		case `any`
		case current
		
		public init?(rawValue: CFString) {
			switch rawValue {
			case kCFPreferencesCurrentHost:
				self = .current
			case kCFPreferencesAnyHost:
				self = .any
			default:
				return nil
			}
		}
		
		public var rawValue: CFString {
			switch self {
			case .any:
				return kCFPreferencesAnyUser
			case .current:
				return kCFPreferencesCurrentUser
			}
		}
		
		public var description: String {
			return rawValue as String
		}
	}
	
	public struct Profile: CustomStringConvertible, CustomDebugStringConvertible {
		public enum DeviceClass: RawLosslessStringConvertibleCFString, Codable, @unchecked Sendable, Hashable {
			case camera
			case display
			case printer
			case scanner
			
			public init?(rawValue: CFString) {
				switch rawValue {
				case kColorSyncCameraDeviceClass.takeUnretainedValue():
					self = .camera
				case kColorSyncDisplayDeviceClass.takeUnretainedValue():
					self = .display
				case kColorSyncPrinterDeviceClass.takeUnretainedValue():
					self = .printer
				case kColorSyncScannerDeviceClass.takeUnretainedValue():
					self = .scanner
				default:
					return nil
				}
			}
			
			public var rawValue: CFString {
				switch self {
				case .camera:
					return kColorSyncCameraDeviceClass.takeUnretainedValue()
				case .display:
					return kColorSyncDisplayDeviceClass.takeUnretainedValue()
				case .printer:
					return kColorSyncPrinterDeviceClass.takeUnretainedValue()
				case .scanner:
					return kColorSyncScannerDeviceClass.takeUnretainedValue()
				}
			}
			
			public var description: String {
				return rawValue as String
			}
		}
		public var identifier: UUID
		public var deviceDescription: String
		public var modeDescription: String
		public var profileID: String
		public var profileURL: URL
		public var extraEntries: [String: Any]
		public var isFactory: Bool
		public var isDefault: Bool
		public var isCurrent: Bool
		public var deviceClass: DeviceClass
		public var userScope: UserScope
		public var hostScope: HostScope

		public var description: String {
			return "\(deviceDescription), \(modeDescription) (\(deviceClass))"
		}
		
		public var debugDescription: String {
			return "CSDeviceInfo(deviceClass: \(deviceClass), identifier: \(identifier.uuidString), deviceDescription: \"\(deviceDescription)\", modeDescription: \"\(modeDescription)\", profileID: \(profileID), profileURL: \(profileURL), isFactory: \(isFactory), isDefault: \(isDefault), isCurrent: \(isCurrent))"
		}
	}
	
	public struct Info {
		public struct FactoryProfiles {
			public struct Profile {
				public var profileURL: URL?
				public var modeDescription: String
			}
			public var defaultProfileID: String
			public var profiles: [String: Profile]
		}
		
		public var deviceClass: Profile.DeviceClass
		public var deviceID: UUID
		public var deviceDescription: String
		public var factoryProfiles: FactoryProfiles
		public var customProfiles: [String: URL?]
		public var userScope: UserScope
		public var hostScope: HostScope
	}

	/// Returns a dictionary with the following keys and values resolved for the current host and current user.
	///
	///     <<
	///         kColorSyncDeviceClass                   {camera, display, printer, scanner}
	///         kColorSyncDeviceID                      {CFUUIDRef registered with ColorSync}
	///         kColorSyncDeviceDescription             {localized device description}
	///         kColorSyncFactoryProfiles  (dictionary) <<
	///                                                     {ProfileID}    (dictionary) <<
	///                                                                                     kColorSyncDeviceProfileURL      {CFURLRef or kCFNull}
	///                                                                                     kColorSyncDeviceModeDescription {localized mode description}
	///                                                                                 >>
	///                                                      ...
	///                                                     kColorSyncDeviceDefaultProfileID {ProfileID}
	///                                                 >>
	///         kColorSyncCustomProfiles  (dictionary) <<
	///                                                     {ProfileID}    {CFURLRef or kCFNull}
	///                                                     ...
	///                                                <<
	///         kColorSyncDeviceUserScope              {kCFPreferencesAnyUser or kCFPreferencesCurrentUser}
	///         kColorSyncDeviceHostScope              {kCFPreferencesAnyHost or kCFPreferencesCurrentHost}
	///     >>
	private static func copyDeviceInfo(withClass deviceClass: CFString, identifier: CFUUID) -> [String: Any] {
		return ColorSyncDeviceCopyDeviceInfo(deviceClass, identifier)!.takeRetainedValue() as NSDictionary as! [String: Any]
	}
	
	@available(*, deprecated, renamed: "info(for:identifier:)")
	public static func info(deviceClass dc: Profile.DeviceClass, identifier: UUID) -> Info {
		return info(for: dc, identifier: identifier)!
	}
	
	public static func info(for dc: Profile.DeviceClass, identifier: UUID) -> Info? {
		//Info
		
		var devInfo = copyDeviceInfo(withClass: dc.rawValue, identifier: identifier.cfUUID)
		guard let preDevClass = devInfo.removeValue(forKey: kColorSyncDeviceClass.takeUnretainedValue() as String) as? String as CFString? else {
			return nil
		}
		guard let devClass = Profile.DeviceClass(rawValue: preDevClass) else {
			print("Unknown device class \(preDevClass)")
			return nil
		}
		guard let devIDC = devInfo.removeValue(forKey: kColorSyncDeviceID.takeUnretainedValue() as String) as CFTypeRef?,
			  let devDes = devInfo.removeValue(forKey: kColorSyncDeviceDescription.takeUnretainedValue() as String) as? String,
			  var factProf = devInfo.removeValue(forKey: kColorSyncDeviceDescription.takeUnretainedValue() as String) as? NSDictionary as? [String: Any],
			  let defaultID = factProf.removeValue(forKey: kColorSyncDeviceDefaultProfileID.takeUnretainedValue() as String) as? String,
			  let devID = castCFType(devIDC, to: CFUUID.self) else {
			return nil
		}
		var ahi: [String: CSDevice.Info.FactoryProfiles.Profile] = [:]
		for (tmpID, dict) in factProf as! [String: [String: Any]] {
			//var listDir: [CSDevice.Info.FactoryProfiles.Profile] = []
			
			ahi[tmpID] = Info.FactoryProfiles.Profile(profileURL: (dict[kColorSyncDeviceProfileURL.takeUnretainedValue() as String]) as? URL, modeDescription: (dict[kColorSyncDeviceModeDescription.takeUnretainedValue() as String]) as! String)
		}
		let fac = Info.FactoryProfiles(defaultProfileID: defaultID, profiles: ahi)
		let custProfs: Dictionary<String, URL?> = {
			let custom = devInfo.removeValue(forKey: kColorSyncCustomProfiles.takeUnretainedValue() as String) as! NSDictionary as! [String: Any]
			var tmpDict: Dictionary<String, URL?> = [:]
			for (key, value) in custom {
				tmpDict[key] = value as? URL
			}
			return tmpDict
		}()
		
		let userScopeStr = devInfo.removeValue(forKey: kColorSyncDeviceUserScope.takeUnretainedValue() as String) as? NSString
		let hostScopeStr = devInfo.removeValue(forKey: kColorSyncDeviceHostScope.takeUnretainedValue() as String) as? NSString
		let userScope: UserScope
		let hostScope: HostScope
		if let userScopeStr = userScopeStr {
			userScope = UserScope(rawValue: userScopeStr) ?? .current
		} else {
			userScope = .current
		}
		if let userScopeStr = hostScopeStr {
			hostScope = HostScope(rawValue: userScopeStr) ?? .current
		} else {
			hostScope = .current
		}
		
		let aUU = UUID(cfUUID: devID)

		return Info(deviceClass: devClass, deviceID: aUU, deviceDescription: devDes, factoryProfiles: fac, customProfiles: custProfs, userScope: userScope, hostScope: hostScope)
	}
	
	public static func deviceInfos() -> [Profile] {
		let profsArr: Array<[String: Any]> = {
			let profs = NSMutableArray()
			
			ColorSyncIterateDeviceProfiles({ (aDict, refCon) -> Bool in
				let array = Unmanaged<NSMutableArray>.fromOpaque(refCon!).takeUnretainedValue()
				
				let bDict = (aDict as NSDictionary?)!.copy()
				array.add(bDict)
				return true
				}, UnsafeMutableRawPointer(Unmanaged.passUnretained(profs).toOpaque()))
			
			return profs as! Array<[String: Any]>
		}()
		
		let devInfo = profsArr.compactMap { (aDict) -> Profile? in
			var otherDict = aDict
			guard let preDevClass = otherDict.removeValue(forKey: kColorSyncDeviceClass.takeUnretainedValue() as String) as? NSString,
				  let devClass = Profile.DeviceClass(rawValue: preDevClass) else {
				return nil
			}
			guard let devIDC = otherDict.removeValue(forKey: kColorSyncDeviceID.takeUnretainedValue() as String) as CFTypeRef?,
				  let devID = castCFType(devIDC, to: CFUUID.self),
				  let profID = otherDict.removeValue(forKey: kColorSyncDeviceProfileID.takeUnretainedValue() as String) as? String,
				  let profURL = otherDict.removeValue(forKey: kColorSyncDeviceProfileURL.takeUnretainedValue() as String) as? URL,
				  let devDes = otherDict.removeValue(forKey: kColorSyncDeviceDescription.takeUnretainedValue() as String) as? String,
				  let modeDes = otherDict.removeValue(forKey: kColorSyncDeviceModeDescription.takeUnretainedValue() as String) as? String,
				  let isFactory = otherDict.removeValue(forKey: kColorSyncDeviceProfileIsFactory.takeUnretainedValue() as String) as? Bool,
				  let isDefault = otherDict.removeValue(forKey: kColorSyncDeviceProfileIsDefault.takeUnretainedValue() as String) as? Bool,
				  let isCurrent = otherDict.removeValue(forKey: kColorSyncDeviceProfileIsCurrent.takeUnretainedValue() as String) as? Bool else {
				return nil
			}
			let userScopeStr = otherDict.removeValue(forKey: kColorSyncProfileUserScope.takeUnretainedValue() as String) as? NSString
			let hostScopeStr = otherDict.removeValue(forKey: kColorSyncProfileHostScope.takeUnretainedValue() as String) as? NSString
			
			let userScope: UserScope
			let hostScope: HostScope
			if let userScopeStr = userScopeStr {
				userScope = UserScope(rawValue: userScopeStr) ?? .current
			} else {
				userScope = .current
			}
			
			if let userScopeStr = hostScopeStr {
				hostScope = HostScope(rawValue: userScopeStr) ?? .current
			} else {
				hostScope = .current
			}
			
			let devNSID = UUID(cfUUID: devID)
			
			return Profile(identifier: devNSID, deviceDescription: devDes, modeDescription: modeDes, profileID: profID, profileURL: profURL, extraEntries: otherDict, isFactory: isFactory, isDefault: isDefault, isCurrent: isCurrent, deviceClass: devClass, userScope: userScope, hostScope: hostScope)
		}
		
		return devInfo
	}
}
