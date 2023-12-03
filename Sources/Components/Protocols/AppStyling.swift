//
//  AppStyling.swift
//  
//
//  Created by Farshad Macbook M1 Pro.

import Foundation
public protocol AppStyling {
	var fonts: AppFontStyling {get}
	var colors: AppColorStyling {get}
	var spaces: AppSpaceStyling {get}
    var icons: AppIcons {get}
}
