//
//  TitleView.swift
//  
//
//  Created by Farshad Jahanmanesh.
//

import SwiftUI

/// We use this modifer hence when ever bussiness needed we can simply change all labels font and ...
public struct NavigationTitleView: View {
	@Environment(\.styling) var styling: AppStyling
    public var title: LocalizedStringKey
    public init(_ title: LocalizedStringKey) {
        self.title = title
    }
    public var body: some View {
		Text(title)
			.font(styling.fonts.title)
			.fontWeight(.medium)
			.padding(.top, 8)
    }
}

#Preview {
	NavigationTitleView("Some large title")
}
