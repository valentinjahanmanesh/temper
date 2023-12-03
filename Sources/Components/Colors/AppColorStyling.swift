//
//  AppColorStyling.swift
//
//
//  Created by Farshad Macbook M1 Pro.

import struct SwiftUI.Color
public protocol AppColorStyling {
	var onSurfaceFixed: Color {get}
	var surfaceFixed: Color {get}
	var infoFixed: Color {get}
	var primaryFixed: Color {get}
	var onPrimaryFixed: Color {get}
}
