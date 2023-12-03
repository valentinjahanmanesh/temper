//
//  PreferenceNavigationBar.swift
//
//
//  Created by Farshad Jahanmanesh.
//

import SwiftUI
public extension View {
	@ViewBuilder
	func preferenceNavigationBar(title: LocalizedStringKey) -> some View {
		self.preference(key: NavigationBarTitlePreferenceKey.self, value: title)
	}
}
