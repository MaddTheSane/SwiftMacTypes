//
//  Endianness.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 11/5/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Swift

public enum ByteOrder {
	case little
	case big
	case unknown
	
	/// The current byte-order of the machine.
	@inlinable public static var current: ByteOrder {
		#if _endian(little)
			return .little
		#elseif _endian(big)
			return .big
		#else
			return .unknown
		#endif
	}
	
	/// Is the machine's byte-order little-endian?
	@inlinable public static var isLittle: Bool {
		#if _endian(little)
			return true
		#else
			return false
		#endif
	}
	
	/// Is the machine's byte-order big-endian?
	@inlinable public static var isBig: Bool {
		#if _endian(big)
			return true
		#else
			return false
		#endif
	}
}
