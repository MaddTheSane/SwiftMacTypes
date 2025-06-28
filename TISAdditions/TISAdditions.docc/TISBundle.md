# Text Input Sources properties and bundle-packaged text input sources

For Leopard, there are two new keys for use in plists to provide information
that supports the Text Input Sources functions above (these keys will be
ignored in earlier systems):

"`TISInputSourceID`" - a key to specify the InputSourceID, a reverse-DNS-style
string meant to uniquely identify any input source. If this key is not
specified, the Text Input Sources functions will attempt to construct an
InputSourceID from other information.

"`TISIntendedLanguage`" - a key to specify the primary language which the
input source is intended to input. If there is none - as with the Unicode
Hex Input key layout, for example - this key need not be specified. The
language is indicated by a string in in the format described by BCP 47
(the successor to RFC 3066).

How these keys are used depends on the type of input source, as described
below.


## Keyboard layouts ( in <domain>/Library/Keyboard Layouts/ )


Keyboard layouts packaged in bundles use either a resource file or a set of
xml keylayout files together with optional icns files. The following example
shows the two methods of packaging a set of two key layouts in Unicode 'uchr'
format with key layout names "MyLayoutOne" and "MyLayoutTwo" and corresponding
numeric IDs *-9001* and *-9002* (see Tech Note 2056).

```
MyKeyboardLayouts.bundle/
   Contents/
	   Info.plist
	   version.plist
	   Resources/
		   MyKeyboardLayouts.rsrc, containing the following resources:
			   resources 'uchr' (-9001, "MyLayoutOne"), 'kcs#' (-9001), 'kcs4' (-9001)
			   resources 'uchr' (-9002, "MyLayoutTwo"), 'kcs#' (-9002), 'kcs4' (-9002)
		   en.lproj/InfoPlist.strings, maps "MyLayoutOne" & "MyLayoutTwo" to localized names
		   ja.lproj/InfoPlist.strings, maps "MyLayoutOne" & "MyLayoutTwo" to localized names
		   ...

MyKeyboardLayouts.bundle/
   Contents/
	   Info.plist
	   version.plist
	   Resources/
		   MyLayoutOne.keylayout, specifying name="MyLayoutOne" and id=-9001
		   MyLayoutOne.icns (optional)
		   MyLayoutTwo.keylayout, specifying name="MyLayoutTwo" and id=-9002
		   MyLayoutTwo.icns (optional)
		   en.lproj/InfoPlist.strings, maps "MyLayoutOne" & "MyLayoutTwo" to localized names
		   ja.lproj/InfoPlist.strings, maps "MyLayoutOne" & "MyLayoutTwo" to localized names
		   ...
```

In the Info.plist file, the value for the CFBundleIdentifier key must be a
string that includes ".keyboardlayout."; typically this might be something
like "com.companyname.keyboardlayout.MyKeyboardLayouts" (Before Leopard,
it was required to be a string that began "com.apple.keyboardlayout", even
for keyboard layouts not supplied by Apple).

A dictionary of properties for each key layout in the bundle should be
provided using a key of the form "KLInfo_keylayoutname" (even if
keylayoutname includes spaces or punctuation). This dictionary is where to
specify the keys "TISInputSourceID" and "TISIntendedLanguage" and their
associated values.

"TISInputSourceID" note: For keyboard layouts this should typically be
something like "com.companyname.keylayout.keylayoutname". If this key is
not specified, an InputSourceID will be constructed by combining
*bundleID + ". keylayout." + keylayoutname*.

If the keyboard layouts in the above example were intended to input
Azerbaijani in Latin script, then the Info.plist entries could be:

```plist
<key>KLInfo_MyLayoutOne</key>
<dict>
   <key>TISInputSourceID</key>
   <string>com.companyname.keylayout.MyLayoutOne</string>
   <key>TISIntendedLanguage</key>
   <string>az-Latn</string>
</dict>
<key>KLInfo_MyLayoutTwo</key>
<dict>
   <key>TISInputSourceID</key>
   <string>com.companyname.keylayout.MyLayoutTwo</string>
   <key>TISIntendedLanguage</key>
   <string>az-Latn</string>
</dict>
```

## Input methods

Input methods are always packaged as bundles, either as Component bundles
in "<domain>/Library/Components/" (the old way, still supported in Leopard)
or as application bundles in "<domain>/Library/Input Methods/" (new for
Leopard).

The new keys "`TISInputSourceID`" and "`TISIntendedLanguage`" and their
associated values are added at the top level of the Info.plist file.

"`TISInputSourceID`" note: For input methods this is typically the same as
the BundleID, and if this key is not specified the BundleID will be used
as the InputSourceID.


## Input modes

An input method's input modes are defined using the "ComponentInputModeDict"
key at the top level of the input method's Info.plist file (even for
non-component application-based input methods). The value of this key is a
dictionary, one of whose keys is "tsInputModeListKey"; the value of this
key is also a dictionary of input modes, with the InputModeID as the key
and the input mode's dictionary as the value (see TextServices.h).

The new keys keys "TISInputSourceID" and "TISIntendedLanguage" and their
associated values are added to the input mode's dictionary.

"TISInputSourceID" note: For input modes this is a string that begins with
the parent input method's InputSourceID or BundleID, followed by something
that identifies the mode. For example, "com.apple.Kotoeri.Japanese.Katakana".
In general it is not necessarily the same as the InputModeID, since a
particular InputModeID such as "com.apple.inputmethod.Japanese.Katakana"
may be used by multiple input methods. If this key is not specified, an
InputSourceID will be constructed by combining the BundleID with an
InputModeID suffix formed by deleting any prefix that matches the BundleID
or that ends in ".inputmethod."
