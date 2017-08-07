//
//  AppleScriptFoundation.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 2/4/16.
//  Copyright © 2016 C.W. Betts. All rights reserved.
//

import Foundation

#if os(OSX)
	private func getError(dict: NSDictionary?) -> NSError {
		if var dict = dict as? [String : Any] {
			let errNum = dict[NSAppleScript.errorNumber] as? Int ?? errOSAScriptError
			
			dict[NSLocalizedFailureReasonErrorKey] = dict[NSAppleScript.errorMessage]
			dict[NSLocalizedDescriptionKey] = dict[NSAppleScript.errorBriefMessage]
			return NSError(domain: NSOSStatusErrorDomain, code: errNum, userInfo: dict)
		} else {
			return NSError(domain: NSOSStatusErrorDomain, code: errOSAScriptError)
		}
	}

	extension NSAppleScript {
		/// Creates a newly allocated script instance from the source identified by the passed URL.
		/// - parameter url: A URL that locates a script, in either text or compiled form.
		/// - throws: an `NSError` in the `NSOSStatusErrorDomain` domain
		/// if unsuccessful. If you need to get the dictionary that would
		/// have been returned by `compileAndReturnError(_:)`, the values
		/// are stored in the `NSError`'s `userInfo`.
		@nonobjc public static func appleScript(contentsOf url: URL) throws -> NSAppleScript {
			var errDict: NSDictionary?
			if let hi = NSAppleScript(contentsOf: url, error: &errDict) {
				return hi
			}
			throw getError(dict: errDict)
		}
		
		/// Compile the script, if it is not already compiled.
		/// - throws: an `NSError` in the `NSOSStatusErrorDomain` domain 
		/// if unsuccessful. If you need to get the dictionary that would
		/// have been returned by `compileAndReturnError(_:)`, the values
		/// are stored in the `NSError`'s `userInfo`.
		@nonobjc public func compile() throws {
			var errDict: NSDictionary?
			if !compileAndReturnError(&errDict) {
				throw getError(dict: errDict)
			}
		}
		
		/// Execute the script, compiling it first if it is not already compiled.  
		/// - returns: the result of executing the script.
		/// - throws: an `NSError` in the `NSOSStatusErrorDomain` domain on 
		/// failure. If you need to get the dictionary that would have 
		/// been returned by `executeAndReturnError(_:)`, the values are stored
		/// in the `NSError`'s `userInfo`.
		@nonobjc public func execute() throws -> NSAppleEventDescriptor {
			var errDict: NSDictionary?
			if let descriptor = executeAndReturnError(&errDict) as NSAppleEventDescriptor? {
				return descriptor
			} else {
				throw getError(dict: errDict)
			}
		}
		
		/// Execute an Apple event in the context of the script, compiling 
		/// the script first if it is not already compiled.
		/// - parameter event: The Apple event to execute.
		/// - returns: the result of executing the event.
		/// - throws: an `NSError` in the `NSOSStatusErrorDomain` domain 
		/// if an error occurs. If you need to get the dictionary that would
		/// have been returned by `executeAppleEvent(_:error:)`, the values
		/// are stored in the `NSError`'s `userInfo`.
		@nonobjc public func executeAppleEvent(_ event: NSAppleEventDescriptor) throws -> NSAppleEventDescriptor {
			var errDict: NSDictionary?
			if let descriptor = executeAppleEvent(event, error: &errDict) as NSAppleEventDescriptor? {
				return descriptor
			} else {
				throw getError(dict: errDict)
			}
		}
	}
#endif
