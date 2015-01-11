//
//  NSIndexSet.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 1/9/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Foundation

public struct IndexSetGenerator: GeneratorType {
	private var intIndexSet: NSIndexSet
	private var index: Int
	init(indexSet: NSIndexSet) {
		//Just in case we get sent a mutable index set.
		intIndexSet = NSIndexSet(indexSet: indexSet)
		index = intIndexSet.firstIndex
	}
	
	public mutating func next() -> Int? {
		if index == NSNotFound {
			return nil
		} else {
			let aRet = index
			index = intIndexSet.indexGreaterThanIndex(index)
			return aRet
		}
	}
}

extension NSIndexSet: SequenceType {
	public func generate() -> IndexSetGenerator {
		return IndexSetGenerator(indexSet: self)
	}
}
