//
//  CTFontCollectionAdditions.swift
//  SSAMacRendering
//
//  Created by C.W. Betts on 10/19/17.
//  Copyright © 2017 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText

public extension CTFontCollection {
	#if os(macOS)
	/// Option bits for use with `CTFontCollectionCopyFontAttribute`(`s`).
	typealias CopyOptions = CTFontCollectionCopyOptions
	#endif
	
	// MARK: - Collection Creation
	/*! --------------------------------------------------------------------------
	@group Collection Creation
	*///--------------------------------------------------------------------------

	/// Returns a new font collection matching all available fonts.
	/// - parameter options: The options dictionary. See constant option keys.
	/// - returns: This function creates a new collection containing all fonts available to the current application.
	class func createFromAvailableFonts(_ options: [String: Any]?) -> CTFontCollection {
		return CTFontCollectionCreateFromAvailableFonts(options as CFDictionary?)
	}
	
	/// Returns a new collection based on the array of font descriptors.
	/// - parameter queryDescriptors: An array of font descriptors to use for matching. May be `nil`,
	/// in which case the matching descriptors will be `nil`.
	/// - parameter options: The options dictionary. See constant option keys.
	/// - returns: This function creates a new collection based on the provided font descriptors. The contents
	/// of this collection is defined by matching the provided descriptors against all available font descriptors.
	static func create(with queryDescriptors: [CTFontDescriptor]?, options: [String: Any]?) -> CTFontCollection {
		return CTFontCollectionCreateWithFontDescriptors(queryDescriptors as NSArray?, options as CFDictionary?)
	}


	/// Returns a copy of this collection augmented with the new font descriptors.
	/// - parameter queryDescriptors: An array of font descriptors to augment those of the original collection.
	/// - parameter options: The options dictionary. See constant option keys.
	/// - returns: a copy of this font collection augmented by the new font descriptors and options. The new
	/// font descriptors are merged with the existing descriptors to create a single set.
	func copy(with queryDescriptors: [CTFontDescriptor]?, options: [String: Any]?) -> CTFontCollection {
		return CTFontCollectionCreateCopyWithFontDescriptors(self, queryDescriptors as NSArray?, options as CFDictionary?)
	}

	#if os(macOS)

	/// Returns a mutable copy of the original collection.
	///
	/// - returns: This function creates a mutable copy of the original font collection.
	@inlinable func mutableCopy() -> CTMutableFontCollection {
		return CTFontCollectionCreateMutableCopy(self)
	}
	
	// MARK: - Editing the query descriptors
	/*! --------------------------------------------------------------------------
	@group Editing the query descriptors
	*///--------------------------------------------------------------------------

	/// The array of descriptors to match.
	///
	/// This getter returns an array of descriptors to be used to query (match) the system font database. The
	/// return value is undefined if `CTFontCollectionCreateFromAvailableFonts` was used to
	/// create the collection.
	var queryDescriptors: [CTFontDescriptor]? {
		return CTFontCollectionCopyQueryDescriptors(self) as? [CTFontDescriptor]
	}

	/// The array of descriptors to exclude from the match.
	///
	/// The array of descriptors to be used to query (match) the system font database.
	var exclusionDescriptors: [CTFontDescriptor]? {
		return CTFontCollectionCopyExclusionDescriptors(self) as? [CTFontDescriptor]
	}
	
	#endif
	
	// MARK: - Retrieving Matching Descriptors
	/*! --------------------------------------------------------------------------
	@group Retrieving Matching Descriptors
	*///--------------------------------------------------------------------------
	

	/// Returns the array of matching font descriptors sorted with the callback function.
	/// - parameter sortCallback: The sorting callback function that defines the sort order.
	/// - parameter refCon: Pointer to client data define context for the callback.
	/// - returns: An array of `CTFontDescriptor`s matching the criteria of the collection, sorted
	/// by the results of the sorting callback function, or `nil` if there are none.
	func matchingFontDescriptors(sortedBy sortCallback: @escaping CTFontCollectionSortDescriptorsCallback, _ refCon: UnsafeMutableRawPointer? = nil) -> [CTFontDescriptor]? {
		return CTFontCollectionCreateMatchingFontDescriptorsSortedWithCallback(self, sortCallback, refCon) as? [CTFontDescriptor]
	}
	
