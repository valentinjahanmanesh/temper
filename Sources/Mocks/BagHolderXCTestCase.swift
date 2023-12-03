//
//  BagHolderXCTestCase.swift
//  
//
//  Created by Farshad Macbook M1 Pro.
//

import Foundation
import XCTest
import Combine
import Core
open class XCTestCaseWithBag: XCTestCase, CancellableStoring {
	public lazy var bag: Set<AnyCancellable> = []

}
