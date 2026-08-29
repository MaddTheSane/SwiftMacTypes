//
//  CFPlugIn.swift
//  SwiftAdditions
//
//  Created by C.W. Betts on 8/27/26.
//  Copyright © 2026 C.W. Betts. All rights reserved.
//

import Foundation
import CoreFoundation
import CoreFoundation.CFPlugIn
import CoreFoundation.CFPlugInCOM

/// The IUnknown interface
public var IUnknownUUID: CFUUID {
	return CFUUIDGetConstantUUIDWithBytes(kCFAllocatorSystemDefault, 0x00, 0x00, 0x00, 0x00,
										  0x00, 0x00, 0x00, 0x00, 0xC0, 0x00, 0x00, 0x00,
										  0x00, 0x00, 0x00, 0x46)
}

public extension CFPlugIn {
	
	/// Returns a plug-in's bundle.
	///
	/// You should *always* use this getter to get a plug-in's bundle. Never attempt to access the plug-in directly as a bundle.
	@inlinable var bundle: CFBundle {
		return CFPlugInGetBundle(self)
	}
	
	/// Enables or disables load on demand for plug-ins that do dynamic registration (only when a client requests
	/// an instance of a supported type).
	///
	/// Is `true` if the plug-in is loaded only when a client requests an instance of a supported type, otherwise `false`.
    ///
	///Plug-ins that do static registration are load on demand by default. Plug-ins that do dynamic registration are not load on
	///demand by default.
	@inlinable var loadOnDemand: Bool {
		get {
			return CFPlugInIsLoadOnDemand(self)
		}
		set {
			CFPlugInSetLoadOnDemand(self, newValue)
		}
	}
	
	/// Searches all registered plug-ins for factory functions capable of creating an instance of the given type.
	/// - parameter type: A UUID type.
	/// - returns: An array of UUIDs for factory functions capable of creating an instance of the given type.
	@inlinable static func findFactories(for type: CFUUID) -> [CFUUID]? {
		return CFPlugInFindFactoriesForPlugInType(type) as? [CFUUID]
	}
	
	/// Searches the plug-in for factory functions capable of creating an instance of the given type.
	/// - parameter type: A UUID type.
	/// - returns: An array of UUIDs for factory functions capable of creating an instance of the given type.
	@inlinable func findFactories(for type: CFUUID) -> [CFUUID]? {
		return CFPlugInFindFactoriesForPlugInTypeInPlugIn(type, self) as? [CFUUID]
	}
	
	/// Creates a CFPlugIn instance of a given type using a given factory.
	/// - parameter factoryUUID: The UUID representing the factory function to use to create a plug-in of the given type.
	/// - parameter typeUUID: The UUID type.
	/// - returns: Returns the `IUnknown` interface for the new plug-in.
	///
	/// The plug-in host uses this function to create an instance of the given type. Unless the plug-in is using dynamic
	/// registration, this function causes the plug-in's code to be loaded into memory.
	@inlinable func createInstance(factory factoryUUID: CFUUID, type typeUUID: CFUUID) -> UnsafeMutableRawPointer? {
		return CFPlugInInstanceCreate(nil, factoryUUID, typeUUID)
	}
	
	/// Registers a factory function and its UUID with a `CFPlugIn` object.
	/// - parameter factoryUUID: The `CFUUID` object representing the factory function to register.
	/// - parameter function: The factory function pointer to register.
	/// - returns: `true` if the factory function was successfully registered, otherwise `false`.
	///
	/// This function is used by a plug-in or host when performing dynamic registration.
	@inlinable static func registerFactory(for factoryUUID: CFUUID, function: CFPlugInFactoryFunction) -> Bool {
		return CFPlugInRegisterFactoryFunction(factoryUUID, function)
	}
	
	/// Registers a factory function with this object using the function's name instead of its UUID.
	/// - parameter factoryUUID: The `CFUUID` object representing the factory function to register.
	/// - parameter functionName: The name of the factory function to register.
	/// - returns: `true` if the factory function was successfully registered, otherwise `false`.
	///
	/// This function is used by a plug-in or host when performing dynamic registration.
	@inlinable func registerFactory(for factoryUUID: CFUUID, byName functionName: CFString) -> Bool {
		return CFPlugInRegisterFactoryFunctionByName(factoryUUID, self, functionName)
	}
	
