//
//  AppFeature.swift
//
//
//  Created by Farshad Macbook M1 Pro.
//


import SwiftUI
import Components
import Core
import ComposableArchitecture
import Repository
import Home
import Login
import Signup

public struct AppFeature: Reducer {
	public init() {}
	public struct State: Equatable {
		public init(homeState: HomeFeature.State =  .init()) {
			self.homeState = homeState
		}
		var homeState: HomeFeature.State
		@PresentationState var loginState: LoginFeature.State?
		@PresentationState var signupState: SignupFeature.State?
	}

	public enum Localization {
		static let signupButtonTitle: LocalizedStringKey = "signup.button.label"
		static let loginButtonTitle: LocalizedStringKey = "login.button.label"
	}

	@CasePathable
	public enum Action {
		case viewDidLoad
		case homeAction(HomeFeature.Action)
		case loginAction(PresentationAction<LoginFeature.Action>)
		case signupAction(PresentationAction<SignupFeature.Action>)
		case loginButtonTapped
		case signupButtonTapped
	}

	public var body: some ReducerOf<Self> {
		Reduce {state, action in
			switch action {
			case .viewDidLoad:
				return .none
			case .loginButtonTapped:
				state.loginState = .init()
				return .none
			case .signupButtonTapped:
				state.signupState = .init()
				return .none
			case .homeAction, .signupAction, .loginAction:
				return .none
			}
		}
		.ifLet(\.$loginState, action: /Action.loginAction) {
			LoginFeature()
		}
		.ifLet(\.$signupState, action: /Action.signupAction) {
			SignupFeature()
		}
		Scope(state: \.homeState, action: /Action.homeAction) {
			HomeFeature()
		}
	}
}
