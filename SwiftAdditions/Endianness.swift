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

public let CurrentByteOrder = GetCurrentByteOrder()

public let isLittleEndian = CurrentByteOrder == .Little
public let isBigEndian = CurrentByteOrder == .Big
