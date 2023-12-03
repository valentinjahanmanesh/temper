//
//  AppScreen.swift
//
//
//  Created by Farshad Macbook M1 Pro.
//

import SwiftUI
import Components
import Core
import ComposableArchitecture
import Home
import Login
import Signup

public struct AppScreen: View {
	@Environment(\.styling) private var styling
	let store: StoreOf<AppFeature>
	public init(
		store: StoreOf<AppFeature>
	) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(self.store, observe: {$0}){ viewStore in
			NavigationView{
				VStack{
					HomeScreen(store: self.store.scope(state: \.homeState, action: {.homeAction($0)}))
					Authentication()
						.padding(.horizontal)
				}
				.padding(.vertical, styling.spaces.vertical.small)
				.sheet(store: self.store.scope(state: \.$signupState, action: \.signupAction)) { store in
						SignupScreen(store: store)
				}
				.sheet(store: self.store.scope(state: \.$loginState, action: \.loginAction)) { store in
						LoginScreen(store: store)
				}
				.onAppear {
					Task {[weak viewStore] in
						viewStore?.send(.viewDidLoad)
					}
				}
			}
		}
	}

	@ViewBuilder
	private func AuthenticationButtonTitle(title: LocalizedStringKey) -> some View {
		Text(title)
			.font(styling.fonts.title)
			.fontWeight(.bold)
			.padding(.vertical, styling.spaces.vertical.medium)
			.frame(maxWidth: .infinity)
	}

	@ViewBuilder
	private func Authentication() -> some View {
		HStack {
			Button(action: {self.store.send(.signupButtonTapped)}, label: {
				AuthenticationButtonTitle(title: AppFeature.Localization.signupButtonTitle)
					.background(RoundedRectangle(cornerRadius: 5.0).fill(styling.colors.primaryFixed))
					.foregroundStyle(styling.colors.onPrimaryFixed)
			})

			Button(action: {self.store.send(.loginButtonTapped)}, label: {
				AuthenticationButtonTitle(title: AppFeature.Localization.loginButtonTitle)
					.roundBorder(borderColor: styling.colors.onSurfaceFixed, cornerRadius: 5)
					.foregroundStyle(styling.colors.onSurfaceFixed)
			})
		}
	}
}

#Preview {
	AppScreen(
		store: Store(initialState: AppFeature.State.init()) {
			AppFeature()
		})
	.preferredColorScheme(.dark)
}


