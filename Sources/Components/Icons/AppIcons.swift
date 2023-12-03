//
//  Icons.swift
//  
//
//  Created by Farshad Jahanmanesh.
//

import SwiftUI
public protocol AppIcons {
    func icon(_ icon: Icons) -> Image
}

public struct AppDefaultIcons: AppIcons {
    public func icon(_ icon: Icons) -> Image {
        icon.asImage
    }
}

public enum Icons: String {
	case Pin
	case Filter
    public var asImage: Image {
        return Image(self.rawValue.capitalized, bundle: AssetsBundle.moduleBundle)
    }
	public static func custom(name: String) -> Image {
		return Image(name, bundle: AssetsBundle.moduleBundle)
	}
}
