//
//  AudioFileExt.swift
//  PPMacho
//
//  Created by C.W. Betts on 8/28/14.
//
//

import Foundation
import AudioToolbox
import CoreAudio
import SwiftAdditions

// MARK: Audio File

public var kLinearPCMFormatFlagNativeEndian: AudioFormatFlags {
	#if _endian(big)
		return kLinearPCMFormatFlagIsBigEndian
	#else
		return 0
	#endif
}

public enum AudioFileType: OSType {
	case unknown			= 0
	case AIFF				= 1095321158
	case AIFC				= 1095321155
	case WAVE				= 1463899717
	case soundDesigner2		= 1399075430
	case NeXT				= 1315264596
	case MP3				= 1297106739
	case MP2				= 1297106738
	case MP1				= 1297106737
	case AC3				= 1633889587
	case AAC_ADTS			= 1633973363
	case MPEG4				= 1836069990
	case M4A				= 1832149350
	case M4B				= 1832149606
	case CAF				= 1667327590
	case threeGP			= 862417008
	case threeGP2			= 862416946
	case AMR				= 1634562662
	
	public var stringValue: String {
		return OSTypeToString(self.rawValue) ?? "    "
	}
}

public func AudioFileCreate(url inFileRef: URL, fileType inFileType: AudioFileType, format: inout AudioStreamBasicDescription, flags: AudioFileFlags = AudioFileFlags(rawValue: 0), audioFile outAudioFile: inout AudioFileID?) -> OSStatus {
	return AudioFileCreateWithURL(inFileRef as NSURL, inFileType.rawValue, &format, flags, &outAudioFile)
}

public func AudioFileCreate(path: String, fileType inFileType: AudioFileType, format: inout AudioStreamBasicDescription, flags: AudioFileFlags = AudioFileFlags(rawValue: 0), audioFile outAudioFile: inout AudioFileID?) -> OSStatus {
	let inFileRef = URL(fileURLWithPath: path)
	return AudioFileCreate(url: inFileRef, fileType: inFileType, format: &format, flags: flags, audioFile: &outAudioFile)
}

public func AudioFileOpen(url inFileRef: NSURL, permissions: AudioFilePermissions = .readPermission, fileTypeHint: AudioFileType? = nil, audioFile outAudioFile: inout AudioFileID?) -> OSStatus {
	return AudioFileOpenURL(inFileRef, permissions, fileTypeHint?.rawValue ?? 0, &outAudioFile)
}

public func AudioFileOpen(path: String, permissions: AudioFilePermissions = .readPermission, fileTypeHint: AudioFileType? = nil, audioFile outAudioFile: inout AudioFileID?) -> OSStatus {
	let inFileRef = NSURL(fileURLWithPath: path)
	return AudioFileOpen(url: inFileRef, permissions: permissions, fileTypeHint: fileTypeHint, audioFile: &outAudioFile)
}

public func AudioFileReadBytes(audioFile: AudioFileID, useCache: Bool = false, startingByte: Int64 = 0, numberBytes: inout UInt32, buffer: UnsafeMutableRawPointer) -> OSStatus {
	return AudioFileReadBytes(audioFile, useCache, startingByte, &numberBytes, buffer)
}

public func AudioFileWriteBytes(audioFile: AudioFileID, useCache: Bool = false, startingByte: Int64 = 0, numberBytes: inout UInt32, buffer: UnsafeRawPointer) -> OSStatus {
	return AudioFileWriteBytes(audioFile, useCache, startingByte, &numberBytes, buffer)
}

// MARK: Audio Format

