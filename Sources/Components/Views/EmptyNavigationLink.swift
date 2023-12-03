//
//  EmptyNavigationLink.swift
//  
//
//  Created by Farshad Jahanmanesh.
//

import SwiftUI

public struct EmptyNavigationLink<Destination: View>: View {
	var destination: ()->Destination
	var isActive: Binding<Bool>
	public init(isActive: Binding<Bool>, destination: @escaping () -> Destination) {
		self.destination = destination
		self.isActive = isActive
	}
	public var body: some View {
		NavigationLink(isActive: isActive, destination: {
			destination()
		}, label: {  EmptyView() })
		.hidden()
	}
}
