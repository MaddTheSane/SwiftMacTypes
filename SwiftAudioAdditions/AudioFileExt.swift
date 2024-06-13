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

/// Defined to set or clear `kAudioFormatFlagIsBigEndian` depending on the
/// endianness of the processor at build time.
@inlinable public var kLinearPCMFormatFlagNativeEndian: AudioFormatFlags {
	#if _endian(big)
		return kLinearPCMFormatFlagIsBigEndian
	#else
		return 0
	#endif
}

public enum AudioFileType: OSType, OSTypeConvertable, Hashable, @unchecked Sendable, Equatable {
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
}

/// Creates a new audio file, or initializes an existing file, specified by a URL.
/// - parameter inFileRef: The fully specified path of the file to create or initialize.
/// - parameter inFileType: The type of audio file to create. See `AudioFileTypeID` for constants that can be used.
/// - parameter format: A pointer to the structure that describes the format of the data.
/// - parameter flags: Relevant flags for creating or opening the file. If `eraseFile` is set, it erases an existing file. If the flag is not set, the function fails if the URL is an existing file.
/// - parameter outAudioFile: On output, a pointer to a newly created or initialized file.
/// - returns: A result code.
///
/// This function uses a `URL` type rather than the `FSRef` type used by the deprecated `AudioFileCreate` function.
public func AudioFileCreate(url inFileRef: URL, fileType inFileType: AudioFileType, format: inout AudioStreamBasicDescription, flags: AudioFileFlags = AudioFileFlags(rawValue: 0), audioFile outAudioFile: inout AudioFileID?) -> OSStatus {
	return AudioFileCreateWithURL(inFileRef as NSURL, inFileType.rawValue, &format, flags, &outAudioFile)
}

/// Creates a new audio file, or initializes an existing file, specified by a string path.
/// - parameter inFileType: The type of audio file to create. See `AudioFileTypeID` for constants that can be used.
/// - parameter format: A pointer to the structure that describes the format of the data.
/// - parameter flags: Relevant flags for creating or opening the file. If `eraseFile` is set, it erases an existing file. If the flag is not set, the function fails if the URL is an existing file.
/// - parameter outAudioFile: On output, a pointer to a newly created or initialized file.
/// - returns: A result code.
public func AudioFileCreate(path: String, fileType inFileType: AudioFileType, format: inout AudioStreamBasicDescription, flags: AudioFileFlags = AudioFileFlags(rawValue: 0), audioFile outAudioFile: inout AudioFileID?) -> OSStatus {
	let inFileRef = URL(fileURLWithPath: path)
	return AudioFileCreate(url: inFileRef, fileType: inFileType, format: &format, flags: flags, audioFile: &outAudioFile)
}

/// Open an existing audio file specified by a URL.
/// - parameter inFileRef: The URL of an existing audio file.
/// - parameter permissions: The read-write permissions you want to assign to the file. Use the permission constants in AudioFilePermissions.
/// - parameter fileTypeHint: A hint for the file type of the designated file. For files without filename extensions and with types not easily or uniquely determined from the data (such as ADTS or AC3), use this hint to indicate the file type. Otherwise, pass 0. Only use this hint in macOS versions 10.3.1 or greater. In all earlier versions, any attempt to open these files fails.
/// - parameter outAudioFile: On output, a pointer to the newly opened audio file.
/// - returns: A result code.
public func AudioFileOpen(url inFileRef: URL, permissions: AudioFilePermissions = .readPermission, fileTypeHint: AudioFileType? = nil, audioFile outAudioFile: inout AudioFileID?) -> OSStatus {
	return AudioFileOpenURL(inFileRef as NSURL, permissions, fileTypeHint?.rawValue ?? 0, &outAudioFile)
}

/// - returns: A result code.
public func AudioFileOpen(path: String, permissions: AudioFilePermissions = .readPermission, fileTypeHint: AudioFileType? = nil, audioFile outAudioFile: inout AudioFileID?) -> OSStatus {
	let inFileRef = URL(fileURLWithPath: path)
	return AudioFileOpen(url: inFileRef, permissions: permissions, fileTypeHint: fileTypeHint, audioFile: &outAudioFile)
}

/// Reads bytes of audio data from an audio file.
/// - parameter audioFile: The audio file whose bytes of audio data you want to read.
/// - parameter useCache: Set to `true` if you want to cache the data. You should cache reads and writes if you read or write the same portion of a file multiple times. To request that the data not be cached, if possible, set to `false`. You should not cache reads and writes if you read or write data from a file only once.
/// - parameter startingByte: The byte offset of the audio data you want to be returned.
/// - parameter numberBytes: On input, a pointer to the number of bytes to read. On output, a pointer to the number of bytes actually read.
/// - parameter buffer: A pointer to user-allocated memory large enough for the requested bytes.
/// - returns: A result code.
///
/// In most cases, you should use `AudioFileReadPackets(_:_:_:_:_:_:_:)` instead of this function.
///
/// This function returns `eofErr` when the read operation encounters the end of the file. Note that Audio File Services only reads one 32-bit chunk of a file at a time.
public func AudioFileReadBytes(audioFile: AudioFileID, useCache: Bool = false, startingByte: Int64 = 0, numberBytes: inout UInt32, buffer: UnsafeMutableRawPointer) -> OSStatus {
	return AudioFileReadBytes(audioFile, useCache, startingByte, &numberBytes, buffer)
}