public enum AudioFormat: OSType {
	case unknown				= 0
	case DVIIntelIMA			= 0x6D730011
	case microsoftGSM			= 0x6D730031
	case linearPCM				= 1819304813
	case AC3					= 1633889587
	case six0958AC3				= 1667326771
	case appleIMA4				= 1768775988
	case MPEG4AAC				= 1633772320
	case MPEG4CELP				= 1667591280
	case MPEG4HVXC				= 1752594531
	case MPEG4TwinVQ			= 1953986161
	case MACE3					= 1296122675
	case MACE6					= 1296122678
	case µLaw					= 1970037111
	case aLaw					= 1634492791
	case qDesign				= 1363430723
	case qDesign2				= 1363430706
	case QUALCOMM				= 1365470320
	case MPEGLayer1				= 778924081
	case MPEGLayer2				= 778924082
	case MPEGLayer3				= 778924083
	case timeCode				= 1953066341
	case MIDIStream				= 1835623529
	case parameterValueStream	= 1634760307
	case appleLossless			= 1634492771
	case MPEG4AAC_HE			= 1633772392
	case MPEG4AAC_LD			= 1633772396
	case MPEG4AAC_ELD			= 1633772389
	case MPEG4AAC_ELD_SBR		= 1633772390
	case MPEG4AAC_ELD_V2		= 1633772391
	case MPEG4AAC_HE_V2			= 1633772400
	case MPEG4AAC_Spatial		= 1633772403
	case AMR					= 1935764850
	case AMR_WB					= 1935767394
	case audible				= 1096107074
	case iLBC					= 1768710755
	case AES3					= 1634038579
	
	@available(*, deprecated, message: "Use µLaw instead", renamed: "µLaw")
	public static var uLaw: AudioFormat {
		return .µLaw
	}
	
	public var stringValue: String {
		return OSTypeToString(self.rawValue) ?? "    "
	}
}

public struct AudioFormatFlag : OptionSet {
	public let rawValue: UInt32

	public init(rawValue value: UInt32) { self.rawValue = value }
	public static var nativeFloatPacked: AudioFormatFlag {
		return [float, nativeEndian, packed]
	}

	public static var float: AudioFormatFlag {
		return AudioFormatFlag(rawValue: 1 << 0)
	}
	public static var bigEndian: AudioFormatFlag {
		return AudioFormatFlag(rawValue: 1 << 1)
	}
	public static var signedInteger: AudioFormatFlag {
		return AudioFormatFlag(rawValue: 1 << 2)
	}
	public static var packed: AudioFormatFlag {
		return AudioFormatFlag(rawValue: 1 << 3)
	}
	public static var alignedHigh: AudioFormatFlag {
		return AudioFormatFlag(rawValue: 1 << 4)
	}
	public static var nonInterleaved: AudioFormatFlag {
		return AudioFormatFlag(rawValue: 1 << 5)
	}
	public static var nonMixable: AudioFormatFlag {
		return AudioFormatFlag(rawValue: 1 << 6)
	}
	public static var flagsAreAllClear: AudioFormatFlag {
		return AudioFormatFlag(rawValue: 1 << 31)
	}
	public static var nativeEndian: AudioFormatFlag {
		#if _endian(little)
			return self.init(rawValue: 0)
		#elseif _endian(big)
			return bigEndian
		#else
			fatalError("Unknown endianness")
		#endif
	}
}

public struct LinearPCMFormatFlag : OptionSet {
	public let rawValue: UInt32

	public init(rawValue value: UInt32) { self.rawValue = value }
	public static var nativeFloatPacked: LinearPCMFormatFlag {
		return [float, nativeEndian, packed]
	}
	
	public static var float: LinearPCMFormatFlag {
		return LinearPCMFormatFlag(rawValue: 1 << 0)
	}
	public static var bigEndian: LinearPCMFormatFlag {
		return LinearPCMFormatFlag(rawValue: 1 << 1)
	}
	public static var signedInteger: LinearPCMFormatFlag {
		return LinearPCMFormatFlag(rawValue: 1 << 2)
	}
	public static var packed: LinearPCMFormatFlag {
		return LinearPCMFormatFlag(rawValue: 1 << 3)
	}
	public static var alignedHigh: LinearPCMFormatFlag {
		return LinearPCMFormatFlag(rawValue: 1 << 4)
	}
	public static var nonInterleaved: LinearPCMFormatFlag {
		return LinearPCMFormatFlag(rawValue: 1 << 5)
	}
	public static var nonMixable: LinearPCMFormatFlag {
		return LinearPCMFormatFlag(rawValue: 1 << 6)
	}
	public static var flagsAreAllClear: LinearPCMFormatFlag {
		return LinearPCMFormatFlag(rawValue: 1 << 31)
	}
	public static var nativeEndian: LinearPCMFormatFlag {
		#if _endian(little)
			return self.init(rawValue: 0)
		#elseif _endian(big)
			return bigEndian
		#else
			fatalError("Unknown endianness")
		#endif
	}
	public static var flagsSampleFractionShift: UInt32 {
		return 7
	}
	public static var flagsSampleFractionMask : LinearPCMFormatFlag {
		return self.init(rawValue: 0x3F << flagsSampleFractionShift)
	}
}

