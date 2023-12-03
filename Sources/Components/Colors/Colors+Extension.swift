//
//  Colors.swift
//  
//
//  Created by Farshad Macbook M1 Pro.

import Foundation
import struct SwiftUI.Color
public extension Colors {
	struct Resource {
		public let name: String
		public let bundle: Bundle
		public init(name: String, bundle: Bundle) {
			self.name = name
			self.bundle = bundle
		}
	}
	enum Catalog: String {
		case Standard
		case Pastel

		public func color(_ colorName: ColorNames) -> Color {
            Color("\(self)/\(colorName.rawValue)", bundle: AssetsBundle.moduleBundle)
		}
	}
	enum ColorNames: String {
		case onSurfaceFixed = "On_Surface_Fixed"
		case surfaceFixed = "Surface_Fixed"
		case infoFixed = "info_Fixed"
		case primaryFixed = "Primary_Fixed"
		case onPrimaryFixed = "On_Primary_Fixed"
	}
}
