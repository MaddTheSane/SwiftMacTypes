//
//  CFBinaryHeap.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 8/2/21.
//  Copyright © 2021 C.W. Betts. All rights reserved.
//

import Foundation

public extension CFBinaryHeap {
	/// The number of values currently in the binary heap.
	@inlinable var count: Int {
		return CFBinaryHeapGetCount(self)
	}
	
	/// Removes the minimum value from the binary heap.
	@inlinable func removeMinimum() {
		CFBinaryHeapRemoveMinimumValue(self)
	}

	/// Removes all the values from the binary heap, making it empty.
	@inlinable func removeAll() {
		CFBinaryHeapRemoveAllValues(self)
	}

	/// The minimum value is in the binary heap.  If the heap contains several equal
	/// minimum values, any one may be returned.
	@inlinable var minimum: UnsafeRawPointer? {
		CFBinaryHeapGetMinimum(self)
	}
	
	/// Creates a new mutable binary heap with the values from the given binary heap.
	/// - parameter allocator: The `CFAllocator` which should be used to allocate
	/// memory for the binary heap and its storage for values. This
	/// parameter may be `nil` in which case the current default
	/// CFAllocator is used. If this reference is not a valid
	/// CFAllocator, the behavior is undefined.
	/// - parameter capacity: A hint about the number of values that will be held
	/// by the `CFBinaryHeap`. Pass `0` for no hint. The implementation may
	/// ignore this hint, or may use it to optimize various
	/// operations. A heap's actual capacity is only limited by
	/// address space and available memory constraints).
	/// This parameter must be greater than or equal
	/// to the count of the heap which is to be copied, or the
	/// behavior is undefined. If this parameter is negative, the
	/// behavior is undefined.
	/// - returns: A reference to the new mutable binary heap.
	///
	/// The values from the binary heap are copied as pointers into the new binary heap (that is, the values
	/// themselves are copied, not that which the values point to, if anything). However, the values are also
	/// retained by the new binary heap. The count of the new binary will be the same as the given binary
	/// heap. The new binary heap uses the same callbacks as the binary heap to be copied.
	@inlinable func copy(allocator: CFAllocator? = kCFAllocatorDefault, capacity: CFIndex) -> CFBinaryHeap {
		return CFBinaryHeapCreateCopy(allocator, capacity, self)
	}
}