public extension AudioStreamBasicDescription {
	
	/// Is the current `AudioStreamBasicDescription` in the native endian format?
	///
	/// Is `true` if the audio is in the native endian, `false` if not, and `nil` if the `formatID` isn't `.linearPCM`.
	public var audioFormatNativeEndian: Bool? {
		if formatID == .linearPCM {
			let ourFlags = formatFlags.intersection(.bigEndian)
			if ourFlags == .nativeEndian {
				return true
			} else {
				return false
			}
		}
		return nil
	}
	
	public var formatID: AudioFormat {
		get {
			if let aFormat = AudioFormat(rawValue: mFormatID) {
				return aFormat
			} else {
				return .unknown
			}
		}
		set {
			mFormatID = newValue.rawValue
		}
	}
	
	public var formatFlags: AudioFormatFlag {
		get {
			return AudioFormatFlag(rawValue: mFormatFlags)
		}
		set {
			mFormatFlags = newValue.rawValue
		}
	}
	
	public init(sampleRate: Float64, formatID: AudioFormat = .linearPCM, formatFlags: AudioFormatFlag = .nativeFloatPacked, bitsPerChannel: UInt32, channelsPerFrame: UInt32, framesPerPacket: UInt32 = 1) {
		let bytesPerFrame = bitsPerChannel * channelsPerFrame / 8
		self.init(mSampleRate: sampleRate, mFormatID: formatID.rawValue, mFormatFlags: formatFlags.rawValue, mBytesPerPacket: bytesPerFrame * framesPerPacket, mFramesPerPacket: framesPerPacket, mBytesPerFrame: bytesPerFrame, mChannelsPerFrame: channelsPerFrame, mBitsPerChannel: bitsPerChannel, mReserved: 0)
	}
	
	@available(*, deprecated, message: "AudioFormatID and AudioFormatFlags constants should now be typed correctly")
	public init(sampleRate: Float64, formatID: Int, formatFlags: Int, bitsPerChannel: UInt32, channelsPerFrame: UInt32, framesPerPacket: UInt32 = 1) {
		mSampleRate = sampleRate
		mFormatID = UInt32(formatID)
		mFormatFlags = UInt32(formatFlags)
		mBitsPerChannel = bitsPerChannel
		mChannelsPerFrame = channelsPerFrame
		mFramesPerPacket = framesPerPacket
		mBytesPerFrame = mBitsPerChannel * mChannelsPerFrame / 8
		mBytesPerPacket = mBytesPerFrame * mFramesPerPacket
		mReserved = 0
	}
	
	public init(sampleRate: Float64, formatID: AudioFormatID, formatFlags: AudioFormatFlags, bitsPerChannel: UInt32, channelsPerFrame: UInt32, framesPerPacket: UInt32 = 1) {
		let bytesPerFrame = bitsPerChannel * channelsPerFrame / 8
		self.init(mSampleRate: sampleRate, mFormatID: formatID, mFormatFlags: formatFlags, mBytesPerPacket: bytesPerFrame * framesPerPacket, mFramesPerPacket: framesPerPacket, mBytesPerFrame: bytesPerFrame, mChannelsPerFrame: channelsPerFrame, mBitsPerChannel: bitsPerChannel, mReserved: 0)
	}
}

public extension AudioStreamBasicDescription {
	// The following getters/functions are from Apple's CoreAudioUtilityClasses
	
	var	PCM: Bool {
		return mFormatID == kAudioFormatLinearPCM
	}

	public var interleaved: Bool {
		return !formatFlags.contains(.nonInterleaved)
	}
	