/// Writes bytes of audio data to an audio file.
/// - parameter audioFile: The audio file to which you want to write bytes of data.
/// - parameter useCache: Set to `true` if you want to cache the data. Otherwise, set to `false`.
/// - parameter startingByte: The byte offset where the audio data should be written.
/// - parameter numberBytes: On input, a pointer the number of bytes to write. On output, a pointer to the number of bytes actually written.
/// - parameter buffer: A pointer to a buffer containing the bytes to be written.
/// - returns: A result code.
///
/// In most cases, you should use `AudioFileWritePackets(_:_:_:_:_:_:_:)` instead of this function.
public func AudioFileWriteBytes(audioFile: AudioFileID, useCache: Bool = false, startingByte: Int64 = 0, numberBytes: inout UInt32, buffer: UnsafeRawPointer) -> OSStatus {
	return AudioFileWriteBytes(audioFile, useCache, startingByte, &numberBytes, buffer)
}

// MARK: Audio Format

public enum AudioFormat: OSType, OSTypeConvertable, Hashable, @unchecked Sendable, Equatable {
	case unknown				= 0
	/// DVI/Intel IMA ADPCM - ACM code 17.
	case DVIIntelIMA			= 0x6D730011
	/// Microsoft GSM 6.10 - ACM code 49.
	case microsoftGSM			= 0x6D730031
	/// A key that specifies linear PCM, a noncompressed audio data format with one frame per packet.
	case linearPCM				= 1819304813
	/// A key that specifies an AC-3 codec. Uses no flags.
	case AC3					= 1633889587
	/// AC-3 packaged for transport over an IEC 60958 compliant digital audio
	/// interface. Uses the standard flags.
	case six0958AC3				= 1667326771
	/// A key that specifies Apple’s implementation of the IMA 4:1 ADPCM codec. Uses no flags.
	case appleIMA4				= 1768775988
	/// A key that specifies an MPEG-4 AAC codec.
	case MPEG4AAC				= 1633772320
	/// A key that specifies an MPEG-4 CELP codec.
	case MPEG4CELP				= 1667591280
	/// A key that specifies an MPEG-4 HVXC codec.
	case MPEG4HVXC				= 1752594531
	/// A key that specifies an MPEG-4 TwinVQ codec.
	case MPEG4TwinVQ			= 1953986161
	/// MACE 3:1. Uses no flags.
	case MACE3					= 1296122675
	/// MACE 6:1. Uses no flags.
	case MACE6					= 1296122678
	/// μLaw 2:1. Uses no flags.
	case µLaw					= 1970037111
	/// aLaw 2:1. Uses no flags.
	case aLaw					= 1634492791
	/// QDesign music. Uses no flags
	case qDesign				= 1363430723
	/// QDesign2 music. Uses no flags
	case qDesign2				= 1363430706
	/// QUALCOMM PureVoice. Uses no flags
	case QUALCOMM				= 1365470320
	/// MPEG-1/2, Layer 1 audio. Uses no flags
	case MPEGLayer1				= 778924081
	/// MPEG-1/2, Layer 2 audio. Uses no flags
	case MPEGLayer2				= 778924082
	/// MPEG-1/2, Layer 3 audio. Uses no flags
	case MPEGLayer3				= 778924083
	/// A stream of `IOAudioTimeStamp` structures. Uses the `IOAudioTimeStamp` flags.
	case timeCode				= 1953066341
	/// A stream of MIDIPacketLists where the time stamps in the MIDIPacketList are
	/// sample offsets in the stream.
	///
	/// The `mSampleRate` field is used to describe how
	/// time is passed in this kind of stream and an AudioUnit that receives or
	/// generates this stream can use this sample rate, the number of frames it is
	/// rendering and the sample offsets within the MIDIPacketList to define the
	/// time for any MIDI event within this list. It has no flags.
	case MIDIStream				= 1835623529
	/// A "side-chain" of `Float32` data that can be fed or generated by an AudioUnit
	/// and is used to send a high density of parameter value control information.
	///
	/// An AU will typically run a `ParameterValueStream` at either the sample rate of
	/// the AudioUnit's audio data, or some integer divisor of this (say a half or a
	/// third of the sample rate of the audio). The Sample Rate of the ASBD
	/// describes this relationship. It has no flags.
	case parameterValueStream	= 1634760307
	/// Apple Lossless. Uses no flags.
	case appleLossless			= 1634492771
	/// MPEG-4 High Efficiency AAC audio object. Uses no flags.
	case MPEG4AAC_HE			= 1633772392
	/// MPEG-4 AAC Low Delay audio object. Uses no flags.
	case MPEG4AAC_LD			= 1633772396
	/// MPEG-4 AAC Enhanced Low Delay audio object. Uses no flags.
	case MPEG4AAC_ELD			= 1633772389
	/// MPEG-4 AAC Enhanced Low Delay audio object with SBR (spectral band replication) extension layer. Uses no flags.
	case MPEG4AAC_ELD_SBR		= 1633772390
	case MPEG4AAC_ELD_V2		= 1633772391
	/// MPEG-4 High Efficiency AAC Version 2 audio object. Uses no flags.
	case MPEG4AAC_HE_V2			= 1633772400
	/// MPEG-4 Spatial Audio audio object. Uses no flags.
	case MPEG4AAC_Spatial		= 1633772403
	/// The AMR (Adaptive Multi-Rate) narrow band speech codec.
	case AMR					= 1935764850
	/// The AMR (Adaptive Multi-Rate) Wide Band speech codec.
	case AMR_WB					= 1935767394
	/// The codec used for Audible, Inc. audio books. Uses no flags.
	case audible				= 1096107074
	/// The iLBC (internet Low Bitrate Codec) narrow band speech codec. Uses no flags.
	case iLBC					= 1768710755
	/// The format defined by the AES3-2003 standard. Adopted into MXF and MPEG-2 containers and SDTI transport streams with SMPTE specs 302M-2002 and 331M-2000. Uses no flags.
	case AES3					= 1634038579
	/// Enhanced AC-3, has no flags.
	case enhancedAC3 			= 1700998451
	/// Opus codec, has no flags.
	case opus					= 1869641075
	/// Free Lossless Audio Codec, the flags indicate the bit depth of the source material.
	case FLAC					= 1718378851
	
