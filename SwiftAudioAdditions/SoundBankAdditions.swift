//
//  SoundBankAdditions.swift
//  SwiftAudioAdditions
//
//  Created by C.W. Betts on 7/2/20.
//  Copyright © 2020 C.W. Betts. All rights reserved.
//

import Foundation
import AudioToolbox
import SwiftAdditions

/// Keys for dictionaries returned by `instrumentInfoFromSoundBank(at:)`
public enum InstrumentInfoKey: RawRepresentable, CustomStringConvertible, CaseIterable {
	public init?(rawValue: String) {
		switch rawValue {
		case kInstrumentInfoKey_Name:
			self = .name
			
		case kInstrumentInfoKey_MSB:
			self = .msb
			
		case kInstrumentInfoKey_LSB:
			self = .lsb
			
		case kInstrumentInfoKey_Program:
			self = .program
			
		default:
			return nil
		}
	}
	
	public var rawValue: String {
		switch self {
		case .name:
			return kInstrumentInfoKey_Name
		case .msb:
			return kInstrumentInfoKey_MSB
		case .lsb:
			return kInstrumentInfoKey_LSB
		case .program:
			return kInstrumentInfoKey_Program
		}
	}
	
	public var description: String {
		return rawValue
	}
	
	public typealias RawValue = String
	
	/// A `String` containing the name of the instrument.
	case name
	/// An `Int` for the most-significant byte of the bank number.  GM melodic banks will return 120 (0x78).
	/// GM percussion banks will return 121 (0x79).  Custom banks will return their literal value.
	case msb
	/// An `Int` for the least-significant byte of the bank number.  All GM banks will return
	/// the bank variation number (0-127).
	case lsb
	/// An `Int` for the program number (0-127) of an instrument within a particular bank.
	case program
}

/// This will return the name of a sound bank from a DLS or SF2 bank.
/// - parameter inURL: The URL for the sound bank.
/// - returns: The name of a sound bank.
public func nameFromSoundBank(at inURL: URL) throws -> String {
	var str: Unmanaged<CFString>? = nil
	let status = CopyNameFromSoundBank(inURL as NSURL, &str)
	guard status == noErr, let toRet = str?.takeRetainedValue() else {
		throw errorFromOSStatus(status, userInfo: [NSURLErrorKey: inURL])
	}
	
	return toRet as String
}

/// This will return an `Array` of Dictionaries, one per instrument found in the DLS or SF2 bank.
/// Each dictionary will contain four items accessed via `InstrumentInfoKey` versions of the keys `.msb`,
/// `.lsb`, `.program`, and `.name`.
/// - parameter inURL: The URL for the sound bank.
///
/// Using these MSB, LSB, and Program values will guarantee that the correct instrument is loaded by the DLS synth
/// or Sampler Audio Unit.
func instrumentInfoFromSoundBank(at inURL: URL) throws -> [[InstrumentInfoKey: Any]] {
	var tmpArr: Unmanaged<CFArray>?
	let status = CopyInstrumentInfoFromSoundBank(inURL as NSURL, &tmpArr)
	guard status == noErr, let tmpArr2 = tmpArr?.takeRetainedValue() as? [[String: Any]] else {
		throw errorFromOSStatus(status, userInfo: [NSURLErrorKey: inURL])
	}
	let toRet = tmpArr2.map { (aDict) -> [InstrumentInfoKey: Any] in
		var tmpDict = [InstrumentInfoKey: Any]()
		tmpDict.reserveCapacity(aDict.count)
		for (key, val) in aDict {
			guard let key2 = InstrumentInfoKey(rawValue: key) else {
				print("Uhh... unknown key \(key)?")
				continue
			}
			tmpDict[key2] = val
		}
		return tmpDict
	}
	return toRet
}
