//
//  RepositoryProtocol.swift
//
//
//  Created by Farshad Jahanmanesh.
//

import Foundation
import DataProvider
import Combine
import Core
import Dependencies

public enum RepositoryError: Error {
	case screenError(ScreenError)
	case rawError(String)
}

public protocol RepositoryProtocol: GetShitsUseCase {

}


public enum RepositoryProtocolKey: DependencyKey {
	public static var liveValue: RepositoryProtocol = DefaultRepository()
	public static var previewValue: RepositoryProtocol = EmptyRepository()
	public static var testValue: RepositoryProtocol = EmptyRepository(delay: 0)
}

public extension DependencyValues {
	var appRepository: RepositoryProtocol {
		get {self[RepositoryProtocolKey.self]}
		set{self[RepositoryProtocolKey.self] = newValue}
	}
	var getShitsUseCase: GetShitsUseCase {
		get {self[GetShitsUseCaseDependencyKey.self] ?? self.appRepository}
		set{self[GetShitsUseCaseDependencyKey.self] = newValue}
	}
}

private enum GetShitsUseCaseDependencyKey: DependencyKey {
	static var liveValue: GetShitsUseCase? = nil
	static var previewValue: GetShitsUseCase? = nil
	static var testValue: GetShitsUseCase? = EmptyRepository()
}

public protocol GetShitsUseCase {
	func getShifts(_ filters: [GetShitsFilter]) async throws -> [Shift]
}
