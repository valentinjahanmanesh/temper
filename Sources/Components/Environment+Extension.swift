
//
//  Environment+Extension.swift
//
//
//  Created by Farshad Macbook M1 Pro.

import SwiftUI

public extension AppFontStyling where Self == AppDefaultFonts {
    static var defaults: Self {
        AppDefaultFonts()
    }
}

public extension AppColorStyling where Self == AppDefaultColors {
    static var defaults: Self {
        AppDefaultColors()
    }
}

public extension AppSpaceStyling where Self == AppDefaultSpaces {
    static var defaults: Self {
        AppDefaultSpaces()
    }
}

public extension AppIcons where Self == AppDefaultIcons {
    static var defaults: Self {
        AppDefaultIcons()
    }
}

public struct AppStylingKey: EnvironmentKey {
    public static var defaultValue: AppStyling = {
        return AppStyle(fonts: InterFonts(),
                        colors: .defaults,
                        spaces: .defaults,
                        icons: .defaults)
    }()
}

public extension EnvironmentValues {
    var styling: AppStyling {
        get {self[AppStylingKey.self]}
        set {self[AppStylingKey.self] = newValue}
    }
}
