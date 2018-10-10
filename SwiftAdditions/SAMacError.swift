//
//  SAMacError.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 10/10/18.
//  Copyright © 2018 C.W. Betts. All rights reserved.
//

import Foundation

#if SWIFT_PACKAGE

public struct SAMacError: _BridgedStoredNSError {
	public let _nsError: NSError

	public init(_nsError: NSError) {
		self._nsError = _nsError
	}
	
	public static var errorDomain: String { return NSOSStatusErrorDomain }
	
	
	public struct Code: RawRepresentable, _ErrorCodeProtocol {
		public let rawValue: OSStatus
		
		public typealias _ErrorType = SAMacError
		
		public init(rawValue rv: OSStatus) {
			rawValue = rv
		}
		
		/*! error in user parameter list */
		public static var parameter: Code {
			return Code(rawValue: -50)
		}
		
		/*! unimplemented core routine */
		public static var unimplemented: Code {
			return Code(rawValue: -4)
		}
		
		/*! File not found */
		public static var fileNotFound: Code {
			return Code(rawValue: -43)
		}
		
		/*! permissions error (on file open) */
		public static var filePermission: Code {
			return Code(rawValue: -54)
		}
		
		/*! too many files open */
		public static var tooManyFilesOpen: Code {
			return Code(rawValue: -42)
		}
		
		/*! Not enough room in heap zone */
		public static var memoryFull: Code {
			return Code(rawValue: -108)
		}
		
		/*! File not open */
		public static var fileNotOpen: Code {
			return Code(rawValue: -38)
		}
		
		/*! End of file */
		public static var endOfFile: Code {
			return Code(rawValue: -39)
		}
		
		/*! tried to position to before start of file (r/w) */
		public static var filePosition: Code {
			return Code(rawValue: -40)
		}
	}
	
	/*! error in user parameter list */
	public static var parameter: SAMacError.Code { return .parameter }
	
	/*! unimplemented core routine */
	public static var unimplemented: SAMacError.Code { return .unimplemented }
	
	/*! File not found */
	public static var fileNotFound: SAMacError.Code { return .fileNotFound }
	
	/*! permissions error (on file open) */
	public static var filePermission: SAMacError.Code { return .filePermission }
	
	/*! too many files open */
	public static var tooManyFilesOpen: SAMacError.Code { return .tooManyFilesOpen }
	
	/*! Not enough room in heap zone */
	public static var memoryFull: SAMacError.Code { return .memoryFull }
	
	/*! File not open */
	public static var fileNotOpen: SAMacError.Code { return .fileNotOpen }
	
	/*! End of file */
	public static var endOfFile: SAMacError.Code { return .endOfFile }
	
	/*! tried to position to before start of file (r/w) */
	public static var filePosition: SAMacError.Code { return .filePosition }
}
#endif