	public var signedInteger: Bool {
		return PCM && (mFormatFlags & kAudioFormatFlagIsSignedInteger) != 0
	}
	
	public var float: Bool {
		return PCM && (mFormatFlags & kAudioFormatFlagIsFloat) != 0
	}
	
	public var interleavedChannels: UInt32 {
		return interleaved ? mChannelsPerFrame : 1
	}
	
	public var channelStreams: UInt32 {
		return interleaved ? 1 : mChannelsPerFrame
	}
	
	public var sampleWordSize: UInt32 {
		return (mBytesPerFrame > 0 && interleavedChannels != 0) ? mBytesPerFrame / interleavedChannels :  0;
	}
	
	public enum ASBDError: Error {
		case reqiresPCMFormat
	}
	
	public mutating func changeCountOfChannels(nChannels: UInt32, interleaved: Bool) throws {
		guard PCM else {
			throw ASBDError.reqiresPCMFormat
		}
		let wordSize: UInt32 = { // get this before changing ANYTHING
			var ws = sampleWordSize
			if ws == 0 {
				ws = (mBitsPerChannel + 7) / 8;
			}
			return ws
		}()
		mChannelsPerFrame = nChannels
		mFramesPerPacket = 1
		if interleaved {
			let newBytes = nChannels * wordSize
			mBytesPerPacket = newBytes
			mBytesPerFrame = newBytes
			formatFlags.remove(.nonInterleaved)
		} else {
			let newBytes = wordSize
			mBytesPerPacket = newBytes
			mBytesPerFrame = newBytes
			_ = formatFlags.insert(.nonInterleaved)
		}
	}
	
	/// This method returns false if there are sufficiently insane values in any field.
	/// It is very conservative so even some very unlikely values will pass.
	/// This is just meant to catch the case where the data from a file is corrupted.
	public func checkSanity() -> Bool {
		return
			(mSampleRate >= 0)
				&& (mSampleRate < 3e6)	// SACD sample rate is 2.8224 MHz
				&& (mBytesPerPacket < 1000000)
				&& (mFramesPerPacket < 1000000)
				&& (mBytesPerFrame < 1000000)
				&& (mChannelsPerFrame <= 1024)
				&& (mBitsPerChannel <= 1024)
				&& (mFormatID != 0)
				&& !(mFormatID == kAudioFormatLinearPCM && (mFramesPerPacket != 1 || mBytesPerPacket != mBytesPerFrame));
	}
	
