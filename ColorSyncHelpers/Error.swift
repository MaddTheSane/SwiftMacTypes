//
//  Error.swift
//  ColorSyncHelpers
//
//  Created by C.W. Betts on 2/14/16.
//  Copyright © 2016 C.W. Betts. All rights reserved.
//

import Foundation

@objc public enum CSError: Int, Error {
	/// Could not unwrap the error that was returned from a failed function call.
	case unwrappingError = -1
}

extension CSError: CustomStringConvertible, CustomDebugStringConvertible {
	public var description: String {
		switch self {
		case .unwrappingError:
			return "Unable to unwrap error returned by a ColorSync function failing"
		@unknown default:
			return "Unknown error \(self.rawValue)"
		}
	}
	
	public var debugDescription: String {
		switch self {
		case .unwrappingError:
			return "Unable to unwrap the error returned by a ColorSync function failing.\n\nThere's nothing you can do, other than create a ticket at https://feedbackassistant.apple.com as fixing this issue is impossible from an outside developer."
		@unknown default:
			return "Unknown error \(self.rawValue)"
		}
	}
	
	public var localizedFailureReason: String {
		switch self {
		case .unwrappingError:
			return "Unable to unwrap the error returned by a ColorSync function failing.\n\nThere's nothing you can do, other than create a ticket at https://feedbackassistant.apple.com as fixing this issue is impossible from an outside developer."
		@unknown default:
			return "Unknown error \(self.rawValue)"
		}
	}
}
