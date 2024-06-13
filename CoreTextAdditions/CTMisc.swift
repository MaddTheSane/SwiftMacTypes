//
//  CTMisc.swift
//  CoreTextAdditions
//
//  Created by C.W. Betts on 5/29/21.
//  Copyright © 2021 C.W. Betts. All rights reserved.
//

import Foundation
import FoundationAdditions
import CoreText

extension CTFont: @retroactive CFTypeProtocol {
	/// Returns the Core Foundation type identifier for for the opaque type `CTFont`.
	@inlinable public class var typeID: CFTypeID {
		return CTFontGetTypeID()
	}
}

extension CTFontCollection: @retroactive CFTypeProtocol {
	/// The Core Foundation type identifier for the opaque type `CTFontCollection`.
	@inlinable public class var typeID: CFTypeID {
		return CTFontCollectionGetTypeID()
	}
}

extension CTFontDescriptor: @retroactive CFTypeProtocol {
	/// Returns the Core Foundation type identifier for the opaque type `CTFontDescriptor`.
	@inlinable public class var typeID: CFTypeID {
		return CTFontDescriptorGetTypeID()
	}
}

extension CTFrame: @retroactive CFTypeProtocol {
	/// Returns the Core Foundation type identifier for the opaque type `CTFrame`.
	@inlinable public class var typeID: CFTypeID {
		return CTFrameGetTypeID()
	}
}

extension CTFramesetter: @retroactive CFTypeProtocol {
	/// Returns the Core Foundation type identifier the opaque type `CTFramesetter`.
	@inlinable public class var typeID: CFTypeID {
		return CTFramesetterGetTypeID()
	}
}

extension CTLine: @retroactive CFTypeProtocol {
	/// Returns the Core Foundation type identifier for the opaque type `CTLineRef`.
	@inlinable public class var typeID: CFTypeID {
		return CTLineGetTypeID()
	}
}

extension CTParagraphStyle: @retroactive CFTypeProtocol {
	/// Returns the Core Foundation type identifier of the paragraph style object.
	@inlinable public class var typeID: CFTypeID {
		return CTParagraphStyleGetTypeID()
	}
}

extension CTRubyAnnotation: @retroactive CFTypeProtocol {
	/// Returns the Core Foundation type identifier for the opaque type `CTRubyAnnotation`.
	@inlinable public class var typeID: CFTypeID {
		return CTRubyAnnotationGetTypeID()
	}
}

extension CTRun: @retroactive CFTypeProtocol {
	/// Returns the Core Foundation type identifier for the opaque type `CTRun`.
	@inlinable public class var typeID: CFTypeID {
		return CTRunGetTypeID()
	}
}

extension CTRunDelegate: @retroactive CFTypeProtocol {
	/// The Core Foundation type identifier for the opaque type `CTRunDelegate`.
	@inlinable public static var typeID: CFTypeID {
		return CTRunDelegateGetTypeID()
	}
}

extension CTTextTab: @retroactive CFTypeProtocol {
	/// Returns the Core Foundation type identifier for the opaque type `CTTextTab`.
	@inlinable public class var typeID: CFTypeID {
		return CTTextTabGetTypeID()
	}
}

extension CTTypesetter: @retroactive CFTypeProtocol {
	/// Returns the Core Foundation type identifier for the opaque type `CTTypesetter`.
	@inlinable public static var typeID: CFTypeID {
		return CTTypesetterGetTypeID()
	}
}

extension CTGlyphInfo: @retroactive CFTypeProtocol {
	/// Returns the Core Foundation type identifier for the opaque type `CTGlyphInfo`.
	@inlinable public static var typeID: CFTypeID {
		return CTGlyphInfoGetTypeID()
	}
}

extension CTUnderlineStyle: @retroactive Hashable {
	
}

public enum CTBaselineClass: RawLosslessStringConvertibleCFString, Hashable, Codable, @unchecked Sendable {
	public typealias RawValue = CFString
	
	/// Creates a `CTBaselineClass` from a supplied string.
	/// If `rawValue` doesn't match any of the `kCTBaselineClass...`s, returns `nil`.
	/// - parameter rawValue: The string value to attempt to init `CTBaselineClass` into.
	public init?(rawValue: CFString) {
		switch rawValue {
		case kCTBaselineClassMath:
			self = .math
			
		case kCTBaselineClassRoman:
			self = .roman
			
		case kCTBaselineClassHanging:
			self = .hanging
			
		case kCTBaselineClassIdeographicLow:
			self = .ideographicLow
			
		case kCTBaselineClassIdeographicHigh:
			self = .ideographicHigh
			
		case kCTBaselineClassIdeographicCentered:
			self = .ideographicCentered
			
		default:
			return nil
		}
	}
	
	public var rawValue: CFString {
		switch self {
		case .math:
			return kCTBaselineClassMath
			
		case .roman:
			return kCTBaselineClassRoman
			
		case .hanging:
			return kCTBaselineClassHanging
			
		case .ideographicLow:
			return kCTBaselineClassIdeographicLow
			
		case .ideographicHigh:
			return kCTBaselineClassIdeographicHigh
			
		case .ideographicCentered:
			return kCTBaselineClassIdeographicCentered
		}
	}
	
	case math
	
	case roman
	
	case hanging
	
	case ideographicLow
	
	case ideographicHigh
	
	case ideographicCentered
	
	/// Creates a `CTBaselineClass` from a supplied string.
	/// If `stringValue` doesn't match any of the `kCTBaselineClass...`s, returns `nil`.
	/// - parameter stringValue: The string value to attempt to init `CTBaselineClass` from.
	public init?(_ stringValue: String) {
		self.init(rawValue: stringValue as CFString)
	}

	/// Deprecated. Use the newer initializer.
	@available(*, deprecated, renamed: "CTBaselineClass(_:)")
	public init?(stringValue: String) {
		self.init(rawValue: stringValue as CFString)
	}
}
