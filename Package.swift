// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "IQKeyboardToolbarManager",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "IQKeyboardToolbarManager",
            targets: ["IQKeyboardToolbarManager"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/hackiftekhar/IQKeyboardToolbar.git", from: "1.1.1"),
        .package(url: "https://github.com/hackiftekhar/IQTextInputViewNotification", from: "1.0.8"),
    ],
    targets: [
        .target(name: "IQKeyboardToolbarManager",
            dependencies: [
                "IQKeyboardToolbar",
                "IQTextInputViewNotification"
            ],
            path: "IQKeyboardToolbarManager",
            resources: [
                .copy("Assets/PrivacyInfo.xcprivacy")
            ],
            linkerSettings: [
                .linkedFramework("UIKit")
            ]
        )
    ]
)