	///	format[@sample_rate_hz][/format_flags][#frames_per_packet][:LHbytesPerFrame][,channelsDI].<br>
	/// Format for PCM is [-][BE|LE]{F|I|UI}{bitdepth}; else a 4-char format code (e.g. `aac`, `alac`).
	public init?(fromText: String) {
		var charIterator = fromText.startIndex
		
		func numFromCurrentChar() -> Int? {
			guard charIterator < fromText.endIndex else {
				return nil
			}
			
			return Int(String(fromText[charIterator]))
		}
		
		func nextChar() -> Character? {
			guard charIterator < fromText.endIndex else {
				return nil
			}
			
			return fromText[charIterator]
		}
		
		if fromText.count < 3 {
			return nil
		}
		
		self.init()
		
		var isPCM = true;	// until proven otherwise
		var pcmFlags = kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;
		
		if fromText[charIterator] == "-" {	// previously we required a leading dash on PCM formats
			charIterator = fromText.index(after: charIterator)
		}
		
		if fromText[charIterator] == "B" && fromText[fromText.index(after: charIterator)] == "E" {
			pcmFlags |= kLinearPCMFormatFlagIsBigEndian;
			charIterator = fromText.index(charIterator, offsetBy: 2)
		} else if fromText[charIterator] == "L" && fromText[fromText.index(after: charIterator)] == "E" {
			charIterator = fromText.index(charIterator, offsetBy: 2)
		} else {
			// default is native-endian
			pcmFlags |= kLinearPCMFormatFlagNativeEndian
		}
		if nextChar() == "F" {
			pcmFlags = (pcmFlags & ~kAudioFormatFlagIsSignedInteger) | kAudioFormatFlagIsFloat
			charIterator = fromText.index(after: charIterator)
		} else {
			if nextChar() == "U" {
				pcmFlags &= ~kAudioFormatFlagIsSignedInteger;
				charIterator = fromText.index(after: charIterator)
			}
			if nextChar() == "I" {
				charIterator = fromText.index(after: charIterator)
			} else {
				// it's not PCM; presumably some other format (NOT VALIDATED; use AudioFormat for that)
				isPCM = false;
				charIterator = fromText.startIndex;	// go back to the beginning
				var buf = Array<Int8>(repeating: 0x20, count: 4);
				for (i, var aBuf) in buf.enumerated() {
					if nextChar() != "\\" {
						let wasAdvanced: Bool
						if let cChar = nextChar() {
							let bBuf = String(cChar).cString(using: String.Encoding.macOSRoman) ?? [0]
							aBuf = bBuf[0]
							charIterator = fromText.index(after: charIterator)
							wasAdvanced = true
						} else {
							aBuf = 0
							wasAdvanced = false
						}
						buf[i] = aBuf
						
						if aBuf == 0 {
							// special-case for 'aac'
							if i != 3 {
								return nil;
							}
							if wasAdvanced {
								charIterator = fromText.index(before: charIterator)	// keep pointing at the terminating null
							}
							aBuf = 0x20;
							buf[i] = aBuf
							break;
						}
					} else {
						// "\xNN" is a hex byte
						charIterator = fromText.index(after: charIterator)
						if (nextChar() != "x") {
							return nil;
						}
						var x: Int32 = 0
						
						//TODO: use Scanner
						if (withVaList([withUnsafeMutablePointer(to: &x, {return $0})], { (vaPtr) -> Int32 in
							charIterator = fromText.index(after: charIterator)
							let str = fromText[charIterator ..< fromText.endIndex]
							return str.withCString({ (cStr) -> Int32 in
								return vsscanf(cStr, "%02X", vaPtr)
							})
						}) != 1) {
							return nil
						}
						
						aBuf = Int8(truncatingIfNeeded: x)
						buf[i] = aBuf
						charIterator = fromText.index(charIterator, offsetBy: 2)
					}
				}
				
				if strchr("-@/#", Int32(buf[3])) != nil {
					// further special-casing for 'aac'
					buf[3] = 0x20;
					charIterator = fromText.index(before: charIterator)
				}
				
				memcpy(&mFormatID, buf, 4);
				mFormatID = mFormatID.bigEndian
			}
		}
		
		if isPCM {
			mFormatID = kAudioFormatLinearPCM;
			mFormatFlags = pcmFlags;
			mFramesPerPacket = 1;
			mChannelsPerFrame = 1;
			var bitdepth: UInt32 = 0
			var fracbits: UInt32 = 0
			while let aNum = numFromCurrentChar() {
				bitdepth = 10 * bitdepth + UInt32(aNum)
				charIterator = fromText.index(after: charIterator)
			}
			if (nextChar() == ".") {
				charIterator = fromText.index(after: charIterator)
				guard let _ = numFromCurrentChar() else {
					print("Expected fractional bits following '.'");
					return nil;
				}
				while let aNum = numFromCurrentChar() {
					fracbits = 10 * fracbits + UInt32(aNum)
					charIterator = fromText.index(after: charIterator)
				}
				bitdepth += fracbits;
				mFormatFlags |= (fracbits << kLinearPCMFormatFlagsSampleFractionShift);
			}
			mBitsPerChannel = bitdepth;
			mBytesPerFrame = (bitdepth + 7) / 8;
			mBytesPerPacket = mBytesPerFrame
			if (bitdepth & 7) != 0 {
				// assume unpacked. (packed odd bit depths are describable but not supported in AudioConverter.)
				mFormatFlags &= ~kLinearPCMFormatFlagIsPacked
				// alignment matters; default to high-aligned. use ':L_' for low.
				mFormatFlags |= kLinearPCMFormatFlagIsAlignedHigh;
			}
		}
		if nextChar() == "@" {
			charIterator = fromText.index(after: charIterator)
			while let aNum = numFromCurrentChar() {
				mSampleRate = 10 * mSampleRate + Float64(aNum)
				charIterator = fromText.index(after: charIterator)
			}
		}
		if nextChar() == "/" {
			var flags: UInt32 = 0;
			while true {
				charIterator = fromText.index(after: charIterator)
				guard charIterator < fromText.endIndex else {
					break
				}
				guard let bChar = ASCIICharacter(swiftCharacter: fromText[charIterator]) else {
					break
				}
				//Int(hex)
				
				if bChar >= ASCIICharacter.NumberZero && bChar <= ASCIICharacter.NumberNine {
					flags = (flags << 4) | UInt32(bChar.rawValue - ASCIICharacter.NumberZero.rawValue);
				} else if bChar >= ASCIICharacter.LetterUppercaseA && bChar <= ASCIICharacter.LetterUppercaseF {
					flags = (flags << 4) | UInt32(bChar.rawValue - ASCIICharacter.LetterUppercaseA.rawValue + 10);
				} else if bChar >= ASCIICharacter.LetterLowercaseA && bChar <= ASCIICharacter.LetterLowercaseF {
					flags = (flags << 4) | UInt32(bChar.rawValue - ASCIICharacter.LetterLowercaseA.rawValue + 10);
				} else {
					break;
				}
			}
			mFormatFlags = flags;
		}
		if (nextChar() == "#") {
			charIterator = fromText.index(after: charIterator)
			while let aNum = numFromCurrentChar() {
				mFramesPerPacket = 10 * mFramesPerPacket + UInt32(aNum)
				charIterator = fromText.index(after: charIterator)
			}
		}
		if nextChar() == ":" {
			charIterator = fromText.index(after: charIterator)
			mFormatFlags &= ~kLinearPCMFormatFlagIsPacked
			if (fromText[charIterator] == "L") {
				mFormatFlags &= ~kLinearPCMFormatFlagIsAlignedHigh
			} else if (fromText[charIterator] == "H") {
				mFormatFlags |= kLinearPCMFormatFlagIsAlignedHigh;
			} else {
				return nil;
			}
			charIterator = fromText.index(after: charIterator)
			var bytesPerFrame: UInt32 = 0;
			while let aNum = numFromCurrentChar() {
				bytesPerFrame = 10 * bytesPerFrame + UInt32(aNum)
				charIterator = fromText.index(after: charIterator)
			}
			mBytesPerPacket = bytesPerFrame
			mBytesPerFrame = mBytesPerPacket
		}
		if nextChar() == "," {
			charIterator = fromText.index(after: charIterator)
			var ch = 0;
			while let aNum = numFromCurrentChar() {
				ch = 10 * ch + aNum
				charIterator = fromText.index(after: charIterator)
			}
			mChannelsPerFrame = UInt32(ch);
			if nextChar() == "D" {
				charIterator = fromText.index(after: charIterator)
				guard mFormatID == kAudioFormatLinearPCM else {
					print("non-interleaved flag invalid for non-PCM formats\n");
					return nil;
				}
				mFormatFlags |= kAudioFormatFlagIsNonInterleaved;
			} else {
				if nextChar() == "I" {
					charIterator = fromText.index(after: charIterator)
				}	// default
				if mFormatID == kAudioFormatLinearPCM {
					mBytesPerFrame *= UInt32(ch)
					mBytesPerPacket = mBytesPerFrame
				}
			}
		}
		if charIterator != fromText.endIndex {
			print("extra characters at end of format string: \(fromText[charIterator..<fromText.endIndex])");
			return nil
		}
	}
}

