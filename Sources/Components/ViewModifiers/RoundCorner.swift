//
//  RoundCorner.swift
//
//
//  Created by Farshad Jahanmanesh.
//

import SwiftUI

public extension View {
	@ViewBuilder
	func roundBorder(borderColor: Color, cornerRadius: CGFloat = 12, lineWidth: CGFloat = 1) -> some View {
		self.overlay(RoundedRectangle(cornerRadius: cornerRadius)
			.inset(by: 1)
			.stroke(borderColor, lineWidth: lineWidth)

		)
	}
}

