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
	if isBigEndian {
		return kLinearPCMFormatFlagIsBigEndian
	} else {
		return 0
	}
}

public enum AudioFileType: OSType {
	case Unknown			= 0
	case AIFF				= 1095321158
	case AIFC				= 1095321155
	case WAVE				= 1463899717
	case SoundDesigner2		= 1399075430
	case Next				= 1315264596
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

public func AudioFileCreate(URL inFileRef: NSURL, fileType inFileType: AudioFileType, inout format: AudioStreamBasicDescription, flags: AudioFileFlags = AudioFileFlags(rawValue: 0), inout audioFile outAudioFile: AudioFileID) -> OSStatus {
	return AudioFileCreateWithURL(inFileRef as CFURL, inFileType.rawValue, &format, flags, &outAudioFile)
}

public func AudioFileCreate(path path: String, fileType inFileType: AudioFileType, inout format: AudioStreamBasicDescription, flags: AudioFileFlags = AudioFileFlags(rawValue: 0), inout audioFile outAudioFile: AudioFileID) -> OSStatus {
	let inFileRef = NSURL(fileURLWithPath: path)
	return AudioFileCreate(URL: inFileRef, fileType: inFileType, format: &format, flags: flags, audioFile: &outAudioFile)
}

public func AudioFileOpen(URL inFileRef: NSURL, permissions: AudioFilePermissions = .ReadPermission, fileTypeHint: AudioFileType? = nil, inout audioFile outAudioFile: AudioFileID) -> OSStatus {
	return AudioFileOpenURL(inFileRef, permissions, fileTypeHint?.rawValue ?? 0, &outAudioFile)
}

public func AudioFileOpen(path path: String, permissions: AudioFilePermissions = .ReadPermission, fileTypeHint: AudioFileType? = nil, inout audioFile outAudioFile: AudioFileID) -> OSStatus {
	let inFileRef = NSURL(fileURLWithPath: path)
	return AudioFileOpen(URL: inFileRef, permissions: permissions, fileTypeHint: fileTypeHint, audioFile: &outAudioFile)
}

public func AudioFileReadBytes(audioFile audioFile: AudioFileID, useCache: Bool = false, startingByte: Int64 = 0, inout numberBytes: UInt32, buffer: UnsafeMutablePointer<Void>) -> OSStatus {
	return AudioFileReadBytes(audioFile, useCache, startingByte, &numberBytes, buffer)
}

public func AudioFileWriteBytes(audioFile audioFile: AudioFileID, useCache: Bool = false, startingByte: Int64 = 0, inout numberBytes: UInt32, buffer: UnsafePointer<Void>) -> OSStatus {
	return AudioFileWriteBytes(audioFile, useCache, startingByte, &numberBytes, buffer)
}

// MARK: Audio Format

public enum AudioFormat: OSType {
	case Unknown				= 0
	case DVIIntelIMA			= 0x6D730011
	case MicrosoftGSM			= 0x6D730031
	case LinearPCM				= 1819304813
	case AC3					= 1633889587
	case Six0958AC3				= 1667326771
	case AppleIMA4				= 1768775988
	case MPEG4AAC				= 1633772320
	case MPEG4CELP				= 1667591280
	case MPEG4HVXC				= 1752594531
	case MPEG4TwinVQ			= 1953986161
	case MACE3					= 1296122675
	case MACE6					= 1296122678
	case ULaw					= 1970037111
	case ALaw					= 1634492791
	case QDesign				= 1363430723
	case QDesign2				= 1363430706
	case QUALCOMM				= 1365470320
	case MPEGLayer1				= 778924081
	case MPEGLayer2				= 778924082
	case MPEGLayer3				= 778924083
	case TimeCode				= 1953066341
	case MIDIStream				= 1835623529
	case ParameterValueStream	= 1634760307
	case AppleLossless			= 1634492771
	case MPEG4AAC_HE			= 1633772392
	case MPEG4AAC_LD			= 1633772396
	case MPEG4AAC_ELD			= 1633772389
	case MPEG4AAC_ELD_SBR		= 1633772390
	case MPEG4AAC_ELD_V2		= 1633772391
	case MPEG4AAC_HE_V2			= 1633772400
	case MPEG4AAC_Spatial		= 1633772403
	case AMR					= 1935764850
	case AMR_WB					= 1935767394
	case Audible				= 1096107074
	case iLBC					= 1768710755
	case AES3					= 1634038579
	
