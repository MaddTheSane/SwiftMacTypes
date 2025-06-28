# ``TISAdditions``

Swift additions for the `TISInputSource` Core Foundation object, including wrappers around common enumerations with Swift-friendly versions.

<!--## Overview-->
<!---->
<!--<!--@START_MENU_TOKEN@-->Text<!--@END_MENU_TOKEN@-->-->

## Topics

### Property Key Constants

- ``TISAdditions/Carbon/TISInputSource/SourceType``
- ``TISAdditions/Carbon/TISInputSource/Property``
- ``TISAdditions/Carbon/TISInputSource/SourceCategory``

### Find out information about text input sources
Find out information about text input sources

- ``TISAdditions/Carbon/TISInputSource/value(for:)``
- ``TISAdditions/Carbon/TISInputSource/inputSourceList(matching:includeAllInstalled:)``

### Specific Input Sources

Get specific input sources.

- ``TISAdditions/Carbon/TISInputSource/currentKeyboard``
- ``TISAdditions/Carbon/TISInputSource/currentKeyboardLayout``
- ``TISAdditions/Carbon/TISInputSource/currentASCIICapableKeyboard``
- ``TISAdditions/Carbon/TISInputSource/currentASCIICapableKeyboardLayout``
- ``TISAdditions/Carbon/TISInputSource/inputSource(forLanguage:)``
- ``TISAdditions/Carbon/TISInputSource/asciiCapableList``

### Manipulate Input Sources
- ``TISAdditions/Carbon/TISInputSource/select()``
- ``TISAdditions/Carbon/TISInputSource/deselect()``
- ``TISAdditions/Carbon/TISInputSource/enable()``
- ``TISAdditions/Carbon/TISInputSource/disable()``

### Notification Constants
- ``TISAdditions/CoreFoundation/CFNotificationName/TISSelectedKeyboardInputSourceChanged``
- ``TISAdditions/CoreFoundation/CFNotificationName/TISEnabledKeyboardInputSourcesChanged``

### Override Keyboard Layouts.

Allow input method to override keyboard layout.

- ``TISAdditions/Carbon/TISInputSource/setAsOverride()``
- ``TISAdditions/Carbon/TISInputSource/keyboardLayoutOverride``

### Install/register an input source
- ``TISAdditions/Carbon/TISInputSource/registerInputSource(at:)``

### Additional Getters
These are just getters that call ``TISAdditions/Carbon/TISInputSource/value(for:)``

- ``TISAdditions/Carbon/TISInputSource/category``
- ``TISAdditions/Carbon/TISInputSource/isEnableCapable``
- ``TISAdditions/Carbon/TISInputSource/isSelectCapable``
- ``TISAdditions/Carbon/TISInputSource/isEnabled``
- ``TISAdditions/Carbon/TISInputSource/isSelected``
- ``TISAdditions/Carbon/TISInputSource/isASCIICapable``
- ``TISAdditions/Carbon/TISInputSource/unicodeKeyLayout``
- ``TISAdditions/Carbon/TISInputSource/imageURL``
- ``TISAdditions/Carbon/TISInputSource/bundleID``
- ``TISAdditions/Carbon/TISInputSource/localizedName``
- ``TISAdditions/Carbon/TISInputSource/iconRef``
- ``TISAdditions/Carbon/TISInputSource/languages``
- ``TISAdditions/Carbon/TISInputSource/inputSourceID``
- ``TISAdditions/Carbon/TISInputSource/inputModeID``
- ``TISAdditions/Carbon/TISInputSource/sourceType``

### CFTypeProtocol Implementations

- ``TISAdditions/Carbon/TISInputSource/typeID``
