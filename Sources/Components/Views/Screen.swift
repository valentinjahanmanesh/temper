//
//  Screen.swift
//  
//
//  Created by Farshad Jahanmanesh.
//

import SwiftUI
import Core

public struct Screen<Content: View>: View {
    @Environment(\.styling) var styling: AppStyling
    var content: ()->Content
    var paddingHorizontal: CGFloat = 0
	private let isBackgroundVisible: Bool
    public init(paddingHorizontal: CGFloat? = nil,
				showBackground: Bool = true,
				content: @escaping () -> Content
    ) {
		isBackgroundVisible = showBackground
        self.content = content
        self.paddingHorizontal = paddingHorizontal ?? 24
    }

	@State var titleText: LocalizedStringKey?
	@State var onScreenError: OnScreenError?
	@State var onScreenErrorOpacity: CGFloat = 0
	@State var errorDismissTask: Task<(), Error>?
	@State var isLoading: Bool = false
    public var body: some View {
		ZStack(alignment: .top) {
            if isBackgroundVisible {
           	 styling.colors.surfaceFixed
					.ignoresSafeArea()
            }
            content()
                .padding(.horizontal, paddingHorizontal)
                .padding(.bottom, styling.spaces.vertical.medium)

			if isLoading {
				VStack{
					Spacer()
					ProgressView()
					Spacer()
				}
				.ignoresSafeArea()
			}
        }
		.navigationBarTitleDisplayMode(.inline)
        .onPreferenceChange(NavigationBarTitlePreferenceKey.self) { value in
            titleText = value
        }
		.onPreferenceChange(ScreenLoadingPreferenceKey.self) { value in
			isLoading = value ?? false
		}
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(titleText ?? "")
                    .font(styling.fonts.title)
                    .fontWeight(.medium)
                    .foregroundColor(styling.colors.onSurfaceFixed)
            }
        }
    }
}

public struct NavigationBarTitlePreferenceKey: PreferenceKey {
    public static var defaultValue: LocalizedStringKey?

    public static func reduce(value: inout LocalizedStringKey?, nextValue: () -> LocalizedStringKey?) {
        value = value ?? nextValue()
    }
}

public struct OnScreenError: Equatable {
	var uuid: UUID = UUID.init()
	public var errorMessage: String

	public init(errorMessage: String) {
		self.errorMessage = errorMessage
	}
}

public struct OnScreenErrorPreferenceKey: PreferenceKey {
	public static var defaultValue: OnScreenError?

	public static func reduce(value: inout OnScreenError?, nextValue: () -> OnScreenError?) {
		value = value ?? nextValue()
	}
}

public struct ScreenLoadingPreferenceKey: PreferenceKey {
	public static var defaultValue: Bool?

	public static func reduce(value: inout Bool?, nextValue: () -> Bool?) {
		value = value ?? nextValue()
	}
}

struct MyScreenProvider_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
        	Screen {
				VStack{
					Text("Hello3, world!")
					Text("Hello, world!")
						.navigationTitle("Yahoos")
						.preference(key: OnScreenErrorPreferenceKey.self, value: .init(errorMessage:"Google"))
				}
				.preference(key: ScreenLoadingPreferenceKey.self, value: true)
			}
        }
    }
}