	public var stringValue: String {
		return OSTypeToString(self.rawValue) ?? "    "
	}
}

public struct AudioFormatFlag : OptionSetType {
	public let rawValue: UInt32

	public init(rawValue value: UInt32) { self.rawValue = value }
	public static var NativeFloatPacked: AudioFormatFlag {
		return [Float, NativeEndian, Packed]
	}

	public static let Float				= AudioFormatFlag(rawValue: 1 << 0)
	public static let BigEndian			= AudioFormatFlag(rawValue: 1 << 1)
	public static let SignedInteger		= AudioFormatFlag(rawValue: 1 << 2)
	public static let Packed			= AudioFormatFlag(rawValue: 1 << 3)
	public static let AlignedHigh		= AudioFormatFlag(rawValue: 1 << 4)
	public static let NonInterleaved	= AudioFormatFlag(rawValue: 1 << 5)
	public static let NonMixable		= AudioFormatFlag(rawValue: 1 << 6)
	public static let FlagsAreAllClear	= AudioFormatFlag(rawValue: 1 << 31)
	public static var NativeEndian: AudioFormatFlag {
		if isLittleEndian {
			return self.init(rawValue: 0)
		} else {
			return BigEndian
		}
	}
}

public struct LinearPCMFormatFlag : OptionSetType {
	public let rawValue: UInt32

	public init(rawValue value: UInt32) { self.rawValue = value }
	public static var NativeFloatPacked: LinearPCMFormatFlag {
		return [Float, NativeEndian, Packed]
	}
	
	public static var Float			= LinearPCMFormatFlag(rawValue: 1 << 0)
	public static var BigEndian		= LinearPCMFormatFlag(rawValue: 1 << 1)
	public static var SignedInteger	= LinearPCMFormatFlag(rawValue: 1 << 2)
	public static var Packed			= LinearPCMFormatFlag(rawValue: 1 << 3)
	public static var AlignedHigh		= LinearPCMFormatFlag(rawValue: 1 << 4)
	public static var NonInterleaved	= LinearPCMFormatFlag(rawValue: 1 << 5)
	public static var NonMixable		= LinearPCMFormatFlag(rawValue: 1 << 6)
	public static var FlagsAreAllClear	= LinearPCMFormatFlag(rawValue: 1 << 31)
	public static var NativeEndian:		LinearPCMFormatFlag {
		if isLittleEndian {
			return self.init(rawValue: 0)
		} else {
			return BigEndian
		}
	}
	public static var FlagsSampleFractionShift: LinearPCMFormatFlag { return self.init(rawValue: 7) }
	public static var FlagsSampleFractionMask : LinearPCMFormatFlag { return self.init(rawValue: 0x3F << FlagsSampleFractionShift.rawValue) }
}

public extension AudioStreamBasicDescription {
	
