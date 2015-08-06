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
	
	///Is the current `AudioStreamBasicDescription` in the native endian format?
	///
	///- returns: `true` if the audio is in the native endian, `false` if not, and `nil` if the `formatID` isn't `.LinearPCM`.
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
}
