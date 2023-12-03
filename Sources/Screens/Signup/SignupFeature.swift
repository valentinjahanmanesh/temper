//
//  SignupScreen.swift
//
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation
import SwiftUI
import Components
import Core
import ComposableArchitecture

public struct SignupFeature: Reducer {
	public init(){}
	public struct State: Equatable {
		public init(){}
	}
	public enum Localization {
		static let navigationBarTitle: LocalizedStringKey = "signup.screen.title"
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

public struct SignupScreen: View {
	@Environment(\.styling) private var styling
	let store: StoreOf<SignupFeature>
	public init(
		store: StoreOf<SignupFeature>
	) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(self.store, observe: {$0}){ viewStore in
			Screen(paddingHorizontal: 0) {
				VStack{
					Spacer()
					NavigationTitleView(SignupFeature.Localization.navigationBarTitle)
					Spacer()
				}
				.padding(.top, 1)
				.preferenceNavigationBar(title: SignupFeature.Localization.navigationBarTitle)
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
	SignupScreen(
		store: Store(initialState: SignupFeature.State.init()) {
			SignupFeature()
		})
	.preferredColorScheme(.dark)
}


