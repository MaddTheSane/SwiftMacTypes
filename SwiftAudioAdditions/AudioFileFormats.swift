//
//  AudioFileFormats.swift
//  PlaySequenceSwift
//
//  Created by C.W. Betts on 2/5/18.
//

import Foundation
import AudioToolbox
import SwiftAdditions

private func OSTypeToStr(_ val: OSType) -> String {
	var toRet = ""
	toRet.reserveCapacity(16)
	var str = [Int8](repeating: 0, count: 4)
	do {
		var tmpStr = val.bigEndian
		memcpy(&str, &tmpStr, MemoryLayout<OSType>.size)
	}
	for p in str {
		if isprint(Int32(p)) != 0 && p != ASCIICharacter.backSlashCharacter.rawValue {
			toRet += String(Character(Unicode.Scalar(UInt8(p))))
		} else {
			toRet += String(format: "\\x%02x", p)
		}
	}
	return toRet
}

public class AudioFileFormats {
	public static let shared = AudioFileFormats()
	
	public struct DataFormatInfo: CustomDebugStringConvertible {
		var formatID: OSType = 0
		var variants = [AudioStreamBasicDescription]()
		var readable = false
		var writable = false
		var eitherEndianPCM = false
		
		public var debugDescription: String {
			func ny(_ val: Bool) -> String {
				if val {
					return ""
				} else {
					return " not"
				}
			}
			var toRet = "    '\(OSTypeToStr(formatID))': \(ny(readable))readable \(ny(writable))writable\n"
			for variant in variants {
				toRet += "      \(variant.debugDescription)\n"
			}
			
			return toRet
		}
	}
	
	public struct FileFormatInfo: CustomDebugStringConvertible {
		public var fileTypeID = AudioFileTypeID()
		public var fileTypeName = ""
		public var extensions = [String]()
		public var dataFormats = [DataFormatInfo]()
		
		public func `extension`(at index: Int) -> String {
			return extensions[index]
		}
		
		public func matchExtension(_ testExt: String) -> Bool {
			for ext in extensions {
				if ext.compare(testExt, options: [.caseInsensitive]) == .orderedSame {
					return true
				}
			}
			
			return false
		}
		
		public var anyWritableFormats: Bool {
			for dfi in dataFormats {
				if dfi.writable {
					return true
				}
			}
			return false
		}
		
		public mutating func loadDataFormats() {
			guard dataFormats.isEmpty else {
				return
			}
			
			var size: UInt32 = 0
			// get all writable formats
			var err = AudioFormatGetPropertyInfo(kAudioFormatProperty_EncodeFormatIDs, 0, nil, &size)
			guard err == noErr else {
				return
			}
			var writableFormats = [UInt32](repeating: 0, count: Int(size) / MemoryLayout<UInt32>.size)
			err = AudioFormatGetProperty(kAudioFormatProperty_EncodeFormatIDs, 0, nil, &size, &writableFormats)
			guard err == noErr else {
				return
			}
			
			// get all readable formats
			err = AudioFormatGetPropertyInfo(kAudioFormatProperty_DecodeFormatIDs, 0, nil, &size);
			guard err == noErr else {
				return
			}

			var readableFormats = [UInt32](repeating: 0, count: Int(size) / MemoryLayout<UInt32>.size)
			err = AudioFormatGetProperty(kAudioFormatProperty_DecodeFormatIDs, 0, nil, &size, &readableFormats)
			guard err == noErr else {
				return
			}
			
			err = AudioFileGetGlobalInfoSize(kAudioFileGlobalInfo_AvailableFormatIDs, UInt32(MemoryLayout<UInt32>.size), &fileTypeID, &size);
			guard err == noErr else {
				return
			}

			let numDataFormats = Int(size) / MemoryLayout<OSType>.size
			var formatIDs = [OSType](repeating: 0, count: numDataFormats)
			err = AudioFileGetGlobalInfo(kAudioFileGlobalInfo_AvailableFormatIDs,
										 UInt32(MemoryLayout<UInt32>.size), &fileTypeID, &size, &formatIDs)
			guard err == noErr else {
				return
			}

			for fid in formatIDs {
				var anyBigEndian = false, anyLittleEndian = false;
				var dfi = DataFormatInfo()
				dfi.formatID = fid
				dfi.readable = fid == kAudioFormatLinearPCM
				dfi.writable = fid == kAudioFormatLinearPCM
				
				for readFor in readableFormats {
					if readFor == fid {
						dfi.readable = true
						break
					}
				}
				
				for writeFor in writableFormats {
					if writeFor == fid {
						dfi.writable = true
						break
					}
				}
				
				
				var tf = AudioFileTypeAndFormatID(mFileType: fileTypeID, mFormatID: fid)
				err = AudioFileGetGlobalInfoSize(kAudioFileGlobalInfo_AvailableStreamDescriptionsForFormat,
												 UInt32(MemoryLayout<AudioFileTypeAndFormatID>.size), &tf, &size);
				if err == noErr {
					let variantsCount = Int(size) / MemoryLayout<AudioStreamBasicDescription>.size
					var variants = [AudioStreamBasicDescription](repeating: AudioStreamBasicDescription(), count: variantsCount)
					err = AudioFileGetGlobalInfo(kAudioFileGlobalInfo_AvailableStreamDescriptionsForFormat,
												 UInt32(MemoryLayout<AudioFileTypeAndFormatID>.size), &tf, &size, &variants);
					if err == noErr {
						dfi.variants = variants
						for desc in variants {
							if desc.mBitsPerChannel > 8 {
								if (desc.mFormatFlags & kAudioFormatFlagIsBigEndian) == kAudioFormatFlagIsBigEndian {
									anyBigEndian = true
								} else {
									anyLittleEndian = true
								}
							}
						}
					}
					
					dfi.eitherEndianPCM = (anyBigEndian && anyLittleEndian);
					dataFormats.append(dfi)
				}
			}
		}
		
