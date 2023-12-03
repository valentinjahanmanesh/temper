//
//  Icon.swift
//  
//
//  Created by Farshad Jahanmanesh.
//

import SwiftUI

public extension Image {
    func defaultIcon(_ size: CGSize = .init(width: 24, height: 24)) -> some View {
        self
        .resizable()
        .frame(width: size.width, height: size.height)
    }
}


public struct ResizableSquareIcon: View {
    @Environment(\.styling) private var styling
    private var size: CGFloat
    @ScaledMetric private var iconSize: CGFloat = 0
    private let icon: Icons
	private var iconImage: Image?
    private let resizable: Bool
    public init(_ icon: Icons,
         size: CGFloat = 24,
        resizable: Bool = true) {
        self.size = size
        self.icon = icon
        self.resizable = resizable
        self._iconSize = .init(wrappedValue: size)
    }

	public init(image: Image,
		 size: CGFloat = 24,
		resizable: Bool = true) {
		self.size = size
		self.icon = .Pin
		self.iconImage = image
		self.resizable = resizable
		self._iconSize = .init(wrappedValue: size)
	}

    public var body: some View {
		(iconImage ?? styling.icons.icon(icon))
            .if(resizable, transform: { image in
                    image.resizable()
            })
            .frame(width: iconSize, height: iconSize)
    }
}

struct ResizableIcon_Previews: PreviewProvider {
    static var previews: some View {
        ResizableSquareIcon(.Pin, size: 24, resizable: false)
            .preferredColorScheme(.dark)
    }
}
