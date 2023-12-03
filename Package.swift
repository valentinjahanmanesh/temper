// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v15)],
    products: Module.allCases.map({
        .library(name: $0.name, targets: [$0.name])
    }),
    dependencies: [
        .package(url: "https://github.com/Let-See/iOS", from: "1.2.6"),
		.package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.2.0"),
    ],
    targets: [
        .target(name: Module.Core.name, dependencies: [.productItem(name: "ComposableArchitecture",
																	package: "swift-composable-architecture")]),
        .target(name: Module.Mocks.name, dependencies: [Module.Core.asDependency]),
        .target(name: Module.DataProvider.name, dependencies: [Module.Core.asDependency]),
        .target(name: Module.Repository.name, dependencies: [Module.Core.asDependency,
															 Module.DataProvider.asDependency]),
		.target(name: Module.Components.name, dependencies: [Module.Core.asDependency],
				resources: [.process("Resources/Rich"), .copy("Resources/Raw")]),

        // App Module
        .target(name: Module.App.name, dependencies: [
													  Module.Core.asDependency,
                                                      Module.Repository.asDependency,
                                                      Module.Signup.asDependency,
                                                      Module.Login.asDependency,
                                                      Module.Home.asDependency,
                                                      .productItem(name: "LetSee", package: "iOS")]),

        // ----- Screens Modules -----
        .target(name: Module.Home.name,
                dependencies: [Module.Core.asDependency,
							   Module.Components.asDependency,
							   Module.Filters.asDependency,
							   Module.Map.asDependency,
                               Module.Repository.asDependency],
                path: Module.Home.sourcePath),
		.testTarget(name: Module.Home.asTest, dependencies: [Module.Home.asDependency], path: Module.Home.testPath),
		.target(name: Module.Signup.name,
				dependencies: [Module.Core.asDependency,
							   Module.Components.asDependency,
							   Module.Repository.asDependency],
				path: Module.Signup.sourcePath),
		.target(name: Module.Login.name,
				dependencies: [Module.Core.asDependency,
							   Module.Components.asDependency,
							   Module.Repository.asDependency],
				path: Module.Login.sourcePath),
		.target(name: Module.Map.name,
				dependencies: [Module.Core.asDependency,
							   Module.Components.asDependency,
							   Module.Repository.asDependency],
				path: Module.Map.sourcePath),
		.target(name: Module.Filters.name,
				dependencies: [Module.Core.asDependency,
							   Module.Components.asDependency,
							   Module.Repository.asDependency],
				path: Module.Filters.sourcePath),
        // ----- End Screens -----
    ]
)

fileprivate enum osType: String {
	case iOS

    var name: String {
        self.rawValue
    }
}

/// As a syntax sugar, we define our module names here to reduce too many copies and pastes
fileprivate enum Module: String, CaseIterable {
    case App
    case Core
    case DataProvider
    case Mocks
    case Components
    case Repository
    case Home
    case Filters
    case Map
	case Signup
	case Login
    var name: String {
        self.rawValue
    }

    var asTest: String {
        "\(self.name)Tests"
    }

    var asTestDependency: Target.Dependency {
        .init(self.asTest)
    }

    var asDependency: Target.Dependency {
        .init(self.name)
    }

    var sourcePath: String {
        let source = "Sources/"
        let screen = source + "Screens/"
        switch self {
		case .App, .Core, .DataProvider, .Mocks, .Components, .Repository:
            return source + self.name
		case .Home, .Filters, .Map, .Login, .Signup:
            return screen + self.name
        }
    }

	var testPath: String {
		let test = "Sources/Tests/"
		return test + self.asTest
	}
}

extension Target.Dependency {
    init(_ string: String) {
        self.init(stringLiteral: string)
    }
}

