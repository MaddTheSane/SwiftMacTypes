//
//  ExtAudioFileClass.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 2/3/16.
//  Copyright © 2016 C.W. Betts. All rights reserved.
//

import Foundation
import AudioToolbox
import CoreAudio
import SwiftAdditions

final public class ExtAudioFile {
	var internalPtr: ExtAudioFileRef
	private var strongAudioFileClass: AudioFile?
	
	public init(open openURL: URL) throws {
		var aPtr: ExtAudioFileRef? = nil
		let iErr = ExtAudioFileOpenURL(openURL as NSURL, &aPtr)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
		internalPtr = aPtr!
	}
	
	/// Internally retains `audioFile` so it doesn't get destroyed prematurely.
	public convenience init(wrapAudioFile audioFile: AudioFile, forWriting: Bool) throws {
		try self.init(wrapAudioFileID: audioFile.fileID, forWriting: forWriting)
		strongAudioFileClass = audioFile
	}
	
	/// The
	/// client is responsible for keeping the `AudioFileID` open until the
	/// `ExtAudioFile` is destroyed. Destroying the `ExtAudioFile` object will not close
	/// the `AudioFileID` when this Wrap API call is used, so the client is also
	/// responsible for closing the `AudioFileID` when finished with it.
	public init(wrapAudioFileID audioFile: AudioFileID, forWriting: Bool) throws {
		var aPtr: ExtAudioFileRef? = nil
		let iErr = ExtAudioFileWrapAudioFileID(audioFile, forWriting, &aPtr)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
		internalPtr = aPtr!
	}
	
	public init(create inURL: URL, fileType inFileType: AudioFileType, streamDescription inStreamDesc: inout AudioStreamBasicDescription, channelLayout inChannelLayout: UnsafePointer<AudioChannelLayout>? = nil, flags: AudioFileFlags = []) throws {
		var aPtr: ExtAudioFileRef? = nil
		let iErr = ExtAudioFileCreate(url: inURL, fileType: inFileType, streamDescription: &inStreamDesc, channelLayout: inChannelLayout, flags: flags, audioFile: &aPtr)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
		internalPtr = aPtr!
	}
	