	/// Removes the given function from a plug-in's list of registered factory functions.
	/// - parameter factoryUUID: The `CFUUID` object representing the factory to unregister.
	/// - returns: `true` if the factory function was successfully unregistered, otherwise `false`.
	///
	/// Used by a plug-in or host when performing dynamic registration.
	@inlinable static func unregisterFactory(for factoryUUID: CFUUID) -> Bool {
		return CFPlugInUnregisterFactory(factoryUUID)
	}
	
	/// Registers a type and its corresponding factory function with a `CFPlugIn` object.
	/// - parameter factoryUUID: The `CFUUID` object representing the factory function that can create the type being registered.
	/// - parameter typeUUID: The UUID type to register.
	/// - returns: `true` if the factory function was successfully registered, otherwise `false`.
	///
	/// This function is used by a plug-in or host when performing dynamic registration.
	@inlinable static func registerPlugInType(factory factoryUUID: CFUUID, type typeUUID: CFUUID) -> Bool {
		return CFPlugInRegisterPlugInType(factoryUUID, typeUUID)
	}

	/// Removes the given type from a plug-in's list of registered types.
	/// - parameter factoryUUID: The `CFUUID` object representing the factory function for the type to unregister.
	/// - parameter typeUUID: The UUID type to unregister.
	/// - returns: `true` if the factory function was successfully unregistered, otherwise `false`.
	///
	/// Used by a plug-in or host when performing dynamic registration.
	@inlinable static func unregisterPlugInType(factory factoryUUID: CFUUID, type typeUUID: CFUUID) -> Bool {
		return CFPlugInUnregisterPlugInType(factoryUUID, typeUUID)
	}
	
	/// Registers a new instance of a type with `CFPlugIn`.
	/// - parameter factoryUUID: The `CFUUID` object representing the plug-in factory.
	@inlinable static func addInstance(for factoryUUID: CFUUID) {
		CFPlugInAddInstanceForFactory(factoryUUID)
	}
	
	/// Unregisters an instance of a type with `CFPlugIn`.
	/// - parameter factoryUUID: The `CFUUID` object representing the plug-in factory.
	///
	/// If the instance counts of every factory in a plug-in are zero, the plug-in can be unloaded.
	@inlinable static func removeInstance(for factoryUUID: CFUUID) {
		CFPlugInRemoveInstanceForFactory(factoryUUID)
	}
	
	/// Creates a CFPlugIn given its URL.
	/// - parameter url: The location of the plug-in.
	/// - returns: A new plug-in.
	@inlinable static func load(from url: CFURL) -> CFPlugIn? {
		CFPlugInCreate(nil, url)
	}
}

// MARK: - Swift/CoreFoundation bridging

public extension CFPlugIn {
	/// Searches all registered plug-ins for factory functions capable of creating an instance of the given type.
	/// - parameter type: A `UUID` type.
	/// - returns: An array of `UUID`s for factory functions capable of creating an instance of the given type.
	static func findFactories(for type: UUID) -> [UUID]? {
		if let ret1 = findFactories(for: type.cfUUID) {
			return ret1.map({val in
				return UUID(cfUUID: val)
			})
		}
		return nil
	}
	
	/// Searches the plug-in for factory functions capable of creating an instance of the given type.
	/// - parameter type: A `UUID` type.
	/// - returns: An array of `UUID`s for factory functions capable of creating an instance of the given type.
	func findFactories(for type: UUID) -> [UUID]? {
		if let ret1 = findFactories(for: type.cfUUID) {
			return ret1.map({val in
				return UUID(cfUUID: val)
			})
		}
		return nil
	}
	
