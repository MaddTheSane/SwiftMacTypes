//
//  CFBundle.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 8/28/26.
//  Copyright © 2026 C.W. Betts. All rights reserved.
//


import Foundation
import CoreFoundation

public extension CFBundle {
	/// An application's main bundle.
	///
	/// Is a `CFBundle` object representing the application's main bundle, or `nil` if it is not possible to create a bundle.
	///
	/// `CFBundle` creates a main bundle whenever it possibly can, even for unbundled apps. There are a few situations in
	/// which it is not possible, so you should check the return value against `nil`, but this happens only in exceptional circumstances.
	@inlinable static var main: CFBundle! {
		return CFBundleGetMainBundle()
	}
	
	/// Creates a CFBundle object.
	///
	/// - parameter allocator: The allocator to use to allocate memory for the new object. Pass `nil` or
	/// `kCFAllocatorDefault` to use the current default allocator.
	/// - parameter bundleURL: The location of the bundle for which to create a CFBundle object.
	/// - returns: A CFBundle object created from the bundle at `bundleURL`.
	/// Returns `nil` if there was a memory allocation problem. May return an existing `CFBundle` object with the reference
	/// count incremented. May return `nil` if the bundle doesn’t exist at `bundleURL` (see Discussion).
	///
	/// Once a bundle has been created, it is cached; the bundle cache is flushed only periodically.
	/// ``create(allocator:bundleURL:)`` does not check that a cached bundle still exists in the filesystem.
	/// If a bundle is deleted from the filesystem, it is therefore possible for CFBundleCreate to return a cached bundle that has
	/// actually been deleted.
	@inlinable static func create(allocator: CFAllocator? = kCFAllocatorDefault, bundleURL: CFURL) -> CFBundle? {
		return CFBundleCreate(allocator, bundleURL)
	}
	
	/// Searches a directory and constructs an array of `CFBundle` objects from all valid bundles in the specified directory.
	///
	/// - parameter directoryURL: The location of the directory to search for valid bundles.
	/// - parameter bundleType: The abstract type of the bundles to locate and create. The type is expressed as a filename
	/// extension, such as 'bundle'. Pass `nil` to create `CFBundle` objects for bundles of any type.
	/// - returns: An `Array` containing `CFBundle` objects created from the contents of the specified directory. Returns an
	/// empty array if no bundles exist at `directoryURL`, and `nil` if there was a memory allocation problem.
	///
	/// The array returned by this function will not contain stale `CFBundle` references.
	static func createBundles(fromDirectoryAt directoryURL: URL, bundleType: String? = nil) -> [CFBundle]? {
		return CFBundleCreateBundlesFromDirectory(kCFAllocatorDefault, directoryURL as NSURL, bundleType as NSString?) as? [CFBundle]
	}
	
	/// Locate a bundle given its program-defined identifier.
	/// - parameter bundleID: The identifier of the bundle to locate. Note that identifier names are case-sensitive.
	/// - returns: A `CFBundle` object, or `nil` if the bundle was not found.
	///
	/// For a bundle to be located using its identifier, the bundle must already have been loaded. The principal purpose for
	/// locating bundles by identifier is for code in frameworks or plugins to find its own bundle.
	///
	/// Bundle identifiers are created by entering a value for the key `CFBundleIdentifier` in the bundle's `Info.plist` file.
	///
	/// To ensure uniqueness, you should create bundle identifiers with the form of reverse-DNS naming style package
	/// names, such as *com.MyCompany.MyApp.bundleName*.
	///
	/// ## Special Considerations
	/// If a bundle object is created and the bundle file structure later deleted from the filesystem, this function
	/// will still return the original bundle object.
	@inlinable static func bundle(with bundleID: String) -> CFBundle? {
		return CFBundleGetBundleWithIdentifier(bundleID as CFString)
	}
	
	/// Returns an array containing all of the bundles currently open in the application.
	/// - returns: A Swift `Array` containing `CFBundle` objects for each open bundle in the application.
	///
	/// This function is potentially expensive and not thread-safe. It's best used for debugging or other
	/// diagnostics purposes rather than as part of the main execution path of production code.
	@inlinable static func allBundles() -> [CFBundle] {
		return CFBundleGetAllBundles() as! [CFBundle]
	}
	
