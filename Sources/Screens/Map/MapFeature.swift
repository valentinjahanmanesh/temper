//
//  MapScreen.swift
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
import MapKit
public struct MapFeature: Reducer {
	public init(){}
	public struct State: Equatable {
		public init(){
		}
	}
	public enum Localization {
		static let navigationBarTitle: LocalizedStringKey = "map.screen.title"
	}
	public enum Action: Equatable {
		case viewDidLoad
	}

	public var body: some ReducerOf<Self> {
		Reduce {state, action in
			switch action {
			case .viewDidLoad:
				return .none
			}
		}
	}
}

public struct MapScreen: View {
	@Environment(\.styling) private var styling
	let store: StoreOf<MapFeature>

	@State private var region = MKCoordinateRegion(center: .init(latitude: 52.3547418, longitude: 4.8215613), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

	public init(
		store: StoreOf<MapFeature>
	) {
		self.store = store
	}

	public var body: some View {
		WithViewStore(self.store, observe: {$0}){ viewStore in
			Screen(paddingHorizontal: 0, showBackground: false) {
				VStack{
					Map(coordinateRegion: $region)
				}
				.padding(.top, 1)
				.preferenceNavigationBar(title: MapFeature.Localization.navigationBarTitle)
			}
			.onAppear {
				Task {
					viewStore.send(.viewDidLoad)
				}
			}
			.background(Color.green)
		}
	}
}

#Preview {
	MapScreen(
		store: Store(initialState: MapFeature.State.init()) {
			MapFeature()
		})
	.preferredColorScheme(.dark)
}