		public var debugDescription: String {
			var toRet = "File type: '\(OSTypeToStr(fileTypeID))' = \(fileTypeName)\n  Extensions:"
			for ext in extensions {
				toRet += " .\(ext)"
			}
			
			var tmp = self
			tmp.loadDataFormats()
			toRet += "\n  Formats:\n"
			for df in dataFormats {
				toRet += df.debugDescription
				toRet += "\n"
			}

			return toRet
		}
	}
	
	public private(set) var fileFormats = [FileFormatInfo]()
	
	private init(loadFormats: Bool = true) {
		var size: UInt32 = 0
		var err = AudioFileGetGlobalInfoSize(kAudioFileGlobalInfo_WritableTypes, 0, nil, &size);
		guard err == noErr else {
			return
		}
		let mNumFileFormats = Int(size) / MemoryLayout<UInt32>.size
		var fileTypes = [UInt32](repeating: 0, count: mNumFileFormats)
		err = AudioFileGetGlobalInfo(kAudioFileGlobalInfo_WritableTypes, 0, nil, &size, &fileTypes);
		guard err == noErr else {
			return
		}
		for fileType in fileTypes {
			var ffi = FileFormatInfo()
			var filetype = fileType
			
			ffi.fileTypeID = fileType
			
			// file type name
			do {
				size = UInt32(MemoryLayout<CFString>.size)
				var fileName: CFString? = nil
				err = AudioFileGetGlobalInfo(kAudioFileGlobalInfo_FileTypeName, UInt32(MemoryLayout<UInt32>.size), &filetype, &size, &fileName)
				if let fileName2 = fileName as String? {
					ffi.fileTypeName = fileName2
				}
			}
			
			// file extensions
			do {
				size = UInt32(MemoryLayout<CFArray>.size)
				var extensions: CFArray? = nil
				err = AudioFileGetGlobalInfo(kAudioFileGlobalInfo_ExtensionsForType, UInt32(MemoryLayout<UInt32>.size), &filetype, &size, &extensions)
				if let ext2 = extensions as? [String] {
					ffi.extensions = ext2
				}
			}
			
			if loadFormats {
				ffi.loadDataFormats()
			}
			fileFormats.append(ffi)
		}
		
		fileFormats.sort { (a, b) -> Bool in
			return a.fileTypeName.localizedCaseInsensitiveCompare(b.fileTypeName) == .orderedAscending
		}
	}
	
	/// Note that the returning format will have zero for the sample rate, channels per frame, bytesPerPacket, bytesPerFrame
	public func inferDataFormat(fromFileFormat filetype: AudioFileTypeID) -> AudioStreamBasicDescription? {
		var fmt = AudioStreamBasicDescription()
		// if the file format only supports one data format
		for var ffi in fileFormats {
			ffi.loadDataFormats()
			if ffi.fileTypeID == filetype && ffi.dataFormats.count > 0 {
				var dfi = ffi.dataFormats[0]
				if ffi.dataFormats.count > 1 {
					// file can contain multiple data formats. Take PCM if it's there.
					for datForm in ffi.dataFormats  {
						if datForm.formatID == kAudioFormatLinearPCM {
							dfi = datForm
							break
						}
					}
				}
				
				memset(&fmt, 0, MemoryLayout<AudioStreamBasicDescription>.size);
				fmt.mFormatID = dfi.formatID
				if dfi.variants.count > 0 {
					// take the first variant as a default
					fmt = dfi.variants[0]
					if dfi.variants.count > 1 && dfi.formatID == kAudioFormatLinearPCM {
						// look for a 16-bit variant as a better default
						for desc in dfi.variants  {
							if (desc.mBitsPerChannel == 16) {
								fmt = desc
								break
							}
						}
					}
				}
				return fmt
			}
		}
		return nil
	}
	
	public func inferFileFormat(from url: URL) -> AudioFileTypeID? {
		let ext = url.pathExtension
		guard ext.count > 0 else {
			return nil
		}
		for ffi in fileFormats {
			if ffi.matchExtension(ext) {
				return ffi.fileTypeID
			}
		}
		return nil
	}
	
	public func inferFileFormat(from fmt: AudioStreamBasicDescription) -> AudioFileTypeID? {
		var theFileFormat: FileFormatInfo? = nil
		for var ffi in fileFormats {
			ffi.loadDataFormats()
			for dfi in ffi.dataFormats {
				if dfi.formatID == fmt.mFormatID {
					if theFileFormat != nil {
						return nil	// ambiguous
					}
					theFileFormat = ffi	// got a candidate
				}
			}
		}
		if let theFileFormat = theFileFormat {
			return theFileFormat.fileTypeID
		}
		return nil
	}
	
	public func isKnownDataFormat(_ dataFormat: OSType) -> Bool {
		for var ffi in fileFormats {
			ffi.loadDataFormats()
			for dfi in ffi.dataFormats {
				if dfi.formatID == dataFormat {
					return true
				}
			}
		}
		
		return false
	}
	
	public func findFileFormat(_ formatID: UInt32) -> FileFormatInfo? {
		for ffi in fileFormats {
			if ffi.fileTypeID == formatID {
				return ffi
			}
		}
		return nil
	}
}
