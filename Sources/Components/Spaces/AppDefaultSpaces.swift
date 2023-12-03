//
//  AppDefaultSpaces.swift
//  
//
//  Created by Farshad Macbook M1 Pro.

import Foundation
public struct AppDefaultSpaces: AppSpaceStyling {
	public struct CornerRadius: AppSpacing {
		public let small: CGFloat = 8

		public let medium: CGFloat = 16

		public let large: CGFloat = 24
        public let maxLarge: CGFloat = 32
	}

	public var cornerRadius: AppSpacing = CornerRadius()

	public struct Horizontal: AppSpacing {
		public let small: CGFloat = 8
		public let medium: CGFloat = 16
		public let large: CGFloat = 24
        public let maxLarge: CGFloat = 32
	}

	public struct Vertical: AppSpacing {
		public let small: CGFloat = 8
		public let medium: CGFloat = 16
		public let large: CGFloat = 24
        public let maxLarge: CGFloat = 32
	}

	public let horizontal: AppSpacing = Horizontal()

	public let vertical: AppSpacing = Vertical()
}

public extension AppSpaceStyling {
	var defaultInputHeight: CGFloat {
		50
	}

	var defaultIconHeight: CGFloat {
		24
	}

	var defaultIconViewHeight: CGFloat {
		40
	}
}
