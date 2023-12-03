//
//  HomeFeatureTests.swift
//
//
//  Created by Farshad Macbook M1 Pro on 12/3/23.
//

import Foundation
@testable import Home
import XCTest
import ComposableArchitecture

@MainActor
class HomeFeatureTests: XCTestCase {
	func testBasics() async {
		let dateGenerator: ()-> Date = {
			return Date.fixedDate
		}

		let store = TestStore(initialState: HomeFeature.State()) {
			HomeFeature()
		} withDependencies: {
			$0.date = .init(dateGenerator)
		}

		/// Test view didLoadAction when there is no item on the shift list
		await store.send(.viewDidLoad)
		await store.receive(.getShifts(reset: true), timeout: 2) { state in
			state.currentPage = dateGenerator()
			state.isNextPageLoading = .loading
		}
		await store.finish()
		let mockedDatedShifts: HomeFeature.State.DatedShits = .init(date: dateGenerator().dateDisplay, shifts: .mocks)
		await store.receive(.receivedShifts(mockedDatedShifts, reset: true), timeout: 2) { state in
			state.shifts = [mockedDatedShifts]
			state.isNextPageLoading = .none
		}

		/// Test view didLoadAction when there are some items in the list, so nothing should happen
		await store.send(.viewDidLoad)
		/// When the user scrolls down to the end of the list, the next page should be called and be appended to the previous list

		/// Simulates fetching the next 4 days
		for day in (1...4) {
			/// next day should be retrieve
			var tomorrowDate = dateGenerator()
			tomorrowDate.addTimeInterval(TimeInterval(day * 86400))
			await store.send(.getShifts(reset: false)) {state in
				state.currentPage = tomorrowDate
				state.isNextPageLoading = .loading
			}

			let secondPage: HomeFeature.State.DatedShits = .init(date: tomorrowDate.dateDisplay,
																 shifts: .mocks)
			await store.receive(.receivedShifts(secondPage, reset: false)) { state in
				state.shifts += [secondPage]
				state.isNextPageLoading = .none
			}
			await store.finish()
		}

		/// the user taps on the map button
		await store.send(.navigate(to: .mapScreen)) {state in
			state.mapState = .init()
			state.route = .mapScreen
		}

		/// the user taps on the filters button
		await store.send(.navigate(to: .filtersScreen)) {state in
			state.filtersState = .init()
			state.route = .filtersScreen
		}
	}
}
