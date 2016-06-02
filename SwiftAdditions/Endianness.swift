//
//  Endianness.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 11/5/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Darwin.libkern.OSByteOrder

public enum ByteOrder {
	case little
	case big
	case unknown
}

private func GetCurrentByteOrder() -> ByteOrder {
	switch Int(OSHostByteOrder()) {
	case OSLittleEndian:
		return .little
		
	case OSBigEndian:
		return .big
		
	default:
		return .unknown
	}
}

/// The current byte-order of the machine
public let currentByteOrder = GetCurrentByteOrder()

/// Is the byte-order little-endian?
public let isLittleEndian = currentByteOrder == .little
/// Is the byte-order big-endian?
public let isBigEndian = currentByteOrder == .big