	/// μLaw 2:1. Use `.µLaw` instead.
	@available(*, deprecated, renamed: "µLaw")
	public static var uLaw: AudioFormat {
		return .µLaw
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
			return .bigEndian
		#else
			fatalError("Unknown endianness")
		#endif
	}
}

private func calculateLPCMFlags(validBitsPerChannel inValidBitsPerChannel: UInt32, totalBitsPerChannel inTotalBitsPerChannel: UInt32, isFloat inIsFloat: Bool, isBigEndian inIsBigEndian: Bool, isNonInterleaved inIsNonInterleaved: Bool = false) -> AudioFormatFlags {
	return (inIsFloat ? kAudioFormatFlagIsFloat : kAudioFormatFlagIsSignedInteger) | (inIsBigEndian ? ((UInt32)(kAudioFormatFlagIsBigEndian)) : 0) | ((inValidBitsPerChannel == inTotalBitsPerChannel) ? kAudioFormatFlagIsPacked : kAudioFormatFlagIsAlignedHigh) | (inIsNonInterleaved ? ((UInt32)(kAudioFormatFlagIsNonInterleaved)) : 0)
	
}

public extension AudioStreamBasicDescription {
	init(lpcmSampleRate inSampleRate: Float64, channelsPerFrame inChannelsPerFrame: UInt32, validBitsPerChanel inValidBitsPerChannel: UInt32, totalBitsPerChannel inTotalBitsPerChannel: UInt32, isFloat inIsFloat: Bool, isBigEndian inIsBigEndian: Bool, isNonInterleaved inIsNonInterleaved: Bool = false) {
		let formatFlags = calculateLPCMFlags(validBitsPerChannel: inValidBitsPerChannel, totalBitsPerChannel: inTotalBitsPerChannel, isFloat: inIsFloat, isBigEndian: inIsBigEndian, isNonInterleaved: inIsNonInterleaved)
		let bytesPerPacket = (inIsNonInterleaved ? 1 : inChannelsPerFrame) * (inTotalBitsPerChannel / 8)
		let bytesPerFrame = (inIsNonInterleaved ? 1 : inChannelsPerFrame) * (inTotalBitsPerChannel / 8)
		self.init(mSampleRate: inSampleRate, mFormatID: kAudioFormatLinearPCM, mFormatFlags: formatFlags, mBytesPerPacket: bytesPerPacket, mFramesPerPacket: 1, mBytesPerFrame: bytesPerFrame, mChannelsPerFrame: inChannelsPerFrame, mBitsPerChannel: inValidBitsPerChannel, mReserved: 0)
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
			return .bigEndian
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
	var audioFormatNativeEndian: Bool? {
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
	
	var formatID: AudioFormat {
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
	
	var formatFlags: AudioFormatFlag {
		get {
			return AudioFormatFlag(rawValue: mFormatFlags)
		}
		set {
			mFormatFlags = newValue.rawValue
		}
	}
	
	init(sampleRate: Float64, formatID: AudioFormat = .linearPCM, formatFlags: AudioFormatFlag = .nativeFloatPacked, bitsPerChannel: UInt32, channelsPerFrame: UInt32, framesPerPacket: UInt32 = 1) {
		let bytesPerFrame = bitsPerChannel * channelsPerFrame / 8
		self.init(mSampleRate: sampleRate, mFormatID: formatID.rawValue, mFormatFlags: formatFlags.rawValue, mBytesPerPacket: bytesPerFrame * framesPerPacket, mFramesPerPacket: framesPerPacket, mBytesPerFrame: bytesPerFrame, mChannelsPerFrame: channelsPerFrame, mBitsPerChannel: bitsPerChannel, mReserved: 0)
	}
	
	init(sampleRate: Float64, formatID: AudioFormatID, formatFlags: AudioFormatFlags, bitsPerChannel: UInt32, channelsPerFrame: UInt32, framesPerPacket: UInt32 = 1) {
		let bytesPerFrame = bitsPerChannel * channelsPerFrame / 8
		self.init(mSampleRate: sampleRate, mFormatID: formatID, mFormatFlags: formatFlags, mBytesPerPacket: bytesPerFrame * framesPerPacket, mFramesPerPacket: framesPerPacket, mBytesPerFrame: bytesPerFrame, mChannelsPerFrame: channelsPerFrame, mBitsPerChannel: bitsPerChannel, mReserved: 0)
	}
}

public extension AudioStreamBasicDescription {
	// The following getters/functions are from Apple's CoreAudioUtilityClasses
	
	@inlinable var isPCM: Bool {
		return mFormatID == kAudioFormatLinearPCM
	}

	@inlinable var isInterleaved: Bool {
		return !isPCM || !formatFlags.contains(.nonInterleaved)
	}
	
	@inlinable var isSignedInteger: Bool {
		return isPCM && (mFormatFlags & kAudioFormatFlagIsSignedInteger) != 0
	}
	
	@inlinable var isFloat: Bool {
		return isPCM && (mFormatFlags & kAudioFormatFlagIsFloat) != 0
	}

	@available(*, unavailable, renamed: "isInterleaved")
	var interleaved: Bool {
		return isInterleaved
	}
	
	@available(*, deprecated, renamed: "isSignedInteger")
	var signedInteger: Bool {
		return isSignedInteger
	}
	
	@available(*, deprecated, renamed: "isFloat")
	var float: Bool {
		return isFloat
	}
	
	var interleavedChannels: UInt32 {
		return isInterleaved ? mChannelsPerFrame : 1
	}
	
	var channelStreams: UInt32 {
		return isInterleaved ? 1 : mChannelsPerFrame
	}
	
	func framesToBytes(_ nframes: UInt32) -> UInt32 {
		return nframes * mBytesPerFrame
	}
	
	var sampleWordSize: UInt32 {
		return (mBytesPerFrame > 0 && interleavedChannels != 0) ? mBytesPerFrame / interleavedChannels : 0
	}
	
	/// The audio format must be PCM, otherwise this won't work!
	var isPackednessSignificant: Bool {
		precondition(isPCM, "isPackednessSignificant only applies for PCM")
		return (sampleWordSize << 3) != mBitsPerChannel
	}
	
	/// The audio format must be PCM, otherwise this won't work!
	var isAlignmentSignificant: Bool {
		return isPackednessSignificant || (mBitsPerChannel & 7) != 0
	}
	
	enum ASBDError: Error, CustomStringConvertible {
		case reqiresPCMFormat
		case extraCharactersAtEnd(Substring)
		case expectedFractionalBits
		case unexpectedEndOfString
		case invalidFormat
		case invalidInterleavedFlag
		
		public var description: String {
			switch self {
			case .expectedFractionalBits:
				return "Expected fractional bits following '.'"
				
			case .extraCharactersAtEnd(let hi):
				return "extra characters at end of format string: \(hi)"
				
			case .invalidInterleavedFlag:
				return "non-interleaved flag invalid for non-PCM formats"
				
			case .reqiresPCMFormat:
				return "Format was expected to be PCM"
				
			case .unexpectedEndOfString:
				return "Unexpected end of string reached"
				
			case .invalidFormat:
				return "Invalid format"
			}
		}
	}
	
	mutating func changeCountOfChannels(nChannels: UInt32, interleaved: Bool) throws {
		guard isPCM else {
			throw ASBDError.reqiresPCMFormat
		}
		let wordSize: UInt32 = { // get this before changing ANYTHING
			var ws = sampleWordSize
			if ws == 0 {
				ws = (mBitsPerChannel + 7) / 8
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
	func checkSanity() -> Bool {
		return
			(mSampleRate >= 0)
				&& (mSampleRate < 3e6)	// SACD sample rate is 2.8224 MHz
				&& (mBytesPerPacket < 1000000)
				&& (mFramesPerPacket < 1000000)
				&& (mBytesPerFrame < 1000000)
				&& (mChannelsPerFrame <= 1024)
				&& (mBitsPerChannel <= 1024)
				&& (mFormatID != 0)
				&& !(mFormatID == kAudioFormatLinearPCM && (mFramesPerPacket != 1 || mBytesPerPacket != mBytesPerFrame))
	}
	
	///	format[@sample_rate_hz][/format_flags][#frames_per_packet][:LHbytesPerFrame][,channelsDI].
	///
	/// Format for PCM is *[-][BE|LE]{F|I|UI}{bitdepth}*; else a 4-char format code (e.g. `aac`, `alac`).
	init(fromText: String) throws {
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
			throw ASBDError.unexpectedEndOfString
		}
		
		self.init()
		
		var isPCM = true	// until proven otherwise
		var pcmFlags = kAudioFormatFlagIsPacked | kAudioFormatFlagIsSignedInteger
		
		if fromText[charIterator] == "-" {	// previously we required a leading dash on PCM formats
			fromText.formIndex(after: &charIterator)
		}
		
		if fromText[charIterator] == "B" && fromText[fromText.index(after: charIterator)] == "E" {
			pcmFlags |= kLinearPCMFormatFlagIsBigEndian
			fromText.formIndex(&charIterator, offsetBy: 2)
		} else if fromText[charIterator] == "L" && fromText[fromText.index(after: charIterator)] == "E" {
			fromText.formIndex(&charIterator, offsetBy: 2)
		} else {
			// default is native-endian
			pcmFlags |= kLinearPCMFormatFlagNativeEndian
		}
		if nextChar() == "F" {
			pcmFlags = (pcmFlags & ~kAudioFormatFlagIsSignedInteger) | kAudioFormatFlagIsFloat
			fromText.formIndex(after: &charIterator)
		} else {
			if nextChar() == "U" {
				pcmFlags &= ~kAudioFormatFlagIsSignedInteger
				fromText.formIndex(after: &charIterator)
			}
			if nextChar() == "I" {
				fromText.formIndex(after: &charIterator)
			} else {
				// it's not PCM; presumably some other format (NOT VALIDATED; use AudioFormat for that)
				isPCM = false
				charIterator = fromText.startIndex	// go back to the beginning
				var buf = Array<Int8>(repeating: 0x20, count: 4)
				for (i, var aBuf) in buf.enumerated() {
					if nextChar() != "\\" {
						let wasAdvanced: Bool
						if let cChar = nextChar() {
							let bBuf = String(cChar).cString(using: .macOSRoman) ?? [0]
							aBuf = bBuf[0]
							fromText.formIndex(after: &charIterator)
							wasAdvanced = true
						} else {
							aBuf = 0
							wasAdvanced = false
						}
						buf[i] = aBuf
						
						if aBuf == 0 {
							// special-case for 'aac'
							if i != 3 {
								throw ASBDError.invalidFormat
							}
							if wasAdvanced {
								fromText.formIndex(before: &charIterator)	// keep pointing at the terminating null
							}
							aBuf = 0x20
							buf[i] = aBuf
							break
						}
					} else {
						// "\xNN" is a hex byte
						fromText.formIndex(after: &charIterator)
						if nextChar() != "x" {
							throw ASBDError.invalidFormat
						}
						var x: Int32 = 0
						
						//TODO: use Scanner
						if (withVaList([withUnsafeMutablePointer(to: &x, {return $0})], { (vaPtr) -> Int32 in
							fromText.formIndex(after: &charIterator)
							let str = fromText[charIterator ..< fromText.endIndex]
							return str.withCString({ (cStr) -> Int32 in
								return vsscanf(cStr, "%02X", vaPtr)
							})
						}) != 1) {
							throw ASBDError.invalidFormat
						}
						
						aBuf = Int8(truncatingIfNeeded: x)
						buf[i] = aBuf
						charIterator = fromText.index(charIterator, offsetBy: 2)
					}
				}
				
				if strchr("-@/#", Int32(buf[3])) != nil {
					// further special-casing for 'aac'
					buf[3] = 0x20
					fromText.formIndex(before: &charIterator)
				}
				
				memcpy(&mFormatID, buf, 4)
				mFormatID = mFormatID.bigEndian
			}
		}
		
		if isPCM {
			mFormatID = kAudioFormatLinearPCM
			mFormatFlags = pcmFlags
			mFramesPerPacket = 1
			mChannelsPerFrame = 1
			var bitdepth: UInt32 = 0
			var fracbits: UInt32 = 0
			while let aNum = numFromCurrentChar() {
				bitdepth = 10 * bitdepth + UInt32(aNum)
				fromText.formIndex(after: &charIterator)
			}
			if nextChar() == "." {
				fromText.formIndex(after: &charIterator)
				guard let _ = numFromCurrentChar() else {
					throw ASBDError.expectedFractionalBits
				}
				while let aNum = numFromCurrentChar() {
					fracbits = 10 * fracbits + UInt32(aNum)
					fromText.formIndex(after: &charIterator)
				}
				bitdepth += fracbits
				mFormatFlags |= (fracbits << kLinearPCMFormatFlagsSampleFractionShift)
			}
			mBitsPerChannel = bitdepth
			mBytesPerFrame = (bitdepth + 7) / 8
			mBytesPerPacket = mBytesPerFrame
			if (bitdepth & 7) != 0 {
				// assume unpacked. (packed odd bit depths are describable but not supported in AudioConverter.)
				mFormatFlags &= ~kLinearPCMFormatFlagIsPacked
				// alignment matters; default to high-aligned. use ':L_' for low.
				mFormatFlags |= kLinearPCMFormatFlagIsAlignedHigh
			}
		}
		if nextChar() == "@" {
			fromText.formIndex(after: &charIterator)
			while let aNum = numFromCurrentChar() {
				mSampleRate = 10 * mSampleRate + Float64(aNum)
				fromText.formIndex(after: &charIterator)
			}
		}
		if nextChar() == "/" {
			var flags: UInt32 = 0
			while true {
				fromText.formIndex(after: &charIterator)
				guard charIterator < fromText.endIndex,
					let bChar = ASCIICharacter(swiftCharacter: fromText[charIterator]) else {
						break
				}
				//Int(hex)
				
				if (ASCIICharacter.numberZero ... ASCIICharacter.numberNine).contains(bChar) {
					flags = (flags << 4) | UInt32(bChar.rawValue - ASCIICharacter.numberZero.rawValue)
				} else if (ASCIICharacter.letterUppercaseA ... ASCIICharacter.letterUppercaseF).contains(bChar) {
					flags = (flags << 4) | UInt32(bChar.rawValue - ASCIICharacter.letterUppercaseA.rawValue + 10)
				} else if (ASCIICharacter.letterLowercaseA ... ASCIICharacter.letterLowercaseF).contains(bChar) {
					flags = (flags << 4) | UInt32(bChar.rawValue - ASCIICharacter.letterLowercaseA.rawValue + 10)
				} else {
					break
				}
			}
			mFormatFlags = flags
		}
		if nextChar() == "#" {
			fromText.formIndex(after: &charIterator)
			while let aNum = numFromCurrentChar() {
				mFramesPerPacket = 10 * mFramesPerPacket + UInt32(aNum)
				fromText.formIndex(after: &charIterator)
			}
		}
		if nextChar() == ":" {
			fromText.formIndex(after: &charIterator)
			mFormatFlags &= ~kLinearPCMFormatFlagIsPacked
			if fromText[charIterator] == "L" {
				mFormatFlags &= ~kLinearPCMFormatFlagIsAlignedHigh
			} else if fromText[charIterator] == "H" {
				mFormatFlags |= kLinearPCMFormatFlagIsAlignedHigh
			} else {
				throw ASBDError.invalidFormat
			}
			fromText.formIndex(after: &charIterator)
			var bytesPerFrame: UInt32 = 0
			while let aNum = numFromCurrentChar() {
				bytesPerFrame = 10 * bytesPerFrame + UInt32(aNum)
				fromText.formIndex(after: &charIterator)
			}
			mBytesPerPacket = bytesPerFrame
			mBytesPerFrame = mBytesPerPacket
		}
		if nextChar() == "," {
			fromText.formIndex(after: &charIterator)
			var ch = 0
			while let aNum = numFromCurrentChar() {
				ch = 10 * ch + aNum
				fromText.formIndex(after: &charIterator)
			}
			mChannelsPerFrame = UInt32(ch)
			if nextChar() == "D" {
				fromText.formIndex(after: &charIterator)
				guard mFormatID == kAudioFormatLinearPCM else {
					throw ASBDError.invalidInterleavedFlag
				}
				mFormatFlags |= kAudioFormatFlagIsNonInterleaved
			} else {
				if nextChar() == "I" {
					fromText.formIndex(after: &charIterator)
				}	// default
				if mFormatID == kAudioFormatLinearPCM {
					mBytesPerFrame *= UInt32(ch)
					mBytesPerPacket = mBytesPerFrame
				}
			}
		}
		if charIterator != fromText.endIndex {
			throw ASBDError.extraCharactersAtEnd(fromText[charIterator..<fromText.endIndex])
		}
	}
}

private func CAStringForOSType(_ val: OSType) -> String {
	var toRet = ""
	toRet.reserveCapacity(10)
	var str = [Int8](repeating: 0, count: 4)
	do {
		var tmpStr = val.bigEndian
		memcpy(&str, &tmpStr, MemoryLayout<OSType>.size)
	}
	var hasNonPrint = false
	for p in str {
		if !(isprint(Int32(p)) != 0 && p != ASCIICharacter.backSlashCharacter.rawValue) {
			hasNonPrint = true
			break
		}
	}
	if hasNonPrint {
		toRet = "0x"
	} else {
		toRet = "'"
	}
	str.forEach { (p) in
		if hasNonPrint {
			toRet += String(format: "%02X", p)
		} else {
			toRet += String(Character(Unicode.Scalar(UInt8(p))))
		}
	}
	if !hasNonPrint {
		toRet += "'"
	}
	return toRet
}

extension AudioStreamBasicDescription: @retroactive CustomStringConvertible {
	public var description: String {
		let formatID = CAStringForOSType(mFormatID)
		var buffer = String(format: "%2d ch, %6.0f Hz, \(formatID) (0x%08X) ", mChannelsPerFrame, mSampleRate, mFormatFlags)
		
		switch mFormatID {
		case kAudioFormatLinearPCM:
			let isInt = (mFormatFlags & kLinearPCMFormatFlagIsFloat) == 0
			let wordSize = sampleWordSize
			
			let endian = (wordSize > 1) ?
				((mFormatFlags & kLinearPCMFormatFlagIsBigEndian) == kLinearPCMFormatFlagIsBigEndian ? " big-endian" : " little-endian" ) : ""
			let sign = isInt ?
				((mFormatFlags & kLinearPCMFormatFlagIsSignedInteger) == kLinearPCMFormatFlagIsSignedInteger ? " signed" : " unsigned") : ""
			let floatInt = isInt ? "integer" : "float"
			
			let packed: String
			if wordSize > 0 && isPackednessSignificant {
				if (mFormatFlags & kLinearPCMFormatFlagIsPacked) == kLinearPCMFormatFlagIsPacked {
					packed = "packed in \(wordSize) bytes"
				} else {
					packed = "unpacked in \(wordSize) bytes"
				}
			} else {
				packed = ""
			}
			
			let align = (wordSize > 0 && isAlignmentSignificant) ?
				((mFormatFlags & kLinearPCMFormatFlagIsAlignedHigh) == kLinearPCMFormatFlagIsAlignedHigh ? " high-aligned" : " low-aligned") : ""
			let deinter = (mFormatFlags & kAudioFormatFlagIsNonInterleaved) == kAudioFormatFlagIsNonInterleaved ? ", deinterleaved" : ""
			let commaSpace = (packed.isEmpty) || (!align.isEmpty) ? ", " : ""
			
			let bitdepth: String
			
			let fracbits = (mFormatFlags & kLinearPCMFormatFlagsSampleFractionMask) >> kLinearPCMFormatFlagsSampleFractionShift
			if fracbits > 0 {
				bitdepth = "\(mBitsPerChannel - fracbits).\(fracbits)"
			} else {
				bitdepth = "\(mBitsPerChannel)"
			}
			
			buffer += "\(bitdepth)-bit\(endian)\(sign) \(floatInt)\(commaSpace)\(packed)\(align)\(deinter)"
			
		case kAudioFormatAppleLossless:
			var sourceBits = 0
			switch mFormatFlags {
			case kAppleLosslessFormatFlag_16BitSourceData:
				sourceBits = 16
				
			case kAppleLosslessFormatFlag_20BitSourceData:
				sourceBits = 20
				
			case kAppleLosslessFormatFlag_24BitSourceData:
				sourceBits = 24
				
			case kAppleLosslessFormatFlag_32BitSourceData:
				sourceBits = 32
				
			default:
				break
			}
			
			if sourceBits != 0 {
				buffer += "from \(sourceBits)-bit source, "
			} else {
				buffer += "from UNKNOWN source bit depth, "
			}
			buffer += "\(mFramesPerPacket) frames/packet"
			
		default:
			buffer += "\(mBitsPerChannel) bits/channel, \(mBytesPerPacket) bytes/packet, \(mFramesPerPacket) frames/packet, \(mBytesPerFrame) bytes/frame"
		}
		return buffer
	}
}

private func matchFormatFlags(_ x: AudioStreamBasicDescription, _ y: AudioStreamBasicDescription) -> Bool {
	var xFlags = x.mFormatFlags
	var yFlags = y.mFormatFlags
	
	// match wildcards
	if (x.mFormatID == 0 || y.mFormatID == 0 || xFlags == 0 || yFlags == 0) {
		return true
	}
	
	if x.mFormatID == kAudioFormatLinearPCM {
		// knock off the all clear flag
		xFlags &= ~kAudioFormatFlagsAreAllClear
		yFlags &= ~kAudioFormatFlagsAreAllClear
		
		// if both kAudioFormatFlagIsPacked bits are set, then we don't care about the kAudioFormatFlagIsAlignedHigh bit.
		if ((xFlags & yFlags & kAudioFormatFlagIsPacked) == kAudioFormatFlagIsPacked) {
			xFlags &= ~kAudioFormatFlagIsAlignedHigh
			yFlags &= ~kAudioFormatFlagIsAlignedHigh
		}
		
		// if both kAudioFormatFlagIsFloat bits are set, then we don't care about the kAudioFormatFlagIsSignedInteger bit.
		if (xFlags & yFlags & kAudioFormatFlagIsFloat) == kAudioFormatFlagIsFloat {
			xFlags &= ~kAudioFormatFlagIsSignedInteger
			yFlags &= ~kAudioFormatFlagIsSignedInteger
		}
		
		//	if the bit depth is 8 bits or less and the format is packed, we don't care about endianness
		if (x.mBitsPerChannel <= 8) && ((xFlags & kAudioFormatFlagIsPacked) == kAudioFormatFlagIsPacked) {
			xFlags &= ~kAudioFormatFlagIsBigEndian
		}
		if (y.mBitsPerChannel <= 8) && ((yFlags & kAudioFormatFlagIsPacked) == kAudioFormatFlagIsPacked) {
			yFlags &= ~kAudioFormatFlagIsBigEndian
		}
		
		//	if the number of channels is 1, we don't care about non-interleavedness
		if x.mChannelsPerFrame == 1 && y.mChannelsPerFrame == 1 {
			xFlags &= ~kLinearPCMFormatFlagIsNonInterleaved
			yFlags &= ~kLinearPCMFormatFlagIsNonInterleaved
		}
	}
	return xFlags == yFlags
}

extension AudioStreamBasicDescription: @retroactive Equatable {}
extension AudioStreamBasicDescription: @retroactive Comparable {
	/// Returns `true` if both `AudioStreamBasicDescription`s are exactly the same.
	public static func ===(lhs: AudioStreamBasicDescription, rhs: AudioStreamBasicDescription) -> Bool {
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
	
	public static func !==(lhs: AudioStreamBasicDescription, rhs: AudioStreamBasicDescription) -> Bool {
		return !(lhs === rhs)
	}
	
	/// Compares two `AudioStreamBasicDescription` to see if they're equal
	///
	/// The semantics for equality are:
	/// 1. Values must match exactly -- except for PCM format flags, see above.
	/// 2. wildcards are ignored in the comparison
	public static func ==(x: AudioStreamBasicDescription, y: AudioStreamBasicDescription) -> Bool {
		return (x.mSampleRate == 0 || y.mSampleRate == 0 || x.mSampleRate == y.mSampleRate)
			&& (x.mFormatID == 0 || y.mFormatID == 0 || x.mFormatID == y.mFormatID)
			&& matchFormatFlags(x, y)
			&& (x.mBytesPerPacket == 0 || y.mBytesPerPacket == 0 || x.mBytesPerPacket == y.mBytesPerPacket)
			&& (x.mFramesPerPacket == 0 || y.mFramesPerPacket == 0 || x.mFramesPerPacket == y.mFramesPerPacket)
			&& (x.mBytesPerFrame == 0 || y.mBytesPerFrame == 0 || x.mBytesPerFrame == y.mBytesPerFrame)
			&& (x.mChannelsPerFrame == 0 || y.mChannelsPerFrame == 0 || x.mChannelsPerFrame == y.mChannelsPerFrame)
			&& (x.mBitsPerChannel == 0 || y.mBitsPerChannel == 0 || x.mBitsPerChannel == y.mBitsPerChannel)
	}

	public static func <(x: AudioStreamBasicDescription, y: AudioStreamBasicDescription) -> Bool {
		var theAnswer = false
		var isDone = false
		
		//	note that if either side is 0, that field is skipped
		
		//	format ID is the first order sort
		if (!isDone) && ((x.mFormatID != 0) && (y.mFormatID != 0)) {
			if x.mFormatID != y.mFormatID {
				//	formats are sorted numerically except that linear
				//	PCM is always first
				if x.mFormatID == kAudioFormatLinearPCM {
					theAnswer = true
				} else if y.mFormatID == kAudioFormatLinearPCM {
					theAnswer = false
				} else {
					theAnswer = x.mFormatID < y.mFormatID
				}
				isDone = true
			}
		}
		
		//  mixable is always better than non-mixable for linear PCM and should be the second order sort item
		if (!isDone) && ((x.mFormatID == kAudioFormatLinearPCM) && (y.mFormatID == kAudioFormatLinearPCM)) {
			if ((x.mFormatFlags & kAudioFormatFlagIsNonMixable) == 0) && ((y.mFormatFlags & kAudioFormatFlagIsNonMixable) != 0) {
				theAnswer = true
				isDone = true
			} else if ((x.mFormatFlags & kAudioFormatFlagIsNonMixable) != 0) && ((y.mFormatFlags & kAudioFormatFlagIsNonMixable) == 0) {
				theAnswer = false
				isDone = true
			}
		}
		
		//	floating point vs integer for linear PCM only
		if (!isDone) && (x.mFormatID == kAudioFormatLinearPCM && y.mFormatID == kAudioFormatLinearPCM) {
			if (x.mFormatFlags & kAudioFormatFlagIsFloat) != (y.mFormatFlags & kAudioFormatFlagIsFloat) {
				//	floating point is better than integer
				theAnswer = (y.mFormatFlags & kAudioFormatFlagIsFloat) != 0
				isDone = true
			}
		}
		
		//	bit depth
		if (!isDone) && (x.mBitsPerChannel != 0 && y.mBitsPerChannel != 0) {
			if x.mBitsPerChannel != y.mBitsPerChannel {
				//	deeper bit depths are higher quality
				theAnswer = x.mBitsPerChannel < y.mBitsPerChannel
				isDone = true
			}
		}
		
		//	sample rate
		if (!isDone) && (x.mSampleRate != 0) && (y.mSampleRate != 0) {
			if x.mSampleRate != y.mSampleRate {
				//	higher sample rates are higher quality
				theAnswer = x.mSampleRate < y.mSampleRate
				isDone = true
			}
		}
		
		//	number of channels
		if (!isDone) && (x.mChannelsPerFrame != 0 && y.mChannelsPerFrame != 0) {
			if x.mChannelsPerFrame != y.mChannelsPerFrame {
				//	more channels is higher quality
				theAnswer = x.mChannelsPerFrame < y.mChannelsPerFrame
				//isDone = true
			}
		}
		
		return theAnswer
	}
}
