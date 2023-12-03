
//
//  FiltersScreen.swift
//
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation
import SwiftUI
import Components
import Core
import ComposableArchitecture
import Repository

public struct FiltersFeature: Reducer {
	public init(){}
	public struct State: Equatable {
		public init(){}
	}
	public enum Localization {
		static let navigationBarTitle: LocalizedStringKey = "filters.screen.title"
	}
	public enum Action: Equatable {
		case viewDidLoad
	}

	public var body: some ReducerOf<Self> {
		Reduce {state, action in
			switch action {
			case .viewDidLoad:
				state = .init()
				return .none
			}
		}
	}
}

public struct FiltersScreen: View {
	@Environment(\.styling) private var styling
	let store: StoreOf<FiltersFeature>
	public init(
		store: StoreOf<FiltersFeature>
	) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(self.store, observe: {$0}){ viewStore in
			Screen(paddingHorizontal: 0, showBackground: false) {
				VStack{
					Spacer()
					NavigationTitleView(FiltersFeature.Localization.navigationBarTitle)
						.frame(maxWidth: .infinity)
					Spacer()
				}
				.padding(.top, 1)
				.preferenceNavigationBar(title: FiltersFeature.Localization.navigationBarTitle)
			}
			.onAppear {
				Task {
					viewStore.send(.viewDidLoad)
				}
			}
			.background(Color.red)
		}
	}
}

#Preview {
	FiltersScreen(
		store: Store(initialState: FiltersFeature.State.init()) {
			FiltersFeature()
		})
	.preferredColorScheme(.dark)
}


