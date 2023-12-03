//
//  DefaultButtonViewModifier.swift
//  
//
//  Created by Farshad Jahanmanesh.
//

import SwiftUI
public struct DefaultButtonViewModifier: ViewModifier {
    @Environment(\.styling) var styling: AppStyling
    private var style: ButtonStyle
    var disabled: Bool = false
    var isLoading: Bool = false
    var height: CGFloat? = nil
    @ScaledMetric var buttonHeight: CGFloat = 50
    var width: CGFloat? = nil
    init(style: ButtonStyle,
         isDisabled: Bool = false,
         isLoading: Bool = false,
         height: CGFloat? = nil,
         width: CGFloat? = nil
    ) {
        self.style = style
        self.disabled = isDisabled
        self.isLoading = isLoading
        if isLoading {
            self.disabled = isLoading
        }
        self.height = height
        self.width = width
        if let height {
            _buttonHeight = .init(wrappedValue: height)
        }
    }

    @ViewBuilder
    private var LoadingView: some View {
		ProgressView()
    }
    public func body(content: Content) -> some View {
        content
            .if(height != nil, transform: { view in
                view.frame(height: buttonHeight)
            })
            .if(width != nil, transform: { view in
                    view.frame(maxWidth: width!)
            })
        .if(isLoading, transform: { view in
            view.overlay(LoadingView.frame(height: buttonHeight)
                .aspectRatio(1,contentMode: .fit))
            .foregroundColor(Color.clear)
        })
        .if(!disabled, transform: { view in
            Group {
                switch style {
                case .primary:
                    view.background(styling.colors.primaryFixed)
                        .foregroundStyle(styling.colors.onPrimaryFixed)
                case .secondary:
					view.background(styling.colors.surfaceFixed)
                        .foregroundColor(styling.colors.onSurfaceFixed)
                case .link:
                    view.background(Color.clear)
                        .foregroundColor(styling.colors.infoFixed)
                case .customPrimary(let background):
                    view.background(background)
                        .foregroundColor(styling.colors.onPrimaryFixed)
                }
            }
        })
        .font(styling.fonts.body.weight(.semibold))
        .cornerRadius(buttonHeight / 2)
        .buttonStyle(.borderless)
    }
}

public enum ButtonStyle {
    case primary
    case secondary
    case link
    case customPrimary(background: Color)
}

public extension Button {
    func defaultButton(style: ButtonStyle = .primary, isDisabled: Bool = false, isLoading: Bool = false) -> some View {
        self.modifier(DefaultButtonViewModifier(style: style, isDisabled: isDisabled, isLoading: isLoading,height: 48,
                                                width: .infinity))
    }

    func defaultButtonNoSize(style: ButtonStyle = .primary, isDisabled: Bool = false, isLoading: Bool = false) -> some View {
        self.modifier(DefaultButtonViewModifier(style: style, isDisabled: isDisabled, isLoading: isLoading))
    }
}

struct Button_Previews: PreviewProvider {
    static var previews: some View {
        Button("Salam") {

        }
        .defaultButton(isDisabled: true, isLoading: false)

    }
}