extension AudioStreamBasicDescription: Comparable {
	
}

public func ==(lhs: AudioStreamBasicDescription, rhs: AudioStreamBasicDescription) -> Bool {
	if lhs.mBytesPerFrame != rhs.mBytesPerFrame {
		return false
	} else if lhs.mSampleRate != rhs.mSampleRate {
		return false
	} else if lhs.mFormatID != rhs.mFormatID {
		return false
	} else if lhs.mFormatFlags != rhs.mFormatFlags {
		return false
	} else if lhs.mFramesPerPacket != rhs.mFramesPerPacket {
		return false
	} else if lhs.mBytesPerPacket != rhs.mBytesPerPacket {
		return false
	} else if lhs.mChannelsPerFrame != rhs.mChannelsPerFrame {
		return false
	} else if lhs.mBitsPerChannel != rhs.mBitsPerChannel {
		return false
	} else {
		return true
	}
}

public func <(x: AudioStreamBasicDescription, y: AudioStreamBasicDescription) -> Bool {
	var theAnswer = false;
	var isDone = false;
	
	//	note that if either side is 0, that field is skipped
	
	//	format ID is the first order sort
	if (!isDone) && ((x.mFormatID != 0) && (y.mFormatID != 0)) {
		if x.mFormatID != y.mFormatID {
			//	formats are sorted numerically except that linear
			//	PCM is always first
			if x.mFormatID == kAudioFormatLinearPCM {
				theAnswer = true;
			} else if y.mFormatID == kAudioFormatLinearPCM {
				theAnswer = false;
			} else {
				theAnswer = x.mFormatID < y.mFormatID;
			}
			isDone = true;
		}
	}
	
	//  mixable is always better than non-mixable for linear PCM and should be the second order sort item
	if (!isDone) && ((x.mFormatID == kAudioFormatLinearPCM) && (y.mFormatID == kAudioFormatLinearPCM)) {
		if ((x.mFormatFlags & kAudioFormatFlagIsNonMixable) == 0) && ((y.mFormatFlags & kAudioFormatFlagIsNonMixable) != 0) {
			theAnswer = true;
			isDone = true;
		} else if ((x.mFormatFlags & kAudioFormatFlagIsNonMixable) != 0) && ((y.mFormatFlags & kAudioFormatFlagIsNonMixable) == 0) {
			theAnswer = false;
			isDone = true;
		}
	}
	
	//	floating point vs integer for linear PCM only
	if (!isDone) && (x.mFormatID == kAudioFormatLinearPCM && y.mFormatID == kAudioFormatLinearPCM) {
		if (x.mFormatFlags & kAudioFormatFlagIsFloat) != (y.mFormatFlags & kAudioFormatFlagIsFloat) {
			//	floating point is better than integer
			theAnswer = (y.mFormatFlags & kAudioFormatFlagIsFloat) != 0
			isDone = true;
		}
	}
	
	//	bit depth
	if (!isDone) && (x.mBitsPerChannel != 0 && y.mBitsPerChannel != 0) {
		if x.mBitsPerChannel != y.mBitsPerChannel {
			//	deeper bit depths are higher quality
			theAnswer = x.mBitsPerChannel < y.mBitsPerChannel;
			isDone = true;
		}
	}
	
	//	sample rate
	if (!isDone) && (x.mSampleRate != 0) && (y.mSampleRate != 0) {
		if x.mSampleRate != y.mSampleRate {
			//	higher sample rates are higher quality
			theAnswer = x.mSampleRate < y.mSampleRate;
			isDone = true;
		}
	}
	
	//	number of channels
	if (!isDone) && (x.mChannelsPerFrame != 0 && y.mChannelsPerFrame != 0) {
		if x.mChannelsPerFrame != y.mChannelsPerFrame {
			//	more channels is higher quality
			theAnswer = x.mChannelsPerFrame < y.mChannelsPerFrame;
			//isDone = true;
		}
	}
	
	return theAnswer;
}

