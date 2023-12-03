//
//  InterFonts.swift
//  
//
//  Created by Farshad Macbook M1 Pro.

import Foundation
import struct SwiftUI.Font

public struct InterFonts: AppFontStyling {
    public var fontName: String? {
        _fontName
    }
    let _fontName: String = Fonts.inter.name
	init() {
		Fonts.inter.register()
	}
	public var ultraMaxLargeTitle: Font {
		Font.custom(_fontName, size: 48, relativeTo: .largeTitle)
	}

	public var largeTitle: Font {
		Font.custom(_fontName, size: 36, relativeTo: .largeTitle)
	}


    public var maxlargeTitle: Font {
        Font.custom(_fontName, size: 40, relativeTo: .largeTitle)
    }

	public var title: Font {
		Font.custom(_fontName, size: 18, relativeTo: .title)
	}

	public var title2: Font {
		Font.custom(_fontName, size: 24, relativeTo: .title2)
	}

	public var title3: Font {
		Font.custom(_fontName, size: 26, relativeTo: .title3)
	}

	public var headline: Font {
		Font.custom(_fontName, size: 18, relativeTo: .headline)
	}

	public var subheadline: Font {
		Font.custom(_fontName, size: 16, relativeTo: .subheadline)
	}

	public var body: Font {
		Font.custom(_fontName, size: 14, relativeTo: .body)
	}

	public var callout: Font {
		Font.custom(_fontName, size: 13, relativeTo: .callout)
	}

	public var footnote: Font {
		Font.custom(_fontName, size: 10, relativeTo: .footnote)
	}

	public var caption: Font {
		Font.custom(_fontName, size: 12, relativeTo: .caption)
	}

	public var midTitle: Font {
		Font.custom(_fontName, size: 20, relativeTo: .title)
	}
}
