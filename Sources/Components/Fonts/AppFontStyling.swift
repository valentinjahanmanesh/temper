//
//  AppFontStyling.swift
//  
//
//  Created by Farshad Macbook M1 Pro.

import struct SwiftUI.Font
public protocol AppFontStyling {
    var fontName: String? {get}
    /// Size: 40
    /// A font with the large title text style.
    var maxlargeTitle: Font {get}

	/// Size: 48
	/// A font with the large title text style.
	var ultraMaxLargeTitle: Font {get}

	/// Size: 36
    /// A font with the large title text style.
	var largeTitle: Font {get}

	/// Size: 18
    /// A font with the title text style.
	var title: Font {get}

	/// Size: 20
	/// A font with the title text style.
	var midTitle: Font {get}

	/// Size: 24
    /// Create a font for second level hierarchical headings.
	var title2: Font {get}

	/// Size: 26
    /// Create a font for third level hierarchical headings.
	var title3: Font {get}

	/// Size: 18
    /// A font with the headline text style.
	var headline: Font {get}

	/// Size: 16
    /// A font with the subheadline text style.
	var subheadline: Font {get}

	/// Size: 14
    /// A font with the body text style.
	var body: Font {get}

	/// Size: 13
    /// A font with the callout text style.
	var callout: Font {get}

	/// Size: 10
    /// A font with the footnote text style.
	var footnote: Font {get}

	/// Size: 12
    /// A font with the caption text style.
	var caption: Font {get}
}