// MARK: - deprecated Swift 2 names

extension LinearPCMFormatFlag {
	@available(*, unavailable, message:"Use '.nativeFloatPacked' instead", renamed: "nativeFloatPacked")
	public static var NativeFloatPacked: LinearPCMFormatFlag {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.float' instead", renamed: "float")
	public static var Float: LinearPCMFormatFlag {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.bigEndian' instead", renamed: "bigEndian")
	public static var BigEndian: LinearPCMFormatFlag {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.signedInteger' instead", renamed: "signedInteger")
	public static var SignedInteger: LinearPCMFormatFlag {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.packed' instead", renamed: "packed")
	public static var Packed: LinearPCMFormatFlag {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.alignedHigh' instead", renamed: "alignedHigh")
	public static var AlignedHigh: LinearPCMFormatFlag {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.nonInterleaved' instead", renamed: "nonInterleaved")
	public static var NonInterleaved: LinearPCMFormatFlag {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.nonMixable' instead", renamed: "nonMixable")
	public static var NonMixable: LinearPCMFormatFlag {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.flagsAreAllClear' instead", renamed: "flagsAreAllClear")
	public static var FlagsAreAllClear: LinearPCMFormatFlag {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.nativeEndian' instead", renamed: "nativeEndian")
	public static var NativeEndian: LinearPCMFormatFlag {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.flagsSampleFractionShift' instead", renamed: "flagsSampleFractionShift")
	public static var FlagsSampleFractionShift: UInt32 {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.flagsSampleFractionMask' instead", renamed: "flagsSampleFractionMask")
	public static var FlagsSampleFractionMask : LinearPCMFormatFlag {
		fatalError("Unavailable function called: \(#function)")
	}
}

extension AudioFormatFlag {
	@available(*, unavailable, message:"Use '.nativeFloatPacked' instead", renamed: "nativeFloatPacked")
	public static var NativeFloatPacked: AudioFormatFlag {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.float' instead", renamed: "float")
	public static var Float: AudioFormatFlag {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.bigEndian' instead", renamed: "bigEndian")
	public static var BigEndian: AudioFormatFlag {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.signedInteger' instead", renamed: "signedInteger")
	public static var SignedInteger: AudioFormatFlag {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.packed' instead", renamed: "packed")
	public static var Packed: AudioFormatFlag {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.alignedHigh' instead", renamed: "alignedHigh")
	public static var AlignedHigh: AudioFormatFlag {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.nonInterleaved' instead", renamed: "nonInterleaved")
	public static var NonInterleaved: AudioFormatFlag {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.nonMixable' instead", renamed: "nonMixable")
	public static var NonMixable: AudioFormatFlag {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.flagsAreAllClear' instead", renamed: "flagsAreAllClear")
	public static var FlagsAreAllClear: AudioFormatFlag {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.nativeEndian' instead", renamed: "nativeEndian")
	public static var NativeEndian: AudioFormatFlag {
		fatalError("Unavailable function called: \(#function)")
	}
}

extension AudioFileType {
	@available(*, unavailable, message:"Use '.unknown' instead", renamed: "unknown")
	public static var Unknown: AudioFileType {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.soundDesigner2' instead", renamed: "soundDesigner2")
	public static var SoundDesigner2: AudioFileType {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.NeXT' instead", renamed: "NeXT")
	public static var Next: AudioFileType {
		fatalError("Unavailable function called: \(#function)")
	}
}

extension AudioFormat {
	@available(*, unavailable, message:"Use '.unknown' instead", renamed: "unknown")
	public static var Unknown: AudioFormat {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.µLaw' or '.uLaw' instead", renamed: "µLaw")
	public static var ULaw: AudioFormat {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.aLaw' instead", renamed: "aLaw")
	public static var ALaw: AudioFormat {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.qDesign' instead", renamed: "qDesign")
	public static var QDesign: AudioFormat {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.qDesign2' instead", renamed: "qDesign2")
	public static var QDesign2: AudioFormat {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.audible' instead", renamed: "audible")
	public static var Audible: AudioFormat {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.timeCode' instead", renamed: "timeCode")
	public static var TimeCode: AudioFormat {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.parameterValueStream' instead", renamed: "parameterValueStream")
	public static var ParameterValueStream: AudioFormat {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.appleLossless' instead", renamed: "appleLossless")
	public static var AppleLossless: AudioFormat {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.microsoftGSM' instead", renamed: "microsoftGSM")
	public static var MicrosoftGSM: AudioFormat {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.linearPCM' instead", renamed: "linearPCM")
	public static var LinearPCM: AudioFormat {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.six0958AC3' instead", renamed: "six0958AC3")
	public static var Six0958AC3: AudioFormat {
		fatalError("Unavailable function called: \(#function)")
	}
	@available(*, unavailable, message:"Use '.appleIMA4' instead", renamed: "appleIMA4")
	public static var AppleIMA4: AudioFormat {
		fatalError("Unavailable function called: \(#function)")
	}
}

// MARK: -