	/// Creates a CFPlugIn instance of a given type using a given factory.
	/// - parameter factoryUUID: The `UUID` representing the factory function to use to create a plug-in of the given type.
	/// - parameter typeUUID: The `UUID` type.
	/// - returns: Returns the `IUnknown` interface for the new plug-in.
	///
	/// The plug-in host uses this function to create an instance of the given type. Unless the plug-in is using dynamic
	/// registration, this function causes the plug-in's code to be loaded into memory.
	func createInstance(factory factoryUUID: UUID, type typeUUID: UUID) -> UnsafeMutablePointer<UnsafeMutablePointer<IUnknownVTbl>>? {
		guard let val = createInstance(factory: factoryUUID.cfUUID, type: typeUUID.cfUUID) else {
			return nil
		}
		let val2 = val.assumingMemoryBound(to: UnsafeMutablePointer<IUnknownVTbl>.self)
		return val2;
	}
	
	/// Registers a factory function and its UUID with a `CFPlugIn` object.
	/// - parameter factoryUUID: The `UUID` object representing the factory function to register.
	/// - parameter function: The factory function pointer to register.
	/// - returns: `true` if the factory function was successfully registered, otherwise `false`.
	///
	/// This function is used by a plug-in or host when performing dynamic registration.
	static func registerFactory(for factoryUUID: UUID, function: CFPlugInFactoryFunction) -> Bool {
		return registerFactory(for: factoryUUID.cfUUID, function: function)
	}
	
	/// Registers a factory function with this object using the function's name instead of its `UUID`.
	/// - parameter factoryUUID: The `UUID` object representing the factory function to register.
	/// - parameter functionName: The name of the factory function to register.
	/// - returns: `true` if the factory function was successfully registered, otherwise `false`.
	///
	/// This function is used by a plug-in or host when performing dynamic registration.
	func registerFactory(for factoryUUID: UUID, byName functionName: String) -> Bool {
		return registerFactory(for: factoryUUID.cfUUID, byName: functionName as NSString)
	}
	
	/// Removes the given function from a plug-in's list of registered factory functions.
	/// - parameter factoryUUID: The CFUUID object representing the factory to unregister.
	/// - returns: `true` if the factory function was successfully unregistered, otherwise `false`.
	///
	/// Used by a plug-in or host when performing dynamic registration.
	static func unregisterFactory(for factoryUUID: UUID) -> Bool {
		return unregisterFactory(for: factoryUUID.cfUUID)
	}
	
	/// Registers a type and its corresponding factory function with a `CFPlugIn` object.
	/// - parameter factoryUUID: The `CFUUID` object representing the factory function that can create the type being registered.
	/// - parameter typeUUID: The UUID type to register.
	/// - returns: `true` if the factory function was successfully registered, otherwise `false`.
	///
	/// This function is used by a plug-in or host when performing dynamic registration.
	static func registerPlugInType(factory factoryUUID: UUID, type typeUUID: UUID) -> Bool {
		return registerPlugInType(factory: factoryUUID.cfUUID, type: typeUUID.cfUUID)
	}

	/// Removes the given type from a plug-in's list of registered types.
	/// - parameter factoryUUID: The `UUID` object representing the factory function for the type to unregister.
	/// - parameter typeUUID: The UUID type to unregister.
	/// - returns: `true` if the factory function was successfully unregistered, otherwise `false`.
	///
	/// Used by a plug-in or host when performing dynamic registration.
	static func unregisterPlugInType(factory factoryUUID: UUID, type typeUUID: UUID) -> Bool {
		return unregisterPlugInType(factory: factoryUUID.cfUUID, type: typeUUID.cfUUID)
	}
	
	/// Registers a new instance of a type with `CFPlugIn`.
	/// - parameter factoryUUID: The `UUID` object representing the plug-in factory.
	 static func addInstance(for factoryUUID: UUID) {
		 addInstance(for: factoryUUID.cfUUID)
	}
	
	/// Unregisters an instance of a type with `CFPlugIn`.
	/// - parameter factoryUUID: The `UUID` object representing the plug-in factory.
	///
	/// If the instance counts of every factory in a plug-in are zero, the plug-in can be unloaded.
	static func removeInstance(for factoryUUID: UUID) {
		removeInstance(for: factoryUUID.cfUUID)
	}
	
	/// Creates a CFPlugIn given its URL.
	/// - parameter url: The location of the plug-in.
	/// - returns: A new plug-in.
	static func load(from url: URL) -> CFPlugIn? {
		load(from: url as CFURL)
	}
}
