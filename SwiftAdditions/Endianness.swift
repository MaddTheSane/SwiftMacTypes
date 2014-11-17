//
//  Endianness.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 11/5/14.
//  Copyright (c) 2014 C.W. Betts. All rights reserved.
//

import Darwin.libkern.OSByteOrder

public enum ByteOrder {
	case Little
	case Big
	case Unknown
}

private func GetCurrentByteOrder() -> ByteOrder {
	switch Int(OSHostByteOrder()) {
	case OSLittleEndian:
		return .Little
		
	case OSBigEndian:
		return .Big
		
	default:
		return .Unknown
	}
}

/// The current byte-order of the machine
public let CurrentByteOrder = GetCurrentByteOrder()

/// Is the byte-order little-endian?
public let isLittleEndian = CurrentByteOrder == .Little
/// Is the byte-order big-endian?
public let isBigEndian = CurrentByteOrder == .Big
