//
//  misc.swift
//  SwiftIOKitAdditions
//
//  Created by C.W. Betts on 6/14/21.
//  Copyright © 2021 C.W. Betts. All rights reserved.
//

import Foundation
import SwiftAdditions
import IOKit.hid

extension IOHIDDevice: CFTypeProtocol {}
extension IOHIDElement: CFTypeProtocol {}
extension IOHIDManager: CFTypeProtocol {}
extension IOHIDQueue: CFTypeProtocol {}
extension IOHIDTransaction: CFTypeProtocol {}
extension IOHIDValue: CFTypeProtocol {}