	/// The location of a bundle.
	///
	/// A `URL` object describing the location of bundle, or `nil` if the specified bundle does not exist.
	@inlinable var bundleURL: URL? {
		return CFBundleCopyBundleURL(self) as URL?
	}
	
	/// The bundle identifier from the bundle's information property list.
	///
	/// Will be `nil` if there isn't one specified in the information property list.
	@inlinable var identifier: String? {
		CFBundleGetIdentifier(self) as? String
	}
	
#if os(macOS)
	@available(macOS 11.0, *)
	@inlinable var isExecutableLoadable: Bool {
		CFBundleIsExecutableLoadable(self)
	}
	
	@available(macOS 11.0, *)
	@inlinable static func isExecutableLoadable(for url: URL) -> Bool {
		CFBundleIsExecutableLoadableForURL(url as NSURL)
	}
	
	@available(macOS 11.0, *)
	@inlinable static func isArchitectureLoadable(_ arch: cpu_type_t) -> Bool {
		CFBundleIsArchitectureLoadable(arch)
	}
#endif
	
	
	// MARK: - Getters
	
	/// Returns a bundle's plug-in.
	@inlinable var plugIn: CFPlugIn? {
		CFBundleGetPlugIn(self)
	}
	
	/// A bundle's information dictionary.
	///
	/// A Dictionary object containing the data stored in the bundle's information property list (the Info.plist file).
	/// This is a global information dictionary. `CFBundle` may add extra keys to this dictionary for its own use.
	///
	/// You should typically use ``value(forInfoDictionaryKey:)-(String)`` rather than retrieving values directly
	/// from the info dictionary because the function will return localized values if any are available. Use this function only if
	/// you know that the key you are interested in will not be localized.
	///
	/// To retrieve an info dictionary without creating a CFBundle object, see ``infoDictionaryInDirectory(_:)``
	/// and ``infoDictionary(for:)``.
	@inlinable var infoDictionary: [String: Any]? {
		CFBundleGetInfoDictionary(self) as? [String : Any]
	}
	
	/// A bundle's localized information dictionary.
	///
	/// A dictionary containing the key-value pairs in bundle's localized information dictionary (from
	/// the `InfoPlist.strings` file for the current locale).
	@inlinable var localInfoDictionary: [String: Any]? {
		CFBundleGetLocalInfoDictionary(self) as? [String : Any]
	}
	
	/// Returns a value (localized if possible) from a bundle's information dictionary.
	/// - parameter key: The key for the value to return.
	/// - returns: A value corresponding to `key` in this bundle's information dictionary. If available, a localized
	/// value is returned, otherwise the global value is returned.
	///
	/// You should use this function rather than retrieving values directly from the info dictionary (`Info.plist`) because
	/// ``value(forInfoDictionaryKey:)-(String)`` returns localized values if any are available
	/// (from the `InfoPlist.strings` file for the current locale).
	@inlinable func value(forInfoDictionaryKey key: String) -> Any? {
		CFBundleGetValueForInfoDictionaryKey(self, key as CFString)
	}
	
	/// Returns a value (localized if possible) from a bundle's information dictionary.
	/// - parameter key: The key for the value to return.
	/// - returns: A value corresponding to `key` in this bundle's information dictionary. If available, a localized
	/// value is returned, otherwise the global value is returned.
	///
	/// You should use this function rather than retrieving values directly from the info dictionary (`Info.plist`) because
	/// ``value(forInfoDictionaryKey:)-(CFString)`` returns localized values if any are available (from the
	/// `InfoPlist.strings` file for the current locale).
	@inlinable func value(forInfoDictionaryKey key: CFString) -> Any? {
		CFBundleGetValueForInfoDictionaryKey(self, key)
	}
	