	/// Returns an array of font descriptors matching the collection.
	/// - parameter options: The options dictionary. See constant option keys. If `nil`, uses the
	/// options passed in when the collection was created.
	/// - returns: An array of `CTFontDescriptor`s matching the collection definition or `nil` if there are none.
	@available(macOS 10.7, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
	func matchingFontDescriptors(options: [String: Any]? = nil) -> [CTFontDescriptor]? {
		return CTFontCollectionCreateMatchingFontDescriptorsWithOptions(self, options as NSDictionary?) as? [CTFontDescriptor]
	}

	#if os(macOS)
	/// Returns an array of font descriptors matching the specified family, one descriptor for each style in the collection.
	/// - parameter collection: The font collection reference.
	/// - parameter options: The options dictionary. See constant option keys. If `nil`, uses the
	/// options passed in when the collection was created.
	/// - returns: An array of `CTFontDescriptor`s matching the collection definition or `nil` if there are none.
	func matchingFontDescriptors(familyName: String, options: [String: Any]? = nil)  -> [CTFontDescriptor]? {
		return CTFontCollectionCreateMatchingFontDescriptorsForFamily(self, familyName as NSString, options as NSDictionary?) as? [CTFontDescriptor]
	}

	// MARK: - Bulk attribute access
	/*! --------------------------------------------------------------------------
	@group Bulk attribute access
	*///--------------------------------------------------------------------------

	/// Returns an array of font descriptor attribute values.
	///
	/// - parameter attributeName: The attribute to retrieve for each descriptor in the collection.
	/// - parameter options: Options to alter the return value.
	/// - returns: An array containing one value for each descriptor. With
	/// `kCTFontCollectionCopyDefaultOptions`, the values will be in the same order as the results from
	/// `CTFontCollectionCreateMatchingFontDescriptors` and `NULL` values will be transformed to
	/// `nil`. When the `CTFontCollection.CopyOptions.unique` is set, duplicate values will be removed.
	/// When `CTFontCollection.CopyOptions.standardSort` is set, the values will be sorted in standard
	/// UI order.
	func fontAttribute(name attributeName: String, options: CopyOptions) -> [Any?] {
		return (CTFontCollectionCopyFontAttribute(self, attributeName as NSString, options) as! [Any]).map({ (val) -> Any? in
			if CFEqual(val as AnyObject, kCFNull) {
				return nil
			}
			return val
		})
	}
	
	/// Returns an array of dictionaries containing font descriptor attribute values.
	/// - parameter attributeNames: The attributes to retrieve for each descriptor in the collection.
	/// - parameter options: Options to alter the return value.
	///
	/// - returns: An array containing one `Dictionary` value for each descriptor mapping the requested
	/// attribute names. With `kCTFontCollectionCopyDefaultOptions`, the values will be in the same
	/// order as the results from `matchingFontDescriptors()`. When the
	/// `CTFontCollection.CopyOptions.unique` is set, duplicate values will be removed. When
	/// `CTFontCollection.CopyOptions.standardSort` is set, the values will be sorted in standard UI order.
	func fontAttributes(names attributeNames: Set<String>, options: CopyOptions) -> [[String: Any]] {
		return CTFontCollectionCopyFontAttributes(self, attributeNames as NSSet, options) as! [[String: Any]]
	}
	#endif
}

#if os(macOS)
public extension CTMutableFontCollection {
	/*
	public override var queryDescriptors: [CTFontDescriptor]? {
		get {
			return super.queryDescriptors
		}
		set {
			
		}
	}*/
	
	/// Replaces the array of descriptors to match.
	/// - parameter descriptors: An array of `CTFontDescriptor`s. May be `nil` to represent
	/// an empty collection, in which case the matching descriptors will also be `nil`.
	func setQueryDescriptors(_ descriptors: [CTFontDescriptor]?) {
		CTFontCollectionSetQueryDescriptors(self, descriptors as NSArray?)
	}

	/// Replaces the array of descriptors to exclude from the match.
	/// - parameter descriptors: An array of `CTFontDescriptor`s. May be `nil`.
	func setExclusionDescriptors(_ descriptors: [CTFontDescriptor]?) {
		CTFontCollectionSetExclusionDescriptors(self, descriptors as NSArray?)
	}
}
#endif
