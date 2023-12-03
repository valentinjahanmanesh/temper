//
//  Colors.swift
//  
//
//  Created by Farshad Macbook M1 Pro.

import Foundation
import struct SwiftUI.Color
public struct Colors: RawRepresentable {
	public init(rawValue: Color) {
		self.rawValue = rawValue
	}

	public var rawValue: Color
}
