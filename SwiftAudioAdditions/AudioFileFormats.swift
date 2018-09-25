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
	toRet.reserveCapacity(4)
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
				toRet += "      \(variant)\n"
			}
			
			return toRet
		}
	}
	
	public struct FileFormatInfo {
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
		
		mutating func loadDataFormats() {
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
	}
	/*
struct FileFormatInfo {
FileFormatInfo() : mFileTypeName(NULL), mExtensions(NULL), mDataFormats(NULL) { }
~FileFormatInfo() {
delete[] mDataFormats;
if (mFileTypeName)
CFRelease(mFileTypeName);
if (mExtensions)
CFRelease(mExtensions);
}

AudioFileTypeID					mFileTypeID;
CFStringRef						mFileTypeName;
CFArrayRef						mExtensions;
int								mNumDataFormats;
DataFormatInfo *				mDataFormats;		// NULL until loaded!

CFIndex	NumberOfExtensions() { return mExtensions ? CFArrayGetCount(mExtensions) : 0; }
char *	GetExtension(CFIndex index, char *buf, int buflen) {
CFStringRef cfext = (CFStringRef)CFArrayGetValueAtIndex(mExtensions, index);
CFStringGetCString(cfext, buf, buflen, kCFStringEncodingUTF8);
return buf;
}
bool	MatchExtension(CFStringRef testExt) {	// testExt should not include "."
CFIndex n = NumberOfExtensions();
for (CFIndex i = 0; i < n; ++i) {
CFStringRef ext = (CFStringRef)CFArrayGetValueAtIndex(mExtensions, i);
if (CFStringCompare(ext, testExt, kCFCompareCaseInsensitive) == kCFCompareEqualTo)
return true;
}
return false;
}
bool	AnyWritableFormats();
void	LoadDataFormats();

#if DEBUG
void	DebugPrint();
#endif
}
	*/
	
	//FileFormatInfo	*	mFileFormats
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
	
	/*
	
	// note that the outgoing format will have zero for the sample rate, channels per frame, bytesPerPacket, bytesPerFrame
	bool	CAAudioFileFormats::InferDataFormatFromFileFormat(AudioFileTypeID filetype, CAStreamBasicDescription &fmt)
	{
	// if the file format only supports one data format
	for (int i = 0; i < mNumFileFormats; ++i) {
	FileFormatInfo *ffi = &mFileFormats[i];
	ffi->LoadDataFormats();
	if (ffi->mFileTypeID == filetype && ffi->mNumDataFormats > 0) {
	DataFormatInfo *dfi = &ffi->mDataFormats[0];
	if (ffi->mNumDataFormats > 1) {
	// file can contain multiple data formats. Take PCM if it's there.
	for (int j = 0; j < ffi->mNumDataFormats; ++j) {
	if (ffi->mDataFormats[j].mFormatID == kAudioFormatLinearPCM) {
	dfi = &ffi->mDataFormats[j];
	break;
	}
	}
	}
	memset(&fmt, 0, sizeof(fmt));
	fmt.mFormatID = dfi->mFormatID;
	if (dfi->mNumVariants > 0) {
	// take the first variant as a default
	fmt = dfi->mVariants[0];
	if (dfi->mNumVariants > 1 && dfi->mFormatID == kAudioFormatLinearPCM) {
	// look for a 16-bit variant as a better default
	for (int j = 0; j < dfi->mNumVariants; ++j) {
	AudioStreamBasicDescription *desc = &dfi->mVariants[j];
	if (desc->mBitsPerChannel == 16) {
	fmt = *desc;
	break;
	}
	}
	}
	}
	return true;
	}
	}
	return false;
	}

	*/
	
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
	
	/*
	
bool	CAAudioFileFormats::InferFileFormatFromFilename(const char *filename, AudioFileTypeID &filetype)
{
if (filename == NULL) return false;
CFStringRef cfname = CFStringCreateWithCString(NULL, filename, kCFStringEncodingUTF8);
bool result = InferFileFormatFromFilename(cfname, filetype);
CFRelease(cfname);
return result;
}
	
	bool	CAAudioFileFormats::InferFileFormatFromDataFormat(const CAStreamBasicDescription &fmt,
	AudioFileTypeID &filetype)
	{
	// if there's exactly one file format that supports this data format
	FileFormatInfo *theFileFormat = NULL;
	for (int i = 0; i < mNumFileFormats; ++i) {
	FileFormatInfo *ffi = &mFileFormats[i];
	ffi->LoadDataFormats();
	DataFormatInfo *dfi = ffi->mDataFormats, *dfiend = dfi + ffi->mNumDataFormats;
	for ( ; dfi < dfiend; ++dfi)
	if (dfi->mFormatID == fmt.mFormatID) {
	if (theFileFormat != NULL)
	return false;	// ambiguous
	theFileFormat = ffi;	// got a candidate
	}
	}
	if (theFileFormat == NULL)
	return false;
	filetype = theFileFormat->mFileTypeID;
	return true;
	}
	
	bool	CAAudioFileFormats::IsKnownDataFormat(OSType dataFormat)
	{
	for (int i = 0; i < mNumFileFormats; ++i) {
	FileFormatInfo *ffi = &mFileFormats[i];
	ffi->LoadDataFormats();
	DataFormatInfo *dfi = ffi->mDataFormats, *dfiend = dfi + ffi->mNumDataFormats;
	for ( ; dfi < dfiend; ++dfi)
	if (dfi->mFormatID == dataFormat)
	return true;
	}
	return false;
	}
	
	CAAudioFileFormats::FileFormatInfo *	CAAudioFileFormats::FindFileFormat(UInt32 formatID)
	{
	for (int i = 0; i < mNumFileFormats; ++i) {
	FileFormatInfo *ffi = &mFileFormats[i];
	if (ffi->mFileTypeID == formatID)
	return ffi;
	}
	return NULL;
	}

*/
}
