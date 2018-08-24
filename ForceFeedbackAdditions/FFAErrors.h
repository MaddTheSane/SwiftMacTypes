//
//  FFAErrors.h
//  ForceFeedbackAdditions
//
//  Created by C.W. Betts on 7/23/18.
//  Copyright © 2018 C.W. Betts. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <ForceFeedback/ForceFeedbackConstants.h>

#if ((__cplusplus && __cplusplus >= 201103L && (__has_extension(cxx_strong_enums) || __has_feature(objc_fixed_enum))) || (!__cplusplus && __has_feature(objc_fixed_enum))) && __has_attribute(ns_error_domain)
#define FFA_ERROR_ENUM(_domain, _name)     enum _name : HRESULT _name; enum __attribute__((ns_error_domain(_domain))) _name : HRESULT
#else
#define FFA_ERROR_ENUM(_domain, _name) NS_ENUM(HRESULT, _name)
#endif

/// The error domain of \c ForceFeedbackResult
extern NSErrorDomain const ForceFeedbackResultErrorDomain;

typedef FFA_ERROR_ENUM(ForceFeedbackResultErrorDomain, ForceFeedbackResult) {
	//! The operation completed successfully.
	ForceFeedbackResultOk = FF_OK,
	
	//! The operation did not complete successfully.
	ForceFeedbackResultFalse = FF_FALSE,
	
	//! The parameters of the effect were successfully updated by
	//! <code>ForceFeedbackEffect.setParameters(_:flags:)</code>, but the effect was not
	//! downloaded because the \c ForceFeedbackEffect.EffectStart.noDownload
	//! flag was passed.
	ForceFeedbackResultDownloadSkipped = FF_DOWNLOADSKIPPED,
	
	//! The parameters of the effect were successfully updated by
	//! <code>ForceFeedbackEffect.setParameters(_:flags:)</code>, but in order to change
	//! the parameters, the effect needed to be restarted.
	ForceFeedbackResultEffectRestarted = FF_EFFECTRESTARTED,
	
	//! The parameters of the effect were successfully updated by
	//! <code>ForceFeedbackEffect.setParameters(_:flags:)</code>, but some of them were
	//! beyond the capabilities of the device and were truncated.
	ForceFeedbackResultTruncated = FF_TRUNCATED,
	
	//! Equal to <code>ForceFeedbackResult([.effectRestarted, .truncated])</code>
	ForceFeedbackResultTruncatedAndRestarted = FF_TRUNCATEDANDRESTARTED,
	
	//! An invalid parameter was passed to the returning function,
	//! or the object was not in a state that admitted the function
	//! to be called.
	ForceFeedbackResultInvalidParameter = FFERR_INVALIDPARAM,
	
	//! The specified interface is not supported by the object.
	ForceFeedbackResultNoInterface = FFERR_NOINTERFACE,
	
	//! An undetermined error occurred.
	ForceFeedbackResultGeneric = FFERR_GENERIC,
	
	//! Couldn't allocate sufficient memory to complete the caller's request.
	ForceFeedbackResultOutOfMemory = FFERR_OUTOFMEMORY,
	
	//! The function called is not supported at this time
	ForceFeedbackResultUnsupported = FFERR_UNSUPPORTED,
	
	//! Data is not yet available.
	ForceFeedbackResultPending = (HRESULT)(E_PENDING),
	
	//! The device is full.
	ForceFeedbackResultDeviceFull = (HRESULT)(FFERR_DEVICEFULL),
	
	//! The device or device instance or effect is not registered.
	ForceFeedbackResultDeviceNotRegistered = -2147221164,
	
	//! Not all the requested information fit into the buffer.
	ForceFeedbackResultMoreData = (HRESULT)(FFERR_MOREDATA),
	
	//! The effect is not downloaded.
	ForceFeedbackResultNotDownloaded = (HRESULT)(FFERR_NOTDOWNLOADED),
	
	//! The device cannot be reinitialized because there are still effects
	//! attached to it.
	ForceFeedbackResultHasEffects = (HRESULT)(FFERR_HASEFFECTS),
	
	//! The effect could not be downloaded because essential information
	//! is missing.  For example, no axes have been associated with the
	//! effect, or no type-specific information has been created.
	ForceFeedbackResultIncompleteEffect = (HRESULT)(FFERR_INCOMPLETEEFFECT),
	
	//! An attempt was made to modify parameters of an effect while it is
	//! playing.  Not all hardware devices support altering the parameters
	//! of an effect while it is playing.
	ForceFeedbackResultEffectPlaying = (HRESULT)(FFERR_EFFECTPLAYING),
	
	//! The operation could not be completed because the device is not
	//! plugged in.
	ForceFeedbackResultUnplugged = (HRESULT)(FFERR_UNPLUGGED),
	
#pragma mark Mac OS X-specific
	//! The effect index provided by the API in downloadID is not recognized by the
	//! \b IOForceFeedbackLib driver.
	ForceFeedbackResultInvalidDownloadID = (HRESULT)(FFERR_INVALIDDOWNLOADID),
	
	//! When the device is paused via a call to <code>ForceFeedbackDevice.sendCommand(_:)</code>,
	//! other operations such as modifying existing effect parameters and creating
	//! new effects are not allowed.
	ForceFeedbackResultDevicePaused = (HRESULT)(FFERR_DEVICEPAUSED),
	
	//! The \b IOForceFededbackLib driver has detected an internal fault.  Often this
	//! occurs because of an unexpected internal code path.
	ForceFeedbackResultInternal = (HRESULT)(FFERR_INTERNAL),
	
	//! The \b IOForceFededbackLib driver has received an effect modification request
	//! whose basic type does not match the defined effect type for the given effect.
	ForceFeedbackResultEffectTypeMismatch = (HRESULT)(FFERR_EFFECTTYPEMISMATCH),
	
	//! The effect includes one or more axes that the device does not support.
	ForceFeedbackResultUnsupportedAxis = (HRESULT)(FFERR_UNSUPPORTEDAXIS),
	
	//! This object has not been initialized.
	ForceFeedbackResultNotInitialized = (HRESULT)(FFERR_NOTINITIALIZED),
	
	//! The device has been released.
	ForceFeedbackResultDeviceReleased = (HRESULT)(FFERR_DEVICERELEASED),
	
	//! The effect type requested is not explicitly supported by the particular device.
	ForceFeedbackResultEffectTypeNotSupported = (HRESULT)(FFERR_EFFECTTYPENOTSUPPORTED),
};

#undef FFA_ERROR_ENUM