	/// A bundle's package type and creator.
	/// - returns: the four-letter type and creator codes for this bundle. Some common types are `APPL` for applications,
	/// `FMWK` for frameworks, and `BNDL` for generic bundles. Or a more specific type code for generic bundles.
	var packageInfo: (packageType: UInt32, packageCreator: UInt32) {
		var packageType: UInt32 = 0
		var packageCreator: UInt32 = 0
		
		CFBundleGetPackageInfo(self, &packageType, &packageCreator)
		return (packageType, packageCreator)
	}
	
	/// Returns a bundle's version number. This bundle's version number can be number or a string of the standard form "2.5.3d5".
	///
	/// A `vers` resource style version number. If it is a string, it is automatically converted to the numeric representation,
	/// where the major version number is restricted to 2 BCD digits (in other words, it must be in the range 0-99) and the minor
	/// and bug fix version numbers are each restricted to a single BCD digit (0-9).
	///
	/// This function is only supported for the vers resource style version numbers. Where other version number styles—namely X,
	/// or X.Y, or X.Y.Z—are used, you can use ``value(forInfoDictionaryKey:)`` with the key `kCFBundleVersionKey`
	/// to extract the version number as a string from the bundle's information dictionary.
	///
	/// Some version numbers of the form X, X.Y, and X.Y.Z may work with this function, if X <= 99, Y <= 9, and Z <= 9.
	/// Thus a version number 76.5.4 will work, but 76.12 will not work.
	@inlinable var versionNumber: UInt32 {
		CFBundleGetVersionNumber(self)
	}
	
	/// The bundle's development region from the bundle's information property list.
	@inlinable var developmentRegion: String? {
		CFBundleGetDevelopmentRegion(self) as String?
	}
	
	/// The location of the bundle's support files directory.
	///
	/// Will be `nil` if bundle's support files directory cannot be found.
	///
	/// In general, you should never need to use this function. Use ``resourceURL(for:ofType:subdirectory:)`` and
	/// similar functions instead.
	@inlinable var supportFilesDirectoryURL: URL? {
		CFBundleCopySupportFilesDirectoryURL(self) as URL?
	}
	
	/// The location of the bundle's Resources directory.
	///
	/// Will be `nil` if the bundle's Resource directory cannot be found.
	///
	/// In general, you should never need to use this function. Use ``resourceURL(for:ofType:subdirectory:)``
	/// and similar functions instead.
	@inlinable var resourcesDirectoryURL: URL? {
		CFBundleCopyResourcesDirectoryURL(self) as URL?
	}
	
	/// The location of the bundle's private Frameworks directory.
	///
	/// Will be `nil` if the bundle's private Frameworks directory cannot be found.
	@inlinable var privateFrameworksURL: URL? {
		CFBundleCopyPrivateFrameworksURL(self) as URL?
	}
	
	/// The location of the bundle's shared frameworks directory.
	///
	/// Will be `nil` if the bundle's shared frameworks directory cannot be found.
	@inlinable var sharedFrameworksURL: URL? {
		CFBundleCopySharedFrameworksURL(self) as URL?
	}
	
	/// The location of the bundle's shared support files directory.
	///
	/// Will be `nil` if the bundle's shared support files directory cannot be found.
	@inlinable var sharedSupportURL: URL? {
		CFBundleCopySharedSupportURL(self) as URL?
	}
	
	/// The location of the bundle's built-in plug-in directory.
	///
	/// Will be `nil` if the bundle's built-in plug-in directory cannot be found.
	@inlinable var builtInPlugInsURL: URL? {
		CFBundleCopyBuiltInPlugInsURL(self) as URL?
	}
	
	/// Returns the location of a bundle's main executable code.
	///
	/// A `URL` object describing the location of bundle's executable code, or `nil` if none is found.
	@inlinable var executableURL: URL? {
		return CFBundleCopyExecutableURL(self) as URL?
	}

	
	// MARK: -
	
	/// Obtains information about the load status for a bundle's main executable.
	///
	/// Is `true` if bundle's main executable has been loaded, otherwise `false`.
	@inlinable var isExecutableLoaded: Bool {
		CFBundleIsExecutableLoaded(self)
	}
	
