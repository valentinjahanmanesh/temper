
//
//  HomeScreen.swift
//
//
//  Created by Farshad Macbook M1 Pro.
//

import SwiftUI
import ComposableArchitecture
import Components
import Core
import Filters
import Map

public struct HomeScreen: View {
	@Environment(\.styling) private var styling
	let store: StoreOf<HomeFeature>
	public init(
		store: StoreOf<HomeFeature>
	) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(self.store, observe: {$0}){ viewStore in
			Screen(paddingHorizontal: 0) {
				VStack{
					ZStack(alignment: .bottom) {
						List(viewStore.shifts, id: \.date.id) {datedShift in
							Section(header: ListSectionHeader(datedShift.date.display)) {
								ForEach(datedShift.shifts) { shift in
									ListItem(shift: shift)
										.listRowSeparator(.hidden)
										.onAppear {
											if viewStore.shifts.last == datedShift, datedShift.shifts.last == shift {
												self.store.send(.getShifts())
											}
										}
								}
							}
						}
						.listStyle(PlainListStyle())
						.refreshable {
							self.store.send(.getShifts(reset: true))
						}
						if viewStore.isNextPageLoading == .loading {
							ProgressView()
								.frame(width: 40)
						}

						Actions(onFiltersTapped: {
							viewStore.send(.navigate(to: .filtersScreen))

						}, onMapTapped: {
							viewStore.send(.navigate(to: .mapScreen))
						})
						.padding(.bottom, styling.spaces.horizontal.large)

						EmptyNavigationLink(isActive: .init(get: {viewStore.route == .filtersScreen},
															set: { isActive in viewStore.send(.navigate(to: .none))})) {
							IfLetStore(self.store.scope(state: \.filtersState, action: {.filtersAction(.presented($0))})) { store in
								FiltersScreen(store: store)
							}
						}

						EmptyNavigationLink(isActive: .init(get: {viewStore.route == .mapScreen},
															set: { isActive in viewStore.send(.navigate(to: .none))})) {
							IfLetStore(self.store.scope(state: \.mapState, action: {.mapAction(.presented($0))})) { store in
								MapScreen(store: store)
							}
						}
					}
				}
				.padding(.top, 1)
				.preferenceNavigationBar(title: HomeFeature.Localization.navigationBarTitle)
			}
			.onAppear {
				Task {
					viewStore.send(.viewDidLoad)
				}
			}
		}
	}
	@ViewBuilder
	private func ListSectionHeader(_ text: String) -> some View {
		Text(text)
			.padding(.leading, 24)
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
			.background(styling.colors.surfaceFixed)
			.listRowInsets(EdgeInsets(
					top: 0,
					leading: 0,
					bottom: 0,
					trailing: 0)
			)
	}
	@ViewBuilder
	private func ListItem(shift: Shift) -> some View {
		VStack(alignment: .leading, spacing: 10) {
			ZStack(alignment: .bottomTrailing) {
				AsyncImage(url: shift.image, content: { image in
					image.resizable()
						.aspectRatio(1.5, contentMode: .fit)
				}, placeholder: {
					Image(decorative: "")
						.resizable()
						.aspectRatio(1.5, contentMode: .fit)
						.frame(maxWidth: .infinity)
						.overlay(ProgressView())
				})

				Text(shift.earningsPerHour)
					.font(styling.fonts.body)
					.fontWeight(.medium)
					.foregroundStyle(styling.colors.onSurfaceFixed)
					.padding(.leading, 14)
					.padding(.trailing, 4)
					.padding(.vertical, 4)
					.background(PriceCutOut().fill(styling.colors.surfaceFixed))
			}
			.clipShape(RoundedRectangle(cornerRadius: 8))
			VStack(alignment: .leading, spacing: 4) {
				Text("\(shift.category) . \(shift.location.distanceFromAmsterdam)")
					.font(styling.fonts.caption)
					.fontWeight(.bold)
					.foregroundStyle(styling.colors.infoFixed)
				Text(shift.title)
					.font(styling.fonts.body)
					.fontWeight(.medium)
					.foregroundStyle(styling.colors.onSurfaceFixed)
				Text("\(shift.startAt.onlyTime) - \(shift.endAt.onlyTime)")
					.font(styling.fonts.caption)
					.foregroundStyle(styling.colors.onSurfaceFixed)
			}
		}
	}

	@ViewBuilder
	private func ActionsButtonTitle(title: LocalizedStringKey, icon: Icons) -> some View {
		HStack(alignment: .center, spacing: 8) {
			ResizableSquareIcon(icon)
			Text(title)
				.font(styling.fonts.body)
				.fontWeight(.medium)
		}
		.foregroundStyle(styling.colors.onSurfaceFixed)
		.padding(8)
		.padding(.horizontal, 8)
	}

	@ViewBuilder
	private func Actions(onFiltersTapped: @escaping ()->Void, onMapTapped: @escaping ()->Void) -> some View {
		HStack(alignment: .center, spacing: 8) {

			Button(action: {onFiltersTapped()}, label: {
				ActionsButtonTitle(title: HomeFeature.Localization.filtersButtonTitle, icon: .Filter)
			})

			Button(action: {onMapTapped()}, label: {
				ActionsButtonTitle(title: HomeFeature.Localization.mapButtonTitle, icon: .Pin)
			})
		}
		.background(styling.colors.surfaceFixed)
		.overlay(Divider()
			.frame(width: 1)
			.frame(maxHeight: .infinity)
			.background(styling.colors.onSurfaceFixed.opacity(0.4))
			.padding(.vertical, 4))
		.clipShape(RoundedRectangle(cornerRadius: 100))
		.shadow(radius: 10)
	}
}

#Preview {
	HomeScreen(
		store: Store(initialState: HomeFeature.State.init()) {
			HomeFeature()
		})
}


struct PriceCutOut: Shape {
	func path(in rect: CGRect) -> Path {
		Path { path in
			path.move(to: .init(x: rect.minX, y: rect.maxY))
			// first 30% of the view belongs to the curve
			let curveEndPoint: CGPoint = .init(x: rect.minX + (rect.width * 0.3), y: rect.minY)
			path.addCurve(to: curveEndPoint, control1: .init(x: rect.width * 0.15, y: rect.maxY), control2: .init(x: rect.width * 0.1, y: rect.minY))
			path.addLine(to: .init(x: rect.maxX, y: rect.minY))
			path.addLine(to: .init(x: rect.maxX, y: rect.maxY))
			path.addLine(to: .init(x: rect.minX, y: rect.maxY))
			path.closeSubpath()
		}
	}
}
