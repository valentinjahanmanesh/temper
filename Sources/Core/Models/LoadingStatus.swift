//
//  LoadingStatus.swift
//  
//
//  Created by Farshad Jahanmanesh.
//

import Foundation
public enum LoadingStatus: Equatable {
    case none
    case loading
    case error(String)

	public var isLoading: Bool {
		return switch self {
		case .loading:
			true
		default: false
		}
	}
	public var isError: Bool {
		return switch self {
		case .error:
			true
		default: false
		}
	}
}
