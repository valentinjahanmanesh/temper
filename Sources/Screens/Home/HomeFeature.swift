import Foundation
import SwiftUI
import Components
import Core
import ComposableArchitecture
import Repository
import Filters
import Map

/*
 [x] - Jobs screen should list all the jobs for the current date.
 [x] - Jobs screen should support infinite scroll. E.g. postings for tomorrow should be loaded and appended when the user reaches the bottom of the screen.
 [x] - Jobs screen should support pull to refresh.
 [x] - Your implementation is not required to be pixel perfect, but try to be as close to the provided design as possible.
 [x] - Filters, Kaart (Map) screens can be empty, but they should navigate to the corresponding screen when interacted with.
 [x] - Signup and Login screens can be empty, but they should navigate to the corresponding screen modally.

 Non-functional requirements
 [x] - You can use the latest stable version of Xcode.
 [x] - The minimum target for iOS is version 15.
 [x] - The project should include the application target and at least one local package for the network layer. You may create additional packages to organize your code as
 desired, with no restrictions. You can use any architecture style you’re comfortable with, e.g. MVC, MVVM, coordinators, etc.
 [x] - You can use SwiftUI, UIKit or both as hybrid.
 [-] - If you include any UIKit view, don't use storyboards or xib files. Hint: You can use SnapKit or some other dependency for autolayout.
 [x] - Use Swift Package Manager for dependency management. You can use any dependency that you see fit.
 [-] - (Optional) Set up a hybrid project that contains some UIKit views
 */

@Reducer
public struct HomeFeature {
	public struct State: Equatable {
		public struct DatedShits: Equatable {
			public let date: DateDisplay
			public let shifts: [Shift]
			public init(
				date: DateDisplay,
				shifts: [Shift]
			) {
				self.date = date
				self.shifts = shifts
			}
		}
		var currentPage: Date?
		var shifts: [DatedShits]
		var isScreenLoading: LoadingStatus
		var isNextPageLoading: LoadingStatus
		var selectedShift: Shift?
		@PresentationState var filtersState: FiltersFeature.State?
		@PresentationState var mapState: MapFeature.State?
		var route: Route?
		public init(currentPage: Date? = nil,
					shifts: [DatedShits] = [],
					isScreenLoading: LoadingStatus = .none,
					isNextPageLoading: LoadingStatus = .none,
					filtersState: FiltersFeature.State? = nil,
					mapState: MapFeature.State? = nil,
					route: Route? = nil,
					selectedShift: Shift? = nil
		) {
			self.currentPage = currentPage
			self.shifts = shifts
			self.isScreenLoading = isScreenLoading
			self.isNextPageLoading = isNextPageLoading
			self.filtersState = filtersState
			self.mapState = mapState
			self.route = route
			self.selectedShift = selectedShift
		}
	}

	public enum Localization {
		static let navigationBarTitle: LocalizedStringKey = "home.screen.title"
		static let mapButtonTitle: LocalizedStringKey = "map.button.label"
		static let filtersButtonTitle: LocalizedStringKey = "filters.button.label"
	}

	@CasePathable
	public enum Action: Equatable {
		case viewDidLoad
		case filtersAction(PresentationAction<FiltersFeature.Action>)
		case mapAction(PresentationAction<MapFeature.Action>)
		case getShifts(reset: Bool = false)
		case receivedShifts(HomeFeature.State.DatedShits, reset: Bool = false)
		case navigate(to: Route?)
	}

	public enum Route {
		case mapScreen
		case filtersScreen
	}
	public init() {}

	@Dependency(\.getShitsUseCase) var useCase
	@Dependency(\.date) var dateGenerator

	public var body: some ReducerOf<Self> {
		Reduce {state, action in
			switch action {
			case .viewDidLoad:
				if state.shifts.isEmpty {
					return .send(.getShifts(reset: true))
				} else {
					return .none
				}

			case .getShifts(let isReset):
				guard state.isNextPageLoading != .loading else {
					return .none
				}
				state.isNextPageLoading = .loading
				let nextPage: Date
				if !isReset, let currentDate = state.currentPage {
					nextPage = findNextPage(after: currentDate)
				} else {
					nextPage = dateGenerator()
				}
				state.currentPage = nextPage

				return .run { send in
					do {
						let shifts = try await useCase.getShifts([.date(nextPage)])
						await send(.receivedShifts(.init(date: nextPage.dateDisplay, shifts: shifts), reset: isReset))
					} catch(let error) {
						#warning("Need to handle error")
						print(error)
					}
				}
			case .receivedShifts(let shifts, let isReset):
				if isReset {
					state.shifts = [shifts]
				} else {
					state.shifts += [shifts]
				}

				state.isNextPageLoading = .none
				return .none
			case .filtersAction(.dismiss), .mapAction(.dismiss):
				state.route = nil

				return .none
			case .filtersAction, .mapAction:
				return .none

			case .navigate(let route):
				switch route {
				case .mapScreen:
					state.mapState = .init()
				case .filtersScreen:
					state.filtersState = .init()
				case .none: break
				}
				state.route = route

				return .none
			}
		}
		.ifLet(\.$filtersState, action: /Action.filtersAction) {
			FiltersFeature()
		}
		.ifLet(\.$mapState, action: /Action.mapAction) {
			MapFeature()
		}
	}

	func findNextPage(after currentDate: Date) -> Date {
		var index = 1
		while true {
			if let nextPage = Calendar.current.date(byAdding: .day, value: index, to: currentDate) {
				return nextPage
			}
			index += 1
		}
	}
}