	/// Unloads the main executable for the current bundle.
	///
	/// You should typically try to avoid using this function, but instead use ``functionPointer(forName:)`` and related
	/// functions since these make management of the bundle easier (when the last reference to the CFBundle object is released,
	/// and it is finally deallocated, then the code will be unloaded if it is still loaded, and if the executable is of a type that
	/// supports unloading).
	@inlinable func unloadExecutable() {
		CFBundleUnloadExecutable(self)
	}
	
	/// Returns a pointer to a function in a bundle's executable code using the function name as the search key.
	/// - parameter functionName: The name of the function to locate.
	/// - returns: A pointer to a function in a bundle's executable code, or `nil` if `functionName` cannot be found.
	///
	/// Calling this function will cause the bundle's code to be loaded if necessary.
	@inlinable func functionPointer(forName functionName: String) -> UnsafeMutableRawPointer? {
		return CFBundleGetFunctionPointerForName(self, functionName as NSString)
	}
	
	/// Constructs a function table containing pointers to all of the functions found in a bundle's main executable code.
	/// - parameter functionNames: An array containing a list of the function names to locate.
	/// - returns: An array into which this function stores the function pointers for the symbols specified in `functionNames`.
	/// The array contains `nil` for any names in `functionNames` that cannot be found.
	///
	/// Calling this function causes the bundle's code to be loaded if necessary.
	func functionPointers(forNames functionNames: [String]) -> [UnsafeMutableRawPointer?] {
		var ftbl: [UnsafeMutableRawPointer?] = .init(repeating: nil, count: functionNames.count)
		CFBundleGetFunctionPointersForNames(self, functionNames as CFArray, &ftbl)
		return ftbl
	}
	
	/// Returns a data pointer to a symbol of the given name.
	/// - parameter symbolName: The name of the symbol you are searching for.
	/// - returns: A data pointer to a symbol named `symbolName` in bundle, or `nil` if `symbolName` cannot be found.
	@inlinable func dataPointer(forName symbolName: String) -> UnsafeMutableRawPointer? {
		return CFBundleGetDataPointerForName(self, symbolName as NSString)
	}
	
	/// Returns an array of data pointer to symbols of the given names.
	/// - parameter symbolNames: An `Array` containing `String`s representing the symbol names to search for.
	/// - returns: An array into which this function stores the data pointers for the symbols specified in `symbolNames`.
	/// The array contains `nil` for any names in `symbolNames` that cannot be found.
	func dataPointers(forNames symbolNames: [String]) -> [UnsafeMutableRawPointer?] {
		var ftbl: [UnsafeMutableRawPointer?] = .init(repeating: nil, count: symbolNames.count)
		CFBundleGetDataPointersForNames(self, symbolNames as CFArray, &ftbl)
		return ftbl
	}
	
	// MARK: - Resources and Localization
	
	/// Returns the location of a resource contained in the specified bundle.
	///
	/// - parameter resourceName: The name of the requested resource.
	/// - parameter fileType: The abstract type of the requested resource. The type is expressed as a filename extension, such
	/// as *jpg*. Pass `nil` if `resourceName` is the complete name of the file you're looking for, including any extension.
	/// - parameter subdirectory: The name of the subdirectory of the bundle's resources directory to search. Pass
	/// `nil` to search the standard CFBundle resource locations.
	/// - returns: A `URL` describing the location of the requested resource, or `nil` if the resource cannot be found.
	///
	/// For example, if a bundle contains a subdirectory *WaterSounds* that includes a file *Water1.aiff*, you can retrieve the
	/// URL for the file using:
	/// ```swift
	/// bundle.resourceURL(for: "Water1", ofType: "aiff", subdirectory: "WaterSounds")
	/// ```
	@inlinable func resourceURL(for resourceName: String, ofType fileType: String? = nil, subdirectory: String? = nil) -> URL? {
		return CFBundleCopyResourceURL(self, resourceName as CFString, fileType as CFString?, subdirectory as CFString?) as? URL
	}
	
