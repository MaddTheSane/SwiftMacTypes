//
//  CoreTextAdditions.swift
//  SSATestRendering
//
//  Created by C.W. Betts on 10/17/17.
//  Copyright © 2017 C.W. Betts. All rights reserved.
//

import Foundation
import CoreText

/// Namespace for CoreText's Font Manager functions.
public enum FontManager {
	/// Sets the auto-activation for the specified bundle identifier.
	public typealias AutoActivationSetting = CTFontManagerAutoActivationSetting
	
	/// These constants define the scope for font registration.
	public typealias Scope = CTFontManagerScope
	
	/// An array of unique PostScript font names.
	@available(OSX 10.6, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
	public static var availablePostScriptNames: [String] {
		return CTFontManagerCopyAvailablePostScriptNames() as! [String]
	}
	
	/// An array of visible font family names sorted for UI display.
	@available(OSX 10.6, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
	public static var availableFontFamilyNames: [String] {
		return CTFontManagerCopyAvailableFontFamilyNames() as! [String]
	}
	
	#if os(OSX)
	/// An array of font URLs.
	@available(OSX 10.6, *)
	public static var availableFontURLs: [URL] {
		return CTFontManagerCopyAvailableFontURLs() as! [URL]
	}
	#endif
	
	/// Registers fonts from the specified font URLs with the font manager. Registered fonts are discoverable
	/// through font descriptor matching in the calling process.
	///
	/// In iOS, fonts registered with the persistent scope are not automatically available
	/// to other processes. Other process may call `CTFontManagerRequestFonts` to get access
	/// to these fonts.
	/// - parameter fontURLs: Array of font URLs.
	/// - parameter scope: Scope constant defining the availability and lifetime of the
	/// registration. See scope constants for more details.
	/// - parameter enabled: Boolean value indicating whether the font derived from the URL
	/// should be enabled for font descriptor matching and/or discoverable via
	/// `CTFontManagerRequestFonts`.
	/// - parameter registrationHandler: Block called as errors are discovered or upon
	/// completion. The errors parameter contains an array of `Error`s. An empty
	/// array indicates no errors. Each error reference will contain a `CFArray` of font URLs
	/// corresponding to `kCTFontManagerErrorFontURLsKey`. These URLs represent the font
	/// files that caused the error, and were not successfully registered. Note, the handler
	/// may be called multiple times during the registration process. The `done` (second)
	/// parameter will be set to `true` when the registration process has completed. The
	/// handler should return `false` if the operation is to be stopped. This may be
	/// desirable after receiving an error.
	@available(OSX 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
	public static func register(fontURLs: [URL], scope: Scope, enabled: Bool, registrationHandler: ((_ errors: [Error], _ done: Bool) -> Bool)?) {
		let regHand: ((CFArray, Bool) -> Bool)?
		if let newHand = registrationHandler {
			regHand = { (errs, isDone) -> Bool in
				return newHand(errs as! [Error], isDone)
			}
		} else {
			regHand = nil
		}
		
		CTFontManagerRegisterFontURLs(fontURLs as NSArray, scope, enabled, regHand)
	}
	
	/// Unregisters fonts from the specified font URLs with the font manager. Unregistered
	/// fonts do not participate in font descriptor matching.
	/// iOS note: only fonts registered with `CTFontManagerRegisterFontsForURL` or
	/// `CTFontManagerRegisterFontsForURLs` can be unregistered with this API.
	/// - parameter fontURLs: Array of font URLs.
	/// - parameter scope: Scope constant defining the availability and lifetime of the
	/// registration. Should match the scope the fonts are registered in. See scope constants
	/// for more details.
	/// - parameter registrationHandler: Block called as errors are discovered or upon
	/// completion. The errors parameter will be an empty array if all files are
	/// unregistered. Otherwise, it will contain an array of `CFError` references. Each error
	/// reference will contain a `CFArray` of font URLs corresponding to
	/// `kCTFontManagerErrorFontURLsKey`. These URLs represent the font files that caused the
	/// error, and were not successfully unregistered. Note, the handler may be called
	/// multiple times during the unregistration process. The `done` (second) parameter will
	/// be set to true when the unregistration process has completed. The handler should
	/// return `false` if the operation is to be stopped. This may be desirable after
	/// receiving an error.
	@available(OSX 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
	public static func unregister(fontURLs: [URL], scope: Scope, registrationHandler: ((_ errors: [Error], _ done: Bool) -> Bool)?) {
		let regHand: ((CFArray, Bool) -> Bool)?
		if let newHand = registrationHandler {
			regHand = { (errs, isDone) -> Bool in
				return newHand(errs as! [Error], isDone)
			}
		} else {
			regHand = nil
		}
		
		CTFontManagerUnregisterFontURLs(fontURLs as NSArray, scope, regHand)
	}

	/// Registers font descriptors with the font manager. Registered fonts are discoverable
	/// through font descriptor matching in the calling process.
	///
	/// Fonts descriptors registered in disabled state are not immediately available for
	/// descriptor matching but the font manager will know the descriptors could be made
	/// available if necessary. These decriptors can be enabled by making this called again
	/// with the enabled parameter set to true. This operation may fail if there is another
	/// font registered and enabled with the same Postscript name. In iOS, fonts registered
	/// with the persistent scope are not automatically available to other processes. Other
	/// process may call `CTFontManagerRequestFonts` to get access to these fonts.
	/// - parameter fontDescriptors: Array of font descriptors to register. Font descriptor
	/// keys used for registration are: `kCTFontURLAttribute`, `kCTFontNameAttribute`,
	/// `kCTFontFamilyNameAttribute`, or `kCTFontRegistrationUserInfoAttribute`.
	/// - parameter scope: Scope constant defining the availability and lifetime of the
	/// registration. Should match the scope the fonts are registered in. See scope constants
	/// for more details.
	/// - parameter enabled: Boolean value indicating whether the font descriptors should be
	/// enabled for font descriptor matching and/or discoverable via
	/// `CTFontManagerRequestFonts`.
	/// - parameter registrationHandler: Block called as errors are discovered or upon
	/// completion. The errors parameter contains an array of `CFError` references. An empty
	/// array indicates no errors. Each error reference will contain a `CFArray` of font
	/// descriptors corresponding to `kCTFontManagerErrorFontDescriptorsKey`. These represent
	/// the font descriptors that caused the error, and were not successfully registered.
	/// Note, the handler may be called multiple times during the registration process. The
	/// `done` (second) parameter will be set to true when the registration process has
	/// completed. The handler should return `false` if the operation is to be stopped. This
	/// may be desirable after receiving an error.
	@available(OSX 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
	public static func register(fontDescriptors: [CTFontDescriptor], scope: Scope, enabled: Bool, registrationHandler: ((_ errors: [Error], _ done: Bool) -> Bool)?) {
		let regHand: ((CFArray, Bool) -> Bool)?
		if let newHand = registrationHandler {
			regHand = { (errs, isDone) -> Bool in
				return newHand(errs as! [Error], isDone)
			}
		} else {
			regHand = nil
		}
		
		CTFontManagerRegisterFontDescriptors(fontDescriptors as NSArray, scope, enabled, regHand)
	}

	/// Unregisters font descriptors with the font manager. Unregistered fonts do not
	/// participate in font descriptor matching.
	/// - parameter fontDescriptors: Array of font descriptors to unregister.
	/// - parameter scope: Scope constant defining the availability and lifetime of the
	/// registration. Should match the scope the fonts are registered in. See scope constants
	/// for more details.
	/// - parameter registrationHandler: Block called as errors are discovered or upon
	/// completion. The errors parameter will be an empty array if all font descriptors are
	/// unregistered. Otherwise, it will contain an array of `Error` references. Each error
	/// reference will contain an `Array` of font descriptors corresponding to
	/// `kCTFontManagerErrorFontDescriptorsKey`. These represent the font descriptors that
	/// caused the error, and were not successfully unregistered. Note, the handler may be
	/// called multiple times during the unregistration process. The `done` (second)
	/// parameter will be set to true when the unregistration process has completed. The
	/// handler should return `false` if the operation is to be stopped. This may be
	/// desirable after receiving an error.
	@available(OSX 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
	public static func unregister(fontDescriptors: [CTFontDescriptor], scope: Scope, registrationHandler: ((_ errors: [Error], _ done: Bool) -> Bool)?) {
		let regHand: ((CFArray, Bool) -> Bool)?
		if let newHand = registrationHandler {
			regHand = { (errs, isDone) -> Bool in
				return newHand(errs as! [Error], isDone)
			}
		} else {
			regHand = nil
		}
		
		CTFontManagerUnregisterFontDescriptors(fontDescriptors as NSArray, scope, regHand)
	}
	
	#if os(iOS)
	/// Resolves font descriptors specified on input. On iOS only, if the font descriptors
	/// cannot be found, the user is presented with a dialog indicating fonts that could not
	/// be resolved. The user may optionally be provided with a way to resolve the missing
	/// fonts if the font manager has a way to enable them.
	///
	/// On iOS, fonts registered by font provider applications in the persistent scope are
	/// not automatically available to other applications. Client applications must call this
	/// function to make the requested fonts available for font descriptor matching.
	/// - parameter fontDescriptors: Array of font descriptors to make available to the
	/// process.  Keys used to describe the fonts may be a combination of:
	/// `kCTFontNameAttribute`, `kCTFontFamilyNameAttribute`, or
	/// `kCTFontRegistrationUserInfoAttribute`.
	/// - parameter completionHandler: Block called after request operation completes. Block
	/// takes a single parameter containing an array of those descriptors that could not be
	/// resolved/found. The array can be empty if all descriptors were resolved.
	@available(iOS 13.0, *)
	public static func requestFonts(_ fontDescriptors: [CTFontDescriptor], completionHandler: @escaping ([CTFontDescriptor]) -> Void) {
		CTFontManagerRequestFonts(fontDescriptors as NSArray) { (arr) in
			completionHandler(arr as! [CTFontDescriptor])
		}
	}
	#endif
	
	/// Returns an array of font descriptors representing each of the fonts in the specified URL.
	///
	/// **Note:** these font descriptors are not available through font descriptor matching.
	/// - parameter fileURL: A file system URL referencing a valid font file.
	/// - returns: An array of `CTFontDescriptor`s or `nil` if there are no valid fonts.
	@available(OSX 10.6, iOS 7.0, watchOS 2.0, tvOS 9.0, *)
	public static func fontDescriptors(from fileURL: URL) -> [CTFontDescriptor]? {
		return CTFontManagerCreateFontDescriptorsFromURL(fileURL as NSURL) as NSArray? as? [CTFontDescriptor]
	}
	
	/// Returns a font descriptor representing the font in the supplied data.
	///
	/// **Note:** the font descriptor is not available through font descriptor matching.
	/// - parameter data: A `Data` containing font data.
	/// - returns: A font descriptor created from the data or `nil` if it is not a valid font.
	///
	/// If the data contains a font collection (TTC or OTC), only the first font in the collection will be
	/// returned.
	@available(OSX 10.7, iOS 7.0, watchOS 2.0, tvOS 9.0, *)
	public static func fontDescriptor(from data: Data) -> CTFontDescriptor? {
		return CTFontManagerCreateFontDescriptorFromData(data as NSData)
	}
	
	/// Returns an array of font descriptors for the fonts in the supplied data.
	///
	/// **Note:** the font descriptors are not available through font descriptor matching.
	/// - parameter data: A `Data` containing font data.
	/// - returns: An array of font descriptors. This can be an empty array in the event of
	/// invalid or unsupported font data.
	@available(OSX 10.13, iOS 11.0, watchOS 4.0, tvOS 11.0, *)
	public static func fontDescriptors(from data: Data) -> [CTFontDescriptor] {
		return CTFontManagerCreateFontDescriptorsFromData(data as NSData) as! [CTFontDescriptor]
	}
	
	/// Registers fonts from the specified font URL with the font manager. Registered fonts participate in font
	/// descriptor matching.
	/// - parameter fontURL: Font URL.
	/// - parameter scope: Scope constant defining the availability and lifetime of the registration. See scope
	/// constants for more details.
	@available(OSX 10.6, iOS 4.1, watchOS 2.0, tvOS 9.0, *)
	public static func registerFonts(at fontURL: URL, scope: Scope) throws {
		var maybeErr: Unmanaged<CFError>? = nil
		let toRet = CTFontManagerRegisterFontsForURL(fontURL as NSURL, scope, &maybeErr)
		guard toRet else {
			if let maybeErr = maybeErr?.takeRetainedValue() {
				throw maybeErr
			} else {
				throw CocoaError(.fileReadUnknown, userInfo: [NSURLErrorKey: fontURL])
			}
		}
	}
	
	/// Unregisters fonts from the specified font URL with the font manager. Unregistered fonts do not
	/// participate in font descriptor matching.
	///
	/// iOS note: only fonts registered with `FontManager.registerFonts(for:)`,
	/// `CTFontManagerRegisterFontsForURLs`, or `CTFontManagerRegisterFontsForURLs`
	/// can be unregistered with this API.
	/// - parameter fontURL: Font URL.
	/// - parameter scope: Scope constant defining the availability and lifetime of the registration. Should
	/// match the scope the fonts are registered in. See scope constants for more details.
	@available(OSX 10.6, iOS 4.1, watchOS 2.0, tvOS 9.0, *)
	public static func unregisterFonts(at fontURL: URL, scope: Scope) throws {
		var maybeErr: Unmanaged<CFError>? = nil
		let toRet = CTFontManagerUnregisterFontsForURL(fontURL as NSURL, scope, &maybeErr)
		guard toRet else {
			if let maybeErr = maybeErr?.takeRetainedValue() {
				throw maybeErr
			} else {
				throw CTAFontManagerError(.unsupportedScope, userInfo: [NSURLErrorKey: fontURL, (kCTFontManagerErrorFontURLsKey as String): [fontURL]])
			}
		}
	}

	/// Registers the specified graphics font with the font manager. Registered fonts participate in font
	/// descriptor matching.
	///
	/// Attempts to register a font that is either already registered or contains the same PostScript name of
	/// an already registered font will fail.
	///
	/// This functionality is useful for fonts that may be embedded in documents or present/constructed in
	/// memory. A graphics font is obtained by calling `CGFontCreateWithDataProvider`. Fonts that are
	/// backed by files should be registered using `FontManager.registerFonts(at:scope:)`.
	/// - parameter font: Graphics font to be registered.
	@available(OSX 10.8, iOS 4.1, watchOS 2.0, tvOS 9.0, *)
	public static func register(_ font: CGFont) throws {
		var maybeErr: Unmanaged<CFError>? = nil
		let toRet = CTFontManagerRegisterGraphicsFont(font, &maybeErr)
		guard toRet else {
			if let maybeErr = maybeErr?.takeRetainedValue() {
				throw maybeErr
			} else {
				throw CTAFontManagerError(.unsupportedScope)
			}
		}
	}

	/// Unregisters the specified graphics font with the font manager. Unregistered fonts do not participate in
	/// font descriptor matching.
	/// - parameter font: Graphics font to be unregistered.
	@available(OSX 10.8, iOS 4.1, watchOS 2.0, tvOS 9.0, *)
	public static func unregister(_ font: CGFont) throws {
		var maybeErr: Unmanaged<CFError>? = nil
		let toRet = CTFontManagerUnregisterGraphicsFont(font, &maybeErr)
		guard toRet else {
			if let maybeErr = maybeErr?.takeRetainedValue() {
				throw maybeErr
			} else {
				throw CTAFontManagerError(.unsupportedScope)
			}
		}
	}
	
	#if os(iOS)
	/// Registers named font assets in the specified bundle with the font manager. Registered
	/// fonts are discoverable through font descriptor matching in the calling process.
	///
	/// Font assets are extracted from the asset catalog and registered. This call must be
	/// made after the completion handler of either `NSBundleResourceRequest`
	/// `beginAccessingResourcesWithCompletionHandler:` or
	/// `conditionallyBeginAccessingResourcesWithCompletionHandler:` is called successfully.
	///
	/// Name the assets using Postscript names for individual faces, or family names for
	/// variable/collection fonts. The same names can be used to unregister the fonts with
	/// `CTFontManagerUnregisterFontDescriptors`. In iOS, fonts registered with the
	/// persistent scope are not automatically available to other processes. Other process
	/// may call `CTFontManagerRequestFonts` to get access to these fonts.
	/// - parameter fontAssetNames: Array of font name assets in asset catalog.
	/// - parameter bundle: Bundle containing asset catalog. A `nil` value resolves to the
	/// main bundle.
	/// - parameter scope: Scope constant defining the availability and lifetime of the
	/// registration. `kCTFontManagerScopePersistent` is the only supported scope for iOS.
	/// - parameter enabled: Boolean value indicating whether the font assets should be
	/// enabled for font descriptor matching and/or discoverable via
	/// `CTFontManagerRequestFonts`.
	/// - parameter registrationHandler: Block called as errors are discovered, or upon
	/// completion. The errors parameter contains an array of `CFError` references. An empty
	/// array indicates no errors. Each error reference will contain a `CFArray` of font
	/// asset names corresponding to `kCTFontManagerErrorFontAssetNameKey`. These represent
	/// the font asset names that were not successfully registered. Note, the handler may be
	/// called multiple times during the registration process. The `done` (second) parameter
	/// will be set to `true` when the registration process has completed. The handler should
	/// return `false` if the operation is to be stopped. This may be desirable after
	/// receiving an error.
	@available(iOS 13.0, *)
	public static func registerFonts(withAssetNames fontAssetNames: [String], bundle: CFBundle? = nil, scope: Scope, enabled: Bool, registrationHandler: ((_ errors: [Error], _ done: Bool) -> Bool)?) {
		let regHand: ((CFArray, Bool) -> Bool)?
		if let newHand = registrationHandler {
			regHand = { (errs, isDone) -> Bool in
				return newHand(errs as! [Error], isDone)
			}
		} else {
			regHand = nil
		}
		
		CTFontManagerRegisterFontsWithAssetNames(fontAssetNames as NSArray, bundle, scope, enabled, regHand)
	}
	#endif
	
	#if os(OSX)
	/// Enables the matching font descriptors for font descriptor matching.
	/// - parameter descriptors: Array of font descriptors.
	@available(OSX 10.6, *)
	public static func enable(_ descriptors: [CTFontDescriptor]) {
		CTFontManagerEnableFontDescriptors(descriptors as NSArray, true)
	}

	/// Disables the matching font descriptors for font descriptor matching.
	/// - parameter descriptors: Array of font descriptors.
	@available(OSX 10.6, *)
	public static func disable(_ descriptors: [CTFontDescriptor]) {
		CTFontManagerEnableFontDescriptors(descriptors as NSArray, false)
	}
	
	/// Returns the registration scope of the specified URL.
	/// - parameter fontURL: The font URL.
	/// - returns: Returns the registration scope of the specified URL, will return `FontManager.Scope.none` if
	/// not currently registered.
	@available(OSX 10.6, *)
	public static func scope(for fontURL: URL) -> Scope {
		return CTFontManagerGetScopeForURL(fontURL as NSURL)
	}
	
	/// Determines whether the referenced font data (usually by file URL) is supported on the current platform.
	/// - parameter fontURL: A URL to font data.
	/// - returns: This function returns `true` if the URL represents a valid font that can be used on the
	/// current platform.
	@available(OSX 10.6, *)
	public static func isSupportedFont(at fontURL: URL) -> Bool {
		return CTFontManagerIsSupportedFont(fontURL as NSURL)
	}
	
	/*! --------------------------------------------------------------------------
	@group Manager Auto-Activation
	*/
	//--------------------------------------------------------------------------
	//MARK:- Manager Auto-Activation

	/// Creates a `CFRunLoopSource` that will be used to convey font requests from `CTFontManager`.
	/// - parameter sourceOrder: The order of the created run loop source.
	/// - parameter createMatchesCallback: A block to handle the font request.
	/// - returns: A `CFRunLoopSource` that should be added to the run loop. To stop receiving requests,
	/// invalidate this run loop source. Will return `nil` on error, in the case of a duplicate `requestPortName`
	/// or invalid context structure.
	@available(OSX, introduced: 10.6, deprecated: 11.0, message: "This functionality will be removed in a future release")
	@inlinable public static func createFontRequestRunLoopSource(order sourceOrder: Int, _ createMatchesCallback: @escaping @convention(block) (_ requestAttributes: CFDictionary, _ requestingProcess: pid_t) -> Unmanaged<CFArray>) -> CFRunLoopSource? {
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
	/// - parameter bundleIdentifier: The bundle identifier. Used to specify a particular application bundle.
	/// If `nil`, the current application bundle will be used. If `FontManager.bundleIdentifier` is specified,
	/// will get the global auto-activation settings.
	/// - returns: Will return the auto-activation setting for specified bundle identifier.
	@available(OSX 10.6,*)
	public static func autoActivationSetting(forBundleIdentifier bundleIdentifier: String?) -> AutoActivationSetting {
		return CTFontManagerGetAutoActivationSetting(bundleIdentifier as NSString?)
	}
	#endif

	/// Notification name for font registry changes.
	///
	/// This is the string to use as the notification name when subscribing to `CTFontManager` notifications.
	/// This notification will be posted when fonts are added or removed.
	///
	/// macOS clients should register as an observer of the notification with the distributed notification
	/// center for changes in session or user scopes and with the local notification center for changes in
	/// process scope.
	///
	/// iOS clients should register as an observer of the notification with the local notification center for
	/// all changes.
	@available(OSX 10.6, iOS 7.0, watchOS 2.0, tvOS 9.0, *)
	public static var registeredFontsChanged: Notification.Name {
		return Notification.Name(kCTFontManagerRegisteredFontsChangedNotification as String)
	}
}
