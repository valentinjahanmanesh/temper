//
//  AppStyle.swift
//  
//
//  Created by Farshad Macbook M1 Pro.

import Foundation
public struct AppStyle: AppStyling {
	public init(
		fonts: AppFontStyling,
		colors: AppColorStyling,
		spaces: AppSpaceStyling,
        icons: AppIcons) {
			self.fonts = fonts 
			self.colors = colors 
			self.spaces = spaces
            self.icons = icons
	}
    public let icons: AppIcons

	public let fonts: AppFontStyling

	public let colors: AppColorStyling

	public let spaces: AppSpaceStyling
}
