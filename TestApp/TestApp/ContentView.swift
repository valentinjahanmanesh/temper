//
//  ContentView.swift
//  TestApp
//
//  Created by Farshad Macbook M1 Pro.
//

import SwiftUI
import App
import ComposableArchitecture
struct ContentView: View {
    var body: some View {
		AppScreen(
			store: Store(initialState: AppFeature.State.init()) {
				AppFeature()
			})
    }
}

#Preview {
    ContentView()
}
