//
//  Fonts.swift
//  
//
//  Created by Farshad Macbook M1 Pro.

import Foundation
import CoreGraphics
import CoreText
import UIKit

public extension Fonts {
	fileprivate static let interFonts: [String] = [
        "Inter-Black",
        "Inter-Bold",
        "Inter-ExtraBold",
        "Inter-ExtraLight",
        "Inter-Light",
        "Inter-Medium",
        "Inter-Regular",
        "Inter-SemiBold",
        "Inter-Thin"]

	var fonts: [String] {
		switch self {
		case .inter:
			return Fonts.interFonts
		}
	}

	private func getFontsURL() -> [URL] {
		let bundle = Bundle.module
		return self.fonts.map({ bundle.url(forResource: "Raw/Fonts/" + $0, withExtension: "ttf")! })
	}

	func register() {
		self.getFontsURL().forEach { url in
			guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
				fatalError("\(url) not found in bundle \(Bundle.module).")
			}
			let font = CGFont(fontDataProvider)
			guard let font else {
				fatalError("\(fontDataProvider) is corrupted.")
			}
			var error: Unmanaged<CFError>?
			
			guard CTFontManagerRegisterGraphicsFont(font, &error) else {
				fatalError("\(fontDataProvider) \n \(error!.takeUnretainedValue())")
			}
		}
	}
}


