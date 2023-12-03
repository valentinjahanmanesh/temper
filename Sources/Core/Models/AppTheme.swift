//
//  AppTheme.swift
//  
//
//  Created by Farshad Jahanmanesh.
//

import Foundation

public enum AppTheme: String, CaseIterable, Identifiable {
	public var id: String {
		self.rawValue
	}
	case automatic = "Automatic"
	case dark = "Dark"
	case light = "Light"

	public var displayName: String {
		self.rawValue
	}
}