	/// Assembles an array of URLs specifying all of the resources of the specified type found in a bundle.
	///
	/// - parameter resourceType: The abstract type of the resources to locate. The type is expressed as a filename
	/// extension, such as *jpg*.
	/// - parameter subdirectory: The name of the subdirectory of the bundle's resources directory to search. Pass
	/// `nil` to search the standard CFBundle resource locations.
	/// - returns: An `Array` containing `URL`s of the requested resources.
	///
	/// Note that searches are case-sensitive, even on file systems (such as HFS+) that are not case sensitive with regards to file names.
	func resourceURLs(ofType resourceType: String, subdirectory: String? = nil) -> [URL] {
		CFBundleCopyResourceURLsOfType(self, resourceType as CFString, subdirectory as CFString?) as! [URL]
	}
	
	/// Returns a localized string from a bundle's strings file.
	///
	/// - parameter key: The key for the localized string to retrieve. This key will be used to look up the localized string in the strings
	/// file. Typically the key is identical to the value of the localized string in the development language.
	/// - parameter value: A default value to return if no value exists for `key`.
	/// - parameter table: The name of the strings file to search. The name should not include the *strings* filename extension.
	/// The case of the string must match that of the file name, even on file systems (such as HFS+) that are not case sensitive with
	/// regards to file names.
	/// - returns: A `String` object that contains the localized string. If no value exists for `key`, returns `value` unless
	/// `value` is `nil` or an empty string, in which case `key` is returned instead.
	///
	/// This is the base function from which the other localized string macros are derived. In general you should not use this
	/// function because the *genstrings* development tool only recognizes the macro version of this call when generating strings
	/// files. See ``CFCopyLocalizedString`` for details on how to use these macros.
	@inlinable func localizedString(for key: String, value: String? = nil, table: String? = nil) -> String {
		CFBundleCopyLocalizedString(self, key as CFString, value as CFString?, table as CFString?) as String
	}
	
	/// Returns a localized string given a list of possible localizations. The one most suitable to use with the current bundle is returned.
	/// - parameter key: The key for the localized string to retrieve.
	/// - parameter value: A default value to return if no value exists for `key`.
	/// - parameter table: The name of the strings file to search.
	/// - parameter localizations: An array of BCP 47 language codes corresponding to available localizations.
	/// Bundle compares the array against its available localizations, and uses the best result to retrieve the localized string.
	/// If empty, we treat it as no localization is available, and may return a fallback.
	/// - Returns: A localized version of the string designated by `key` in table `table`.
	@available(macOS 15.4, iOS 18.4, watchOS 11.4, tvOS 18.4, visionOS 2.4, *)
	@inlinable func localizedString(for key: String, value: String? = nil, table: String? = nil, localizations: [String]) -> String {
		CFBundleCopyLocalizedString(self, key as CFString, value as CFString?, table as CFString?) as String
	}
	
	/// An array containing this bundle's localizations.
	///
	///The array returned by this function is typically passed as a parameter to either the
	///``preferredLocalizations(from:)`` or ``localizationsForPreferences(_:_:)`` function.
	var localizations: [String] {
		CFBundleCopyBundleLocalizations(self) as! [String]
	}

	/// Given an array of possible localizations, returns the one or more of them that CFBundle would use in the current application context.
	/// - parameter locArray: An array of possible localizations.
	/// - returns: A subset of `locArray` that `CFBundle` would use in the current application context.
	///
	/// You can obtain `locArray` using the ``localizations`` getter.
	static func preferredLocalizations(from locArray: [String]) -> [String] {
		CFBundleCopyPreferredLocalizationsFromArray(locArray as CFArray) as! [String]
	}
	
	/// Given an array of possible localizations and preferred locations, returns the one or more of them that `CFBundle`
	/// would use, _without_ reference to the current application context.
	/// - parameter locArray: An array of possible localizations to search.
	/// - parameter prefArray: An array of preferred localizations. If `nil`, the user's actual preferred localizations will be used.
	/// - returns: An array containing the localizations that `CFBundle` would use.
	///
	/// This is not the same as ``preferredLocalizations(from:)``, because that function takes the current
	/// application context into account. To determine the localizations that another application would use, apply this
	/// function to the result of ``localizations``.
	static func localizationsForPreferences(_ locArray: [String], _ prefArray: [String]?) -> [String] {
		CFBundleCopyLocalizationsForPreferences(locArray as CFArray, prefArray as CFArray?) as! [String]
	}
	
