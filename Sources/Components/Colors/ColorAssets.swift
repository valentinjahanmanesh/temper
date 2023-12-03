//
//  ColorAssets.swift
//  
//
//  Created by Farshad Jahanmanesh.
//

import Foundation
import SwiftUI
public class ColorAssets {
	public static let onSurfaceFixed = "On_Surface_Fixed"
	public static let surfaceFixed = "Surface_Fixed"
	public static let infoFixed = "info_Fixed"
	public static let primaryFixed = "Primary_Fixed"
	public static let onPrimaryFixed = "On_Primary_Fixed"

    public static let shared: ColorAssets = ColorAssets()


    func bundledColor(_ colorName: String) -> Color {
        Color(colorName, bundle: AssetsBundle.moduleBundle)
    }
}