	/// Is the current `AudioStreamBasicDescription` in the native endian format?
	///
	/// - returns: `true` if the audio is in the native endian, `false` if not, and `nil` if the `formatID` isn't `.LinearPCM`.
	public var audioFormatNativeEndian: Bool? {
		if (formatID == .LinearPCM) {
			let ourFlags = formatFlags.intersect(.BigEndian)
			if ourFlags == .NativeEndian {
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
				return .Unknown
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
	
	public init(sampleRate: Float64, formatID: AudioFormat = .LinearPCM, formatFlags: AudioFormatFlag = .NativeFloatPacked, bitsPerChannel: UInt32, channelsPerFrame: UInt32, framesPerPacket: UInt32 = 1) {
		mSampleRate = sampleRate
		mFormatID = formatID.rawValue
		mFormatFlags = formatFlags.rawValue
		mBitsPerChannel = bitsPerChannel
		mChannelsPerFrame = channelsPerFrame
		mFramesPerPacket = framesPerPacket
		mBytesPerFrame = mBitsPerChannel * mChannelsPerFrame / 8
		mBytesPerPacket = mBytesPerFrame * mFramesPerPacket
		mReserved = 0
	}
	
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
	
	// The following getters/functions are from Apple's CoreAudioUtilityClasses
	
	var	PCM: Bool {
		return mFormatID == kAudioFormatLinearPCM
	}

	public var interleaved: Bool {
		return !formatFlags.contains(.NonInterleaved)
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
	
	public enum ASBDError: ErrorType {
		case ReqiresPCMFormat
	}
	
	public mutating func changeCountOfChannels(nChannels: UInt32, interleaved: Bool) throws {
		guard PCM else {
			throw ASBDError.ReqiresPCMFormat
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
			formatFlags.remove(.NonInterleaved)
		} else {
			let newBytes = wordSize
			mBytesPerPacket = newBytes
			mBytesPerFrame = newBytes
			formatFlags.insert(.NonInterleaved)
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
		
		if charIterator == fromText.endIndex {
			return nil
		}
		
		self.init()
		
		var isPCM = true;	// until proven otherwise
		var pcmFlags = kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger;
		
		if (fromText[charIterator] == "-") {	// previously we required a leading dash on PCM formats
			charIterator = charIterator.successor();
		}
		
		if fromText[charIterator] == "B" && fromText[charIterator.successor()] == "E" {
			pcmFlags |= kLinearPCMFormatFlagIsBigEndian;
			charIterator = charIterator.advancedBy(2)
		} else if fromText[charIterator] == "L" && fromText[charIterator.successor()] == "E" {
			charIterator = charIterator.advancedBy(2)
		} else {
			// default is native-endian
			if isBigEndian {
				pcmFlags |= kLinearPCMFormatFlagIsBigEndian;
			}
		}
		if nextChar() == "F" {
			pcmFlags = (pcmFlags & ~kAudioFormatFlagIsSignedInteger) | kAudioFormatFlagIsFloat
			charIterator = charIterator.successor();
		} else {
			if nextChar() == "U" {
				pcmFlags &= ~kAudioFormatFlagIsSignedInteger;
				charIterator = charIterator.successor();
			}
			if nextChar() == "I" {
				charIterator = charIterator.successor();
			} else {
				// it's not PCM; presumably some other format (NOT VALIDATED; use AudioFormat for that)
				isPCM = false;
				charIterator = fromText.startIndex;	// go back to the beginning
				var buf = Array<Int8>(count: 4, repeatedValue: 0x20);
				for (i, var aBuf) in buf.enumerate() {
					if nextChar() != "\\" {
						let wasAdvanced: Bool
						if let cChar = nextChar() {
							let bBuf = String(cChar).cStringUsingEncoding(NSMacOSRomanStringEncoding) ?? [0]
							aBuf = bBuf[0]
							charIterator = charIterator.successor()
							wasAdvanced = true
						} else {
							aBuf = 0
							wasAdvanced = false
						}
						buf[i] = aBuf
						
						if aBuf == 0 {
							// special-case for 'aac'
							if (i != 3) {
								return nil;
							}
							if wasAdvanced {
								charIterator = charIterator.predecessor();	// keep pointing at the terminating null
							}
							aBuf = 0x20;
							buf[i] = aBuf
							break;
						}
					} else {
						// "\xNN" is a hex byte
						charIterator = charIterator.successor()
						if (nextChar() != "x") {
							return nil;
						}
						var x: Int32 = 0
						
						if (withVaList([withUnsafeMutablePointer(&x, {return $0})], { (vaPtr) -> Int32 in
							charIterator = charIterator.successor()
							let str = fromText[charIterator ..< fromText.endIndex]
							return vsscanf(str, "%02X", vaPtr)
						}) != 1) {
							return nil
						}
						
						aBuf = Int8(truncatingBitPattern: x)
						buf[i] = aBuf
						charIterator = charIterator.advancedBy(2)
					}
				}
				
				if strchr("-@/#", Int32(buf[3])) != nil {
					// further special-casing for 'aac'
					buf[3] = 0x20;
					charIterator = charIterator.predecessor();
				}
				
				memcpy(&mFormatID, buf, 4);
				mFormatID = CFSwapInt32BigToHost(mFormatID);
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
				charIterator = charIterator.successor();
			}
			if (nextChar() == ".") {
				charIterator = charIterator.successor();
				guard let _ = numFromCurrentChar() else {
					print("Expected fractional bits following '.'");
					return nil;
				}
				while let aNum = numFromCurrentChar() {
					fracbits = 10 * fracbits + UInt32(aNum)
					charIterator = charIterator.successor();
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
			charIterator = charIterator.successor();
			while let aNum = numFromCurrentChar() {
				mSampleRate = 10 * mSampleRate + Float64(aNum)
				charIterator = charIterator.successor();
			}
		}
		if nextChar() == "/" {
			var flags: UInt32 = 0;
			while true {
				charIterator = charIterator.successor()
				guard charIterator < fromText.endIndex else {
					break
				}
				guard let bChar = ASCIICharacter(swiftCharacter: fromText[charIterator]) else {
					break
				}
				//Int(hex)
				
				if (bChar >= ASCIICharacter.NumberZero && bChar <= ASCIICharacter.NumberNine) {
					flags = (flags << 4) | UInt32(bChar.rawValue - ASCIICharacter.NumberZero.rawValue);
				} else if (bChar >= ASCIICharacter.LetterUppercaseA && bChar <= ASCIICharacter.LetterUppercaseF) {
					flags = (flags << 4) | UInt32(bChar.rawValue - ASCIICharacter.LetterUppercaseA.rawValue + 10);
				} else if (bChar >= ASCIICharacter.LetterLowercaseA && bChar <= ASCIICharacter.LetterLowercaseF) {
					flags = (flags << 4) | UInt32(bChar.rawValue - ASCIICharacter.LetterLowercaseA.rawValue + 10);
				} else {
					break;
				}
			}
			mFormatFlags = flags;
		}
		if (nextChar() == "#") {
			charIterator = charIterator.successor()
			while let aNum = numFromCurrentChar() {
				mFramesPerPacket = 10 * mFramesPerPacket + UInt32(aNum)
				charIterator = charIterator.successor();
			}
		}
		if nextChar() == ":" {
			charIterator = charIterator.successor()
			mFormatFlags &= ~kLinearPCMFormatFlagIsPacked
			if (fromText[charIterator] == "L") {
				mFormatFlags &= ~kLinearPCMFormatFlagIsAlignedHigh
			} else if (fromText[charIterator] == "H") {
				mFormatFlags |= kLinearPCMFormatFlagIsAlignedHigh;
			} else {
				return nil;
			}
			charIterator = charIterator.successor()
			var bytesPerFrame: UInt32 = 0;
			while let aNum = numFromCurrentChar() {
				bytesPerFrame = 10 * bytesPerFrame + UInt32(aNum)
				charIterator = charIterator.successor();
			}
			mBytesPerPacket = bytesPerFrame
			mBytesPerFrame = mBytesPerPacket
		}
		if nextChar() == "," {
			charIterator = charIterator.successor()
			var ch = 0;
			while let aNum = numFromCurrentChar() {
				ch = 10 * ch + aNum
				charIterator = charIterator.successor();
			}
			mChannelsPerFrame = UInt32(ch);
			if nextChar() == "D" {
				charIterator = charIterator.successor()
				guard mFormatID == kAudioFormatLinearPCM else {
					print("non-interleaved flag invalid for non-PCM formats\n");
					return nil;
				}
				mFormatFlags |= kAudioFormatFlagIsNonInterleaved;
			} else {
				if nextChar() == "I" {
					charIterator = charIterator.successor()
				}	// default
				if mFormatID == kAudioFormatLinearPCM {
					mBytesPerFrame *= UInt32(ch)
					mBytesPerPacket = mBytesPerFrame
				}
			}
		}
		if (charIterator != fromText.endIndex) {
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
