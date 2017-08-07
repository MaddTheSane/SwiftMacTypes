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
	public static let current: ByteOrder = {
		#if _endian(little)
			return .little
		#elseif _endian(big)
			return .big
		#else
			return .unknown
		#endif
	}()
	
	/// Is the machine's byte-order little-endian?
	public static var isLittle: Bool {
		#if _endian(little)
			return true
		#else
			return false
		#endif
	}
	
	/// Is the machine's byte-order big-endian?
	public static var isBig: Bool {
		#if _endian(big)
			return true
		#else
			return false
		#endif
	}
}

/// The current byte-order of the machine
@available(*, unavailable, message:"Use ByteOrder.current instead", renamed:"ByteOrder.current")
public var currentByteOrder: ByteOrder {
	fatalError("Unavailable function called: \(#function)")
}

/// Is the byte-order little-endian?
@available(*, unavailable, message:"Use ByteOrder.isLittle instead", renamed:"ByteOrder.isLittle")
public var isLittleEndian: Bool {
	fatalError("Unavailable function called: \(#function)")
}
/// Is the byte-order big-endian?
@available(*, unavailable, message:"Use ByteOrder.isBig instead", renamed:"ByteOrder.isBig")
public var isBigEndian: Bool {
	fatalError("Unavailable function called: \(#function)")
}
