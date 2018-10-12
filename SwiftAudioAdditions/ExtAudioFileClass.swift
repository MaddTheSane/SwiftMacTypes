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
		
		guard iErr == noErr else {
			if let caErr = SAACoreAudioError.Code(rawValue: iErr) {
				throw SAACoreAudioError(caErr, userInfo: [NSURLErrorKey: openURL])
			}
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: [NSURLErrorKey: openURL])
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
		
		guard iErr == noErr else {
			if let caErr = SAACoreAudioError.Code(rawValue: iErr) {
				throw SAACoreAudioError(caErr)
			}
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr))
		}
		internalPtr = aPtr!
	}
	
	/// Creates a new audio file and associates it with the new extended audio file object.
	///
	/// If the file to be created is in a compressed format, you may set the sample rate in the
	/// `inStreamDesc` parameter to 0. In all cases, the extended file object’s encoding converter
	/// may produce audio at a different sample rate than the source. The file will be created with
	/// the audio format produced by the encoder.
	/// - parameter inURL: The URL of the new audio file.
	/// - parameter inFileType: The type of file to create, specified as a constant from the AudioFileTypeID enumeration.
	/// - parameter inStreamDesc: The format of the audio data to be written to the file.
	/// - parameter inChannelLayout: The channel layout of the audio data. If non-`nil`, this must be consistent with the number of channels specified by the `inStreamDesc` parameter.
	/// - parameter flags: Flags for creating or opening the file. If the `.eraseFile` flag is set, it erases an existing file. If the flag is not set, the function fails if the URL points to an existing file.
	public init(create inURL: URL, fileType inFileType: AudioFileType, streamDescription inStreamDesc: inout AudioStreamBasicDescription, channelLayout inChannelLayout: UnsafePointer<AudioChannelLayout>? = nil, flags: AudioFileFlags = []) throws {
		var aPtr: ExtAudioFileRef? = nil
		let iErr = ExtAudioFileCreate(url: inURL, fileType: inFileType, streamDescription: &inStreamDesc, channelLayout: inChannelLayout, flags: flags, audioFile: &aPtr)
		
		guard iErr == noErr else {
			if let caErr = SAACoreAudioError.Code(rawValue: iErr) {
				throw SAACoreAudioError(caErr, userInfo: [NSURLErrorKey: inURL])
			}
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr), userInfo: [NSURLErrorKey: inURL])
		}
		internalPtr = aPtr!
	}
	
	/// Performs a synchronous, sequential write operation on an audio file.
	///
	/// If the extended audio file object has an application data format, then the object’s
	/// converter converts the data in the ioData parameter to the file data format.
	/// - parameter frames: The number of frames to write.
	/// - parameter data: The buffer(s) from which audio data is written to the file.
	public func write(frames: UInt32, data: UnsafePointer<AudioBufferList>) throws {
		let iErr = ExtAudioFileWrite(internalPtr, frames, data)
		
		guard iErr == noErr else {
			if let caErr = SAACoreAudioError.Code(rawValue: iErr) {
				throw SAACoreAudioError(caErr)
			}
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr))
		}
	}
	
	/// Perform an asynchronous, sequential write operation on an audio file.
	///
	/// Writes the provided buffer list to an internal ring buffer and notifies an internal
	/// thread to perform the write at a later time. The first time this function is called,
	/// allocations may be performed. You can call this function with 0 frames and a `nil`
	/// buffer in a non-time-critical context to initialize the asynchronous mechanism. Once
	/// initialized, subsequent calls are very efficient and do not take locks. This technique
	/// may be used to write to a file from a realtime thread.
	///
	/// Your application must not mix synchronous and asynchronous writes to the same file.
	///
	/// Pending writes are not guaranteed to be flushed to disk until the object is deallocated.
	///
	/// N.B. Errors may occur after this call has returned. Such errors may be thrown
	/// from subsequent calls to this method.
	/// - parameter frames: The number of frames to write.
	/// - parameter data: The buffer(s) from which audio data is written to the file.
	public func writeAsync(frames: UInt32, data: UnsafePointer<AudioBufferList>?) throws {
		let iErr = ExtAudioFileWriteAsync(internalPtr, frames, data)
		
		guard iErr == noErr else {
			if let caErr = SAACoreAudioError.Code(rawValue: iErr) {
				throw SAACoreAudioError(caErr)
			}
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr))
		}
	}
	
	/// Performs a synchronous, sequential read operation on an audio file.
	///
	/// If the extended audio file object has an application data format, then
	/// the object’s converter converts the file data to the application format.
	///
	/// This function works only on a single thread. If you want your application to
	/// read an audio file on multiple threads, use Audio File Services instead.
	/// - parameter frames: On input, the number of frames to read from the file. On output,
	/// the number of frames actually read. Fewer frames may be read than were requested. For
	/// example, the supplied buffers may not be large enough to accommodate the requested
	/// data. If `0` frames are returned, end-of-file was reached.
	/// - parameter data: One or more buffers into which the audio data is read.
	public func read(frames: inout UInt32, data: UnsafeMutablePointer<AudioBufferList>) throws {
		let iErr = ExtAudioFileRead(internalPtr, &frames, data)
		
		guard iErr == noErr else {
			if let caErr = SAACoreAudioError.Code(rawValue: iErr) {
				throw SAACoreAudioError(caErr)
			}
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr))
		}
	}
	
	deinit {
		ExtAudioFileDispose(internalPtr)
	}
	
	/// Gets information about an extended audio file object property.
	/// - parameter ID: The property you want information about.
	/// - returns: the size and writable status of `ID` as a tuple.
	public func get(propertyInfo ID: ExtAudioFilePropertyID) throws -> (size: UInt32, writeable: Bool) {
		var outSize: UInt32 = 0
		var outWritable: DarwinBoolean = false
		
		let iErr = ExtAudioFileGetPropertyInfo(internalPtr, ID, &outSize, &outWritable)
		
		guard iErr == noErr else {
			if let caErr = SAACoreAudioError.Code(rawValue: iErr) {
				throw SAACoreAudioError(caErr)
			}
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr))
		}

		return (outSize, outWritable.boolValue)
	}
	
	/// Gets a property value from an extended audio file object.
	///
	/// Some Core Audio property values are C types and others are Core Foundation objects.
	///
	/// If you call this function to retrieve a value that is a Core Foundation object, then this function—despite the use of “Get” in its name—duplicates the object. You are responsible for releasing the object, as described in The Create Rule in Memory Management Programming Guide for Core Foundation.
	/// - parameter ID: The property whose value you want.
	/// - parameter dataSize: On input, the size of the memory pointed to by the outPropertyData parameter. On output, the size of the property value.
	/// - parameter data: On output, the property value you wanted to get.
	public func get(property ID: ExtAudioFilePropertyID, dataSize: inout UInt32, data: UnsafeMutableRawPointer) throws {
		let iErr = ExtAudioFileGetProperty(internalPtr, ID, &dataSize, data)
		
		guard iErr == noErr else {
			if let caErr = SAACoreAudioError.Code(rawValue: iErr) {
				throw SAACoreAudioError(caErr)
			}
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr))
		}
	}
	
	/// Sets a property value for an extended audio file object.
	/// - parameter ID: The property whose value you want to set.
	/// - parameter dataSize: The size of the property value, in bytes.
	/// - parameter data: The value you want to apply to the specified property.
	public func set(property ID: ExtAudioFilePropertyID, dataSize: UInt32, data: UnsafeRawPointer) throws {
		let iErr = ExtAudioFileSetProperty(internalPtr, ID, dataSize, data)
		
		guard iErr == noErr else {
			if let caErr = SAACoreAudioError.Code(rawValue: iErr) {
				throw SAACoreAudioError(caErr)
			}
			throw NSError(domain: NSOSStatusErrorDomain, code: Int(iErr))
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
		//throw SAMacError(.parameter)
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
				//throw SAMacError(.parameter)
				fatalError(NSError(domain: NSOSStatusErrorDomain, code: Int(SAMacError.parameter.rawValue), userInfo: nil).description)
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
		//throw SAMacError(.parameter)
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
		//throw SAMacError(.parameter)
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
			throw SAMacError(.parameter)
		}
		try set(property: kExtAudioFileProperty_ConverterConfig, dataSize: size, data: &cOpaque)
	}
	
	public func setIOBufferSize(bytes bytes1: UInt32) throws {
		var bytes = bytes1
		let (size, writable) = try get(propertyInfo: kExtAudioFileProperty_IOBufferSizeBytes)
		if !writable {
			throw SAMacError(.parameter)
		}
		try set(property: kExtAudioFileProperty_IOBufferSizeBytes, dataSize: size, data: &bytes)
	}
	
	public func setIOBuffer(_ newVal: UnsafeMutableRawPointer) throws {
		let (size, writable) = try get(propertyInfo: kExtAudioFileProperty_IOBuffer)
		if !writable {
			throw SAMacError(.parameter)
		}
		try set(property: kExtAudioFileProperty_IOBuffer, dataSize: size, data: newVal)
	}
	
	public func setPacketTable(_ newVal1: AudioFilePacketTableInfo) throws {
		var newVal = newVal1
		let (size, writable) = try get(propertyInfo: kExtAudioFileProperty_PacketTable)
		if !writable {
			throw SAMacError(.parameter)
		}
		try set(property: kExtAudioFileProperty_PacketTable, dataSize: size, data: &newVal)
	}
}