	/// Returns the location of a localized resource in a bundle.
	/// - parameter resourceName: The name of the requested resource.
	/// - parameter fileType: The abstract type of the resource to locate. The type is expressed as a filename extension,
	/// such as *jpg*.
	/// - parameter subDirName: The name of the subdirectory of the bundle's resources directory to search. Pass `nil`
	/// to search the standard CFBundle resource locations.
	/// - parameter localizationName: The name of the localization. This value should correspond to the name of
	/// one of the bundle's language-specific resource directories without the .lproj extension. (This parameter is treated literally: If
	/// you pass "de", the function will not match resources in a German.lproj directory in the bundle.)
	/// - returns: The location of a localized resource in the bundle, or `nil` if the resource could not be found.
	///
	/// Note that file names are case-sensitive, even on file systems (such as HFS+) that are not case sensitive with regards to file names.
	///
	/// You should typically have little reason to use this function (see "Getting the Current Language and Locale")—`CFBundle`'s
	/// interfaces automatically apply the user's preferences to determine which localized resource files to return in response
	/// to a programmatic request. See also ``localizations`` for how to determine what
	/// localizations are available.
	func resourceURL(forResource resourceName: String, ofType fileType: String? = nil, subpath subDirName: String? = nil, localization localizationName: String? = nil) -> URL? {
		return CFBundleCopyResourceURLForLocalization(self, resourceName as CFString, fileType as CFString?, subDirName as CFString?, localizationName as CFString?) as URL?
	}
	
	/// Returns an array containing copies of the URL locations for a specified bundle, resource, and localization name.
	/// - parameter fileType: The abstract type of the resources to locate. The type is expressed as a filename extension,
	/// such as jpg.
	/// - parameter subDirName: The name of the subdirectory of the bundle's Resources directory to search. Pass `nil`
	/// to search the standard `CFBundle` resource locations.
	/// - parameter localizationName: The name of the localization. This value should correspond to the name of one of
	/// the bundle's language-specific resource directories without the `.lproj` extension. (This parameter is treated literally: If you
	/// pass `"de"`, the function will not match resources in a `German.lproj` directory in the bundle.)
	/// - returns: An `Array` object containing copies of the requested locations.
	///
	/// Note that file names are case-sensitive, even on file systems (such as HFS+) that are not case sensitive with regards to file names.
	///
	/// You should typically have little reason to use this function (see "Getting the Current Language and Locale")—CFBundle's
	/// interfaces automatically apply the user's preferences to determine which localized resource files to return in response to
	/// a programmatic request. See also ``localizations`` for how to determine what localizations are available
	func resourceURLs(ofType fileType: String, subpath subDirName: String? = nil, localization localizationName: String? = nil) -> [URL]? {
		return CFBundleCopyResourceURLsOfTypeForLocalization(self, fileType as CFString, subDirName as CFString?, localizationName as CFString?) as? [URL]
	}

	/// Returns the location of a bundle’s auxiliary executable code.
	/// - parameter executableName: The name of bundle’s auxiliary executable code.
	/// - returns: The URL location of the specified bundle’s auxiliary executable code, or `nil` if it could not be found.
	///
	/// This function can be used to find executables other than your main executable. This is useful, for instance, for
	/// applications that have some command line tool that is packaged with and used by the application. The tool can be
	/// packaged in the various platform executable directories in the bundle and can be located with this function. This allows
	/// an application to ship versions of the tool for each platform as it does for the main application executable.
	@inlinable func auxiliaryExecutableURL(withName executableName: String) -> URL? {
		CFBundleCopyAuxiliaryExecutableURL(self, executableName as CFString) as? URL
	}
	
	// MARK: -
	
	/// Returns a bundle's information dictionary.
	/// - parameter bundleURL: A `URL` object describing the location of a bundle.
	/// - returns: A `Dictionary` object containing the information dictionary for a bundle located at `bundleURL`.
	///
	/// This function provides a means to obtain an information dictionary for a bundle without first creating a `CFBundle` object.
	@inlinable static func infoDictionaryInDirectory(_ bundleURL: URL) -> [String: Any]? {
		CFBundleCopyInfoDictionaryInDirectory(bundleURL as CFURL) as? [String: Any]
	}
	
