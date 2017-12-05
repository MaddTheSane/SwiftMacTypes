//
//  CoreTextAdditions.swift
//  SSATestRendering
//
//  Created by C.W. Betts on 10/17/17.
//  Copyright © 2017 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText.CTFontManager

public struct FontManager {
	private init() {}
	
	/// Sets the auto-activation for the specified bundle identifier.
	/// SDKs
	public typealias AutoActivationSetting = CTFontManagerAutoActivationSetting
	
	/// Scope for font registration.
	public typealias Scope = CTFontManagerScope
	
	/// An array of unique PostScript font names.
	@available(OSX 10.6, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
	public static var availablePostScriptNames: [String] {
		return CTFontManagerCopyAvailablePostScriptNames() as NSArray as! [String]
	}
	
	/// An array of visible font family names sorted for UI display.
	@available(OSX 10.6, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
	public static var availableFontFamilyNames: [String] {
		return CTFontManagerCopyAvailableFontFamilyNames() as NSArray as! [String]
	}
	
	#if os(OSX)
	/// An array of font URLs.
	@available(OSX 10.6, *)
	public static var availableFontURLs: [URL] {
		return CTFontManagerCopyAvailableFontURLs() as NSArray as! [URL]
	}
	#endif

	/// Returns an array of font descriptors representing each of the fonts in the specified URL.
	/// Note: these font descriptors are not available through font descriptor matching.
	/// - parameter fileURL: A file system URL referencing a valid font file.
	/// - returns: An array of `CTFontDescriptor`s or `nil` if there are no valid fonts.
	@available(OSX 10.6, iOS 7.0, watchOS 2.0, tvOS 9.0, *)
	public static func fontDescriptors(for fileURL: URL) -> [CTFontDescriptor]? {
		return CTFontManagerCreateFontDescriptorsFromURL(fileURL as NSURL) as NSArray? as! [CTFontDescriptor]?
	}
	
	/// Returns a font descriptor representing the font in the supplied data.
	/// Note: the font descriptor is not available through font descriptor matching.
	/// - returns: A font descriptor created from the data or `nil` if it is not a valid font.
	/// - parameter data: A `Data` containing font data.
	///
	/// If the data contains a font collection (TTC or OTC), only the first font in the collection will be returned.
	@available(OSX 10.7, iOS 7.0, watchOS 2.0, tvOS 9.0, *)
	public static func fontDescriptor(for data: Data) -> CTFontDescriptor? {
		return CTFontManagerCreateFontDescriptorFromData(data as NSData)
	}
	
	/// Registers fonts from the specified font URL with the font manager. Registered fonts participate in font descriptor matching.
	/// - parameter fontURL: Font URL.
	/// - parameter scope: Scope constant defining the availability and lifetime of the registration. See scope constants for more details.
	@available(OSX 10.6, iOS 4.1, watchOS 2.0, tvOS 9.0, *)
	public static func registerFonts(at fontURL: URL, scope: Scope) throws {
		var maybeErr: Unmanaged<CFError>? = nil
		let toRet = CTFontManagerRegisterFontsForURL(fontURL as NSURL, scope, &maybeErr)
		guard toRet else {
			if let maybeErr = maybeErr?.takeRetainedValue() {
				throw maybeErr
			} else {
				throw NSError(domain: NSCocoaErrorDomain, code: -1)
			}
		}
	}
	
	/// Unregisters fonts from the specified font URL with the font manager. Unregistered fonts do not participate in font descriptor matching.
	/// iOS note: only fonts registered with `FontManager.registerFonts(for:)`, `CTFontManagerRegisterFontsForURLs`,
	/// or `CTFontManagerRegisterFontsForURLs` can be unregistered with this API.
	/// - parameter fontURL: Font URL.
	/// - parameter scope: Scope constant defining the availability and lifetime of the registration. Should match the scope the fonts are registered in. See scope constants for more details.
	@available(OSX 10.6, iOS 4.1, watchOS 2.0, tvOS 9.0, *)
	public static func unregisterFonts(at fontURL: URL, scope: Scope) throws {
		var maybeErr: Unmanaged<CFError>? = nil
		let toRet = CTFontManagerUnregisterFontsForURL(fontURL as NSURL, scope, &maybeErr)
		guard toRet else {
			if let maybeErr = maybeErr?.takeRetainedValue() {
				throw maybeErr
			} else {
				throw NSError(domain: NSCocoaErrorDomain, code: -1)
			}
		}
	}

	/// Registers the specified graphics font with the font manager. Registered fonts participate in font descriptor matching.
	/// Attempts to register a font that is either already registered or contains the same PostScript name of an already registered font will fail.
	/// This functionality is useful for fonts that may be embedded in documents or present/constructed in memory. A graphics font is obtained by calling `CGFontCreateWithDataProvider`. Fonts that are backed by files should be registered using `FontManager.registerFonts(from:scope:)`.
	/// - parameter font: Graphics font to be registered.
	@available(OSX 10.8, iOS 4.1, watchOS 2.0, tvOS 9.0, *)
	public static func registerGraphicsFont(_ font: CGFont) throws {
		var maybeErr: Unmanaged<CFError>? = nil
		let toRet = CTFontManagerRegisterGraphicsFont(font, &maybeErr)
		guard toRet else {
			if let maybeErr = maybeErr?.takeRetainedValue() {
				throw maybeErr
			} else {
				throw NSError(domain: NSCocoaErrorDomain, code: -1)
			}
		}
	}

	/// Unregisters the specified graphics font with the font manager. Unregistered fonts do not participate in font descriptor matching.
	/// - parameter font: Graphics font to be unregistered.
	@available(OSX 10.8, iOS 4.1, watchOS 2.0, tvOS 9.0, *)
	public static func unregisterGraphicsFont(_ font: CGFont) throws {
		var maybeErr: Unmanaged<CFError>? = nil
		let toRet = CTFontManagerUnregisterGraphicsFont(font, &maybeErr)
		guard toRet else {
			if let maybeErr = maybeErr?.takeRetainedValue() {
				throw maybeErr
			} else {
				throw NSError(domain: NSCocoaErrorDomain, code: -1)
			}
		}
	}
	
	#if os(OSX)
	/// Enables the matching font descriptors for font descriptor matching.
	/// - parameter descriptors: Array of font descriptors.
	@available(OSX 10.6, *)
	public static func enableFontDescriptors(_ descriptors: [CTFontDescriptor]) {
		CTFontManagerEnableFontDescriptors(descriptors as NSArray, true)
	}

	/// Disables the matching font descriptors for font descriptor matching.
	/// - parameter descriptors: Array of font descriptors.
	@available(OSX 10.6, *)
	public static func disableFontDescriptors(_ descriptors: [CTFontDescriptor]) {
		CTFontManagerEnableFontDescriptors(descriptors as NSArray, false)
	}
	
	/// Returns the registration scope of the specified URL.
	/// - parameter fontURL: Font URL.
	/// - returns: Returns the registration scope of the specified URL, will return `FontManager.Scope.none` if not currently registered.
	@available(OSX 10.6, *)
	public static func scope(for fontURL: URL) -> Scope {
		return CTFontManagerGetScopeForURL(fontURL as NSURL)
	}
	
	/// Determines whether the referenced font data (usually by file URL) is supported on the current platform.
	/// - parameter fontURL: A URL to font data.
	/// - returns: This function returns `true` if the URL represents a valid font that can be used on the current platform.
	@available(OSX 10.6, *)
	public static func isSupportedFont(at fontURL: URL) -> Bool {
		return CTFontManagerIsSupportedFont(fontURL as NSURL)
	}
	
	/*! --------------------------------------------------------------------------
	@group Manager Auto-Activation
	*/
	//--------------------------------------------------------------------------

	/// Creates a `CFRunLoopSource` that will be used to convey font requests from `CTFontManager`.
	/// - parameter sourceOrder: The order of the created run loop source.
	/// - parameter createMatchesCallback: A block to handle the font request.
	/// - returns: A `CFRunLoopSource` that should be added to the run loop. To stop receiving requests, invalidate this run loop source. Will return `nil` on error, in the case of a duplicate requestPortName or invalid context structure.
	@available(OSX 10.6, *)
	public static func createFontRequestRunLoopSource(order sourceOrder: Int, _ createMatchesCallback: @escaping @convention(block) (_ requestAttributes: CFDictionary, _ requestingProcess: pid_t) -> Unmanaged<CFArray>) -> CFRunLoopSource? {
			return CTFontManagerCreateFontRequestRunLoopSource(sourceOrder, createMatchesCallback)
	}
	
	/// The CTFontManager bundle identifier to be used with get or set global auto-activation settings.
	@available(OSX 10.6, *)
	public static var bundleIdentifier: String {
		return kCTFontManagerBundleIdentifier as String
	}
	
	/// Sets the auto-activation for the specified bundle identifier.
	/// - parameter bundleIdentifier: The bundle identifier. Used to specify a particular application
	/// bundle. If `nil`, the current application bundle will be used. If `FontManager.bundleIdentifier`
	/// is specified, will set the global auto-activation settings.
	/// - parameter setting: The new setting.
	///
	/// Function will apply the setting to the appropriate preferences location.
	@available(OSX 10.6, *)
	public static func setAutoActivationSetting(forBundleIdentifier bundleIdentifier: String?, setting: AutoActivationSetting) {
		CTFontManagerSetAutoActivationSetting(bundleIdentifier as NSString?, setting)
	}
	
	/// Accessor for the auto-activation setting.
	/// - parameter bundleIdentifier: The bundle identifier. Used to specify a particular application
	/// bundle. If `nil`,
	/// the current application bundle will be used. If `FontManager.bundleIdentifier` is specified,
	/// will set the global auto-activation settings.
	/// - returns: Will return the auto-activation setting for specified bundle identifier.
	@available(OSX 10.6,*)
	public static func autoActivationSetting(forBundleIdentifier bundleIdentifier: String?) -> AutoActivationSetting {
		return CTFontManagerGetAutoActivationSetting(bundleIdentifier as NSString?)
	}
	#endif

	/// Notification name for font registry changes.
	///
	/// This is the string to use as the notification name when subscribing
	/// to `CTFontManager` notifications.  This notification will be posted when fonts are added or removed.
	/// OS X clients should register as an observer of the notification with the distributed notification center
	/// for changes in session or user scopes and with the local notification center for changes in process scope.
	/// iOS clients should register as an observer of the notification with the local notification center for all changes.
	@available(OSX 10.6, iOS 7.0, watchOS 2.0, tvOS 9.0, *)
	public static var registeredFontsChanged: Notification.Name {
		return Notification.Name(kCTFontManagerRegisteredFontsChangedNotification as String)
	}
}