	public func write(frames: UInt32, data: UnsafePointer<AudioBufferList>) throws {
		let iErr = ExtAudioFileWrite(internalPtr, frames, data)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	/// N.B. Errors may occur after this call has returned. Such errors may be thrown
	/// from subsequent calls to this method.
	public func writeAsync(frames: UInt32, data: UnsafePointer<AudioBufferList>) throws {
		let iErr = ExtAudioFileWriteAsync(internalPtr, frames, data)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	public func read(frames: inout UInt32, data: UnsafeMutablePointer<AudioBufferList>) throws {
		let iErr = ExtAudioFileRead(internalPtr, &frames, data)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	deinit {
		ExtAudioFileDispose(internalPtr)
	}
	
	public func get(propertyInfo ID: ExtAudioFilePropertyID) throws -> (size: UInt32, writeable: Bool) {
		var outSize: UInt32 = 0
		var outWritable: DarwinBoolean = false
		
		let iErr = ExtAudioFileGetPropertyInfo(internalPtr, ID, &outSize, &outWritable)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
		
		return (outSize, outWritable.boolValue)
	}
	
	public func get(property ID: ExtAudioFilePropertyID, dataSize: inout UInt32, data: UnsafeMutableRawPointer) throws {
		let iErr = ExtAudioFileGetProperty(internalPtr, ID, &dataSize, data)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	public func set(property ID: ExtAudioFilePropertyID, dataSize: UInt32, data: UnsafeRawPointer) throws {
		let iErr = ExtAudioFileSetProperty(internalPtr, ID, dataSize, data)
		
		if iErr != noErr {
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: nil)
		}
	}
	
	public var fileDataFormat: AudioStreamBasicDescription {
		get {
			var toRet = AudioStreamBasicDescription()
			var (size, _) = try! get(propertyInfo: kExtAudioFileProperty_FileDataFormat)
			try! get(property: kExtAudioFileProperty_FileDataFormat, dataSize: &size, data: &toRet)
			return toRet
		}
	}
	
	public var fileChannelLayout: AudioChannelLayout {
		get {
			var toRet = AudioChannelLayout()
			var (size, _) = try! get(propertyInfo: kExtAudioFileProperty_FileChannelLayout)
			try! get(property: kExtAudioFileProperty_FileChannelLayout, dataSize: &size, data: &toRet)
			return toRet
		}
		/*
		TODO: add throwable setter
		set throws {
		var newVal = newValue
		let (size, writable) = try! get(propertyInfo: kExtAudioFileProperty_ClientDataFormat)
		if !writable {
		//paramErr
		//throw NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil)
		fatalError(NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil).description)
		}
		try! set(property: kExtAudioFileProperty_ClientDataFormat, dataSize: size, data: &newVal)
		}*/
	}
	
	public var clientDataFormat: AudioStreamBasicDescription {
		get {
			var toRet = AudioStreamBasicDescription()
			var (size, _) = try! get(propertyInfo: kExtAudioFileProperty_ClientDataFormat)
			try! get(property: kExtAudioFileProperty_ClientDataFormat, dataSize: &size, data: &toRet)
			return toRet
		}
		//TODO: add throwable setter
		set /*throws*/ {
			var newVal = newValue
			let (size, writable) = try! get(propertyInfo: kExtAudioFileProperty_ClientDataFormat)
			if !writable {
				//paramErr
				//throw NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil)
				fatalError(NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil).description)
			}
			try! set(property: kExtAudioFileProperty_ClientDataFormat, dataSize: size, data: &newVal)
		}
	}
	
	public var clientChannelLayout: AudioChannelLayout {
		get {
			var toRet = AudioChannelLayout()
			var (size, _) = try! get(propertyInfo: kExtAudioFileProperty_ClientChannelLayout)
			try! get(property: kExtAudioFileProperty_ClientChannelLayout, dataSize: &size, data: &toRet)
			return toRet
		}
		/*
		TODO: add throwable setter
		set throws {
		var newVal = newValue
		let (size, writable) = try! get(propertyInfo: kExtAudioFileProperty_ClientDataFormat)
		if !writable {
		//paramErr
		//throw NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil)
		fatalError(NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil).description)
		}
		try! set(property: kExtAudioFileProperty_ClientDataFormat, dataSize: size, data: &newVal)
		}*/
	}
	
	public var codecManufacturer: UInt32 {
		get {
			var toRet: UInt32 = 0
			var (size, _) = try! get(propertyInfo: kExtAudioFileProperty_CodecManufacturer)
			try! get(property: kExtAudioFileProperty_CodecManufacturer, dataSize: &size, data: &toRet)
			return toRet
		}
		/*
		TODO: add throwable setter
		set throws {
		var newVal = newValue
		let (size, writable) = try! get(propertyInfo: kExtAudioFileProperty_ClientDataFormat)
		if !writable {
		//paramErr
		//throw NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil)
		fatalError(NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil).description)
		}
		try! set(property: kExtAudioFileProperty_ClientDataFormat, dataSize: size, data: &newVal)
		}*/
	}
	
	// MARK: read-only
	
	public var audioConverter: AudioConverterRef? {
		var toRet: AudioConverterRef? = nil
		var (size, _) = try! get(propertyInfo: kExtAudioFileProperty_AudioConverter)
		try! get(property: kExtAudioFileProperty_AudioConverter, dataSize: &size, data: &toRet)
		return toRet
	}
	
	public var audioFile: AudioFileID? {
		var toRet: AudioFileID? = nil
		var (size, _) = try! get(propertyInfo: kExtAudioFileProperty_AudioFile)
		try! get(property: kExtAudioFileProperty_AudioFile, dataSize: &size, data: &toRet)
		return toRet
	}
	
	public var fileMaxPacketSize: UInt32 {
		var toRet: UInt32 = 0
		var (size, _) = try! get(propertyInfo: kExtAudioFileProperty_FileMaxPacketSize)
		try! get(property: kExtAudioFileProperty_FileMaxPacketSize, dataSize: &size, data: &toRet)
		return toRet
	}
	
	public var clientMaxPacketSize: UInt32 {
		var toRet: UInt32 = 0
		var (size, _) = try! get(propertyInfo: kExtAudioFileProperty_ClientMaxPacketSize)
		try! get(property: kExtAudioFileProperty_ClientMaxPacketSize, dataSize: &size, data: &toRet)
		return toRet
	}
	
	public var fileLengthFrames: Int64 {
		var toRet: Int64 = 0
		var (size, _) = try! get(propertyInfo: kExtAudioFileProperty_FileLengthFrames)
		try! get(property: kExtAudioFileProperty_FileLengthFrames, dataSize: &size, data: &toRet)
		return toRet
	}
	
	//MARK: writable
	
	public func setConverterConfig(_ newVal: CFPropertyList?) throws {
		var cOpaque: UnsafeMutableRawPointer? = nil
		if let newVal = newVal {
			cOpaque = Unmanaged.passUnretained(newVal).toOpaque()
		}
		let (size, writable) = try get(propertyInfo: kExtAudioFileProperty_ConverterConfig)
		if !writable {
			//paramErr
			throw NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil)
		}
		try set(property: kExtAudioFileProperty_ConverterConfig, dataSize: size, data: &cOpaque)
	}
	
	public func setIOBufferSize(bytes bytes1: UInt32) throws {
		var bytes = bytes1
		let (size, writable) = try get(propertyInfo: kExtAudioFileProperty_IOBufferSizeBytes)
		if !writable {
			//paramErr
			throw NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil)
		}
		try set(property: kExtAudioFileProperty_IOBufferSizeBytes, dataSize: size, data: &bytes)
	}
	
	public func setIOBuffer(_ newVal: UnsafeMutableRawPointer) throws {
		let (size, writable) = try get(propertyInfo: kExtAudioFileProperty_IOBuffer)
		if !writable {
			//paramErr
			throw NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil)
		}
		try set(property: kExtAudioFileProperty_IOBuffer, dataSize: size, data: newVal)
	}
	
	public func setPacketTable(_ newVal1: AudioFilePacketTableInfo) throws {
		var newVal = newVal1
		let (size, writable) = try get(propertyInfo: kExtAudioFileProperty_PacketTable)
		if !writable {
			//paramErr
			throw NSError(domain: NSOSStatusErrorDomain, code: -50, userInfo: nil)
		}
		try set(property: kExtAudioFileProperty_PacketTable, dataSize: size, data: &newVal)
	}
}
