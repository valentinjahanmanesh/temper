//
//  LoginScreen.swift
//
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation
import SwiftUI
import Components
import Core
import ComposableArchitecture

public struct LoginFeature: Reducer {
	public init(){}
	public struct State: Equatable {
		public init(){}
	}
	public enum Localization {
		static let navigationBarTitle: LocalizedStringKey = "login.screen.title"
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

public struct LoginScreen: View {
	@Environment(\.styling) private var styling
	let store: StoreOf<LoginFeature>
	public init(
		store: StoreOf<LoginFeature>
	) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(self.store, observe: {$0}){ viewStore in
			Screen(paddingHorizontal: 0) {
				VStack{
					Spacer()
					NavigationTitleView(LoginFeature.Localization.navigationBarTitle)
					Spacer()
				}
				.padding(.top, 1)
				.preferenceNavigationBar(title: LoginFeature.Localization.navigationBarTitle)
			}
			.onAppear {
				Task {
					viewStore.send(.viewDidLoad)
				}
			}
		}
	}
}

#Preview {
	LoginScreen(
		store: Store(initialState: LoginFeature.State.init()) {
			LoginFeature()
		})
	.preferredColorScheme(.dark)
}