	/// Returns a bundle's package type and creator without having to create a `CFBundle` object.
	/// - parameter url: The location of a bundle.
	/// - returns: The four-letter type code for the bundle, the four-letter “creator” code for the bundle;
	/// or `nil` if the package type and creator were not found.
	///
	/// The package type can be *APPL* for applications, *FMWK* for frameworks, and *BNDL* for generic bundles. More
	/// specific type codes may be used.
	static func packageInfoInDirectory(_ bundleURL: URL) -> (packageType: UInt32, packageCreator: UInt32)? {
		var packageType: UInt32 = 0
		var packageCreator: UInt32 = 0
		if CFBundleGetPackageInfoInDirectory(bundleURL as CFURL, &packageType, &packageCreator) {
			return (packageType, packageCreator)
		}
		return nil
	}
	
	/// Returns the information dictionary for a given URL location.
	/// - parameter url: A URL describing the location of a file.
	/// - returns: A `Dictionary` containing url's information dictionary.
	///
	/// For a directory URL, this is equivalent to ``infoDictionaryInDirectory(_:)``. For a plain file URL representing
	/// an unbundled application, this function will attempt to read an information dictionary either from
	/// the `(__TEXT, __info_plist)` section of the file (for a Mach-O file) or from a `plst` resource.
	@inlinable static func infoDictionary(for url: URL) -> [String: Any]? {
		CFBundleCopyInfoDictionaryForURL(url as CFURL) as? [String : Any]
	}
	
	/// Returns an array containing the localizations for a bundle or executable at a particular location.
	/// - parameter url: The location of a bundle's localizations.
	/// - returns: An array containing the localizations available at `url`.
	///
	/// For a directory URL, this is equivalent to calling the ``localizations`` function on the corresponding bundle. For a
	/// plain file URL representing an unbundled application, this will attempt to determine its localizations using the
	/// `kCFBundleLocalizationsKey` and `kCFBundleDevelopmentRegionKey` keys in the dictionary
	/// returned by ``infoDictionary(for:)``, or a `vers` resource if those are not present.
	@inlinable static func localizations(for url: URL) -> [String]? {
		return CFBundleCopyLocalizationsForURL(url as CFURL) as? [String]
	}
	
	/// Returns the location of a resource contained in the specified bundle directory without requiring the creation of a CFBundle object.
	/// - parameter bundleURL: The bundle to examine.
	/// - parameter resourceName: The name of the requested resource.
	/// - parameter resourceType: The abstract type of the requested resource. The type is expressed as a
	/// filename extension, such as *jpg*. Pass `nil` if you don't need to search by type.
	/// - parameter subDirName: The name of the subdirectory of the bundle's resources directory to search. Pass
	/// `nil` to search the standard CFBundle resource locations.
	/// - returns: A `URL` describing the location of the requested resource, or `nil` if the resource cannot be found.
	static func resourceURL(for url: URL, resource: String, type: String? = nil, subdirectory: String? = nil) -> URL? {
		return CFBundleCopyResourceURLInDirectory(url as CFURL, resource as CFString, type as CFString?, subdirectory as CFString?) as URL?
	}
	
	/// Returns an array of `URL`s describing the locations of all resources in a bundle of the specified type without
	/// needing to create a `CFBundle` object.
	/// - parameter bundleURL: The location of a bundle to examine.
	/// - parameter resourceType: The abstract type of the resources to locate. The type is expressed as a filename
	/// extension, such as *jpg*.
	/// - parameter subDirName: The name of the subdirectory of the bundle's resources directory to search. Pass
	/// `nil` to search the standard `CFBundle` resource locations.
	/// - returns: An `Array` containing the `URL`s of the requested resources.
	///
	/// This function provides a means to obtain an array containing the locations of all of the requested resources without
	/// first creating a `CFBundle` object. However, since `CFBundle` objects cache search results, it is faster to
	/// create a `CFBundle` object if you need to repeatedly access resources.
	///
	/// Note that file names are case-sensitive, even on file systems (such as HFS+) that are not case sensitive with regards to file names.
	static func resourceURLs(for url: URL, type resourceType: String, subdirectory subDirName: String? = nil) -> [URL]? {
		return CFBundleCopyResourceURLsOfTypeInDirectory(url as CFURL, resourceType as CFString, subDirName as CFString?) as? [URL]
	}
	
