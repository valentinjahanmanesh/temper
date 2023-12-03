//
//  File.swift
//  
//
//  Created by Farshad Macbook M1 Pro.
//

import SwiftUI
public struct EmptyScreenView: View {
	public struct Action {
		let title: LocalizedStringKey
		let callback: (()->Void)
		public init(title: LocalizedStringKey, callback: @escaping (()->Void)) {
			self.title = title
			self.callback = callback
		}
	}
	@Environment(\.styling) private var styling
	private let title: LocalizedStringKey
	private let action: Action?
	public init(title: LocalizedStringKey,
				action: Action? = nil) {
		self.title = title
		self.action = action
	}
	public var body: some View {
		VStack {
			Spacer()
			VStack(alignment: .center, spacing: 16) {
				VStack(spacing: 4){
					Text(title)
						.font(styling.fonts.subheadline)
						.fontWeight(.medium)
						.foregroundColor(styling.colors.onSurfaceFixed)
						.multilineTextAlignment(.center)
				}

				if let action {
					RetryButton(title: action.title, callback: action.callback)
						.padding(.top, 8)

				}
			}
			.frame(maxWidth: .infinity)
			.padding(.vertical, 24)
			Spacer()
		}

	}
}

public struct RetryButton: View {
	@Environment(\.styling) var styling
	private let callback: ()->Void
	private let title: LocalizedStringKey
	public  init(title: LocalizedStringKey = "Retry",
				 callback: @escaping () -> Void) {
		self.callback = callback
		self.title = title
	}
	public var body: some View {
		HStack(spacing: 0) {
			Button {
				callback()
			} label: {
				HStack(spacing: 8) {
					Text(title)
						.foregroundColor(styling.colors.onSurfaceFixed)
						.font(styling.fonts.body)
						.fontWeight(.medium)
				}
				.padding(.horizontal, 24)
				.padding(.vertical, 12)
			}
			.defaultButtonNoSize(style: .customPrimary(background: styling.colors.surfaceFixed))
			.roundBorder(borderColor: styling.colors.infoFixed)
		}

	}
}
