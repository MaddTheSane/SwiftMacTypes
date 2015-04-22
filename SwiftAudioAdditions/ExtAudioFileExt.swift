//
//  ExtAudioFileExt.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 4/18/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Foundation
import AudioToolbox
import SwiftAdditions

public enum ExtendedAudioFilePropertyID: OSType {
	/// An `AudioStreamBasicDescription`. Represents the file's actual
	/// data format. Read-only.
	case FileDataFormat = 0x66666D74
	
	/// An `AudioChannelLayout`.
	///
	/// If writing: the channel layout is written to the file, if the format
	/// supports the layout. If the format does not support the layout, the channel
	/// layout is still interpreted as the destination layout when performing
	/// conversion from the client channel layout, if any.
	///
	/// If reading: the specified layout overrides the one read from the file, if
	/// any.
	///
	/// When setting this, it must be set before the client format or channel
	/// layout.
	case FileChannelLayout = 0x66636C6F
	
	/// AudioStreamBasicDescription
	case ClientDataFormat = 0x63666D74
	
	/// AudioChannelLayout
	case ClientChannelLayout = 0x63636C6F
	
	/// UInt32
	case CodecManufacturer = 0x636D616E
	
	// MARK: - read-only
	/// AudioConverterRef
	case AudioConverter = 0x61636E76
	
	/// AudioFileID
	case AudioFile = 0x6166696C
	
	/// UInt32
	case FileMaxPacketSize = 0x666D7073
	
	/// UInt32
	case ClientMaxPacketSize = 0x636D7073
	
	/// SInt64
	case FileLengthFrames = 0x2366726D
	
	// MARK: - writable
	/// CFPropertyListRef
	case ConverterConfig = 0x61636366
	
	/// UInt32
	case IOBufferSizeBytes = 0x696F6273
	
	/// void *
	case IOBuffer = 0x696F6266
	
	/// AudioFilePacketTableInfo
	case PacketTable = 0x78707469
}

public func ExtAudioFileCreate(URL inURL: NSURL, fileType inFileType: AudioFileType, inout streamDescription inStreamDesc: AudioStreamBasicDescription, channelLayout inChannelLayout: UnsafePointer<AudioChannelLayout> = nil, flags: AudioFileFlags = nil, inout audioFile outAudioFile: ExtAudioFileRef) -> OSStatus {
	return ExtAudioFileCreateWithURL(inURL, inFileType.rawValue, &inStreamDesc, inChannelLayout, flags.rawValue, &outAudioFile)
}

public func ExtAudioFileSetProperty(inExtAudioFile: ExtAudioFileRef, propertyID inPropertyID: ExtendedAudioFilePropertyID, dataSize propertyDataSize: UInt32, data propertyData: UnsafePointer<Void>) -> OSStatus {
	return ExtAudioFileSetProperty(inExtAudioFile, inPropertyID.rawValue, propertyDataSize, propertyData)
}

public func ExtAudioFileGetPropertyInfo(inExtAudioFile: ExtAudioFileRef, propertyID inPropertyID: ExtendedAudioFilePropertyID, inout size outSize: UInt32, inout writable outWritable: Bool) -> OSStatus {
	var ouWritable: Boolean = 0
	let aRet = ExtAudioFileGetPropertyInfo(inExtAudioFile, inPropertyID.rawValue, &outSize, &ouWritable)
	outWritable = ouWritable.boolValue
	return aRet
}

public func ExtAudioFileGetProperty(inExtAudioFile: ExtAudioFileRef, propertyID inPropertyID: ExtendedAudioFilePropertyID, inout propertyDataSize ioPropertyDataSize: UInt32, propertyData outPropertyData: UnsafeMutablePointer<Void>) -> OSStatus {
	return ExtAudioFileGetProperty(inExtAudioFile, inPropertyID.rawValue, &ioPropertyDataSize, outPropertyData)
}