	@available(macOS 10.5, iOS 2.0, watchOS 2.0, tvOS 9.0, *)
	enum ExecutableArchitecture: UInt32 {
		case i386 = 0x00000007
		case ppc  = 0x00000012
		case x86_64 = 0x01000007
		case ppc64 = 0x01000012
		
		@available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
		case arm64 = 0x0100000c
	}

	/// Returns an array of ``ExecutableArchitecture``s representing the architectures a given URL provides.
	/// - parameter theURL The URL to examine.
	/// - returns: For a directory URL, if the bundle's executable exists and is a Mach-O file, returns an array of
	/// ``ExecutableArchitecture``s whose values are integers representing the architectures the URL provides. For a
	/// plain file URL representing an unbundled executable, returns the architectures it provides if it is a Mach-O file. Possible
	/// values are listed in *Architecture Types*. If there is no bundle executable or if the executable is not a Mach-O file, returns `nil`.
	///
	/// For a directory URL, this is equivalent to calling ``CFBundle/executableArchitectures()`` on the corresponding bundle.
	@available(macOS 10.5, iOS 2.0, watchOS 2.0, tvOS 9.0, *)
	static func executableArchitectures(for theURL: URL) -> [ExecutableArchitecture]? {
		guard let theNums = CFBundleCopyExecutableArchitecturesForURL(theURL as NSURL) as? [UInt32] else {
			return nil
		}
		return theNums.compactMap(ExecutableArchitecture.init)
	}
	
	/// Returns an array of ``ExecutableArchitecture``s representing the architectures the current bundle provides.
	/// - returns: If the bundle's executable exists and is a Mach-O file, returns an array of ``ExecutableArchitecture``s
	/// whose values are integers representing the architectures the file provides. Possible values are listed in Architecture Types. If
	/// the executable is not a Mach-O file, returns `nil`.
	@available(macOS 10.5, iOS 2.0, watchOS 2.0, tvOS 9.0, *)
	func executableArchitectures() -> [ExecutableArchitecture]? {
		guard let theNums = CFBundleCopyExecutableArchitectures(self) as? [UInt32] else {
			return nil
		}
		return theNums.compactMap(ExecutableArchitecture.init)
	}
	
	/// Returns a `bool` that indicates whether a given bundle is loaded or appears to be loadable.
	/// - returns: `true` if bundle is loaded or upon inspection appears to be loadable, otherwise `false`.
	/// - throws: If an error occurs, contains a `CFError` that describes the problem.
	///
	/// If this function returns true, this does not mean that the bundle is definitively loadable, since it may
	/// fail to load due to link errors or other problems not readily detectable.
	@available(macOS 10.5, iOS 2.0, watchOS 2.0, tvOS 9.0, *)
	func preflightExecutable() throws -> Bool {
		var err: Unmanaged<CFError>?
		let result = CFBundlePreflightExecutable(self, &err)
		if let err = err?.takeRetainedValue() {
			throw err
		}
		return result
	}
	
	/// Returns a `bool` that indicates whether a given bundle is loaded, attempting to load it if necessary.
	/// - returns: If the bundle is already loaded, returns `true`. If bundle is not already loaded, attempts to load bundle;
	/// if that attempt succeeds returns `true`, otherwise returns `false`.
	/// - throws: If an error occurs, contains a `CFError` that describes the problem.
	func loadExecutable() throws -> Bool {
		var err: Unmanaged<CFError>?
		let result = CFBundleLoadExecutableAndReturnError(self, &err)
		if let err = err?.takeRetainedValue() {
			throw err
		}
		return result
	}
}
