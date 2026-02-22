// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Osi",
    
    // MARK: - Platforms supported
    // -----------------------------------------------------------------
    //  1. Platforms Versions – macOS, iOS, etc.
    // -----------------------------------------------------------------
    platforms: [
        .iOS(.v15),   // iOS 15+ (or later)
        .macOS(.v13)   // macOS 13+ (Ventura) – adjust if you need an older version
                      // add more later:
                    /// Linux: Visual Studio Code, CLion, JetBrains AppCode (via remote dev), vim/emacs + LSP, Swift Playground Docker images.
                    /// Windows: VS Code (Swift extension), CLion, Visual Studio Code with LSP; JetBrains AppCode via remote‑dev or macOS VM

    ],
    
    // MARK: - Products (what the package vends to clients)
    // -----------------------------------------------------------------
    //  2. Products – expose a library that downstream code can import.
    // -----------------------------------------------------------------
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "libOsi",
            type: .static, // static because of sandboxing.
            targets: ["libOsi"]
        ),
        .library(
            name: "libOsiCommonTest",
            type: .static,
            targets: ["libOsiCommonTest"])
    ],
    
    // MARK: - Dependencies
    // -----------------------------------------------------------------
    // 3. Depependent on others - none at the moment
    // -----------------------------------------------------------------
    dependencies: [.package(
        url: "https://github.com/theogscott/CoinUtils",
        branch: "SPM"           // for a rolling dev branch
        ),
    ],

    // MARK: – Targets (the actual code and test suite)
    // --------------------------------------------------------------------
    // 4. Targets – split into a C++ library and a C and/or Swift wrapper
    //
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    // --------------------------------------------------------------------
    targets: [
        // ------------------------------------------------------------
        // 4a C++ target (only .cpp/.hpp files)
        // ------------------------------------------------------------
        .target(
            name: "libOsi",  // internal name – can be anything
            dependencies: [.product(name: "libCoinUtils", package: "CoinUtils")],     // The CoinUtils package exports a library product named “CoinUtils”. This line tells SwiftPM to link against that product.
            path: "src/Osi",    // The folder containing the C++ source files
            
            
            // ---- Public headers --------------------------------------------------------------
            // Anything under `publicHeadersPath` becomes visible to *other* packages.
            // It also tells SPM where to look for the headers when it builds a Clang module.
            publicHeadersPath: ".",          // Anything inside src/Osi that ends with .h/.hpp becomes a public Clang module
            
            // ---- C++‑specific settings --------------------------------------------------------
            cxxSettings: [
                // Use the C++20 (or C++23) dialect – change if you need a different version.
                //.cxxStandard("c++20"), // use user default, aka Xcode version
                
                .define("OSILIB_BUILD", to: "1"),
                .define("_LIB", to: "1"),
                
                
                // Tell the compiler where to find your headers from path sources
                .headerSearchPath(".")
            ]
        ),
        
        // MARK: - Tests
        // -----------------------------------------------------------------
        // -----------------------------------------------------------------
        .target(
            name: "libOsiCommonTest",
            dependencies: [
                "libOsi",
                .product(name: "libCoinUtils", package: "CoinUtils")
            ],
            path: "src/OsiCommonTest",
            
            publicHeadersPath: ".",
            cxxSettings: [
                // Use the C++20 (or C++23) dialect – change if you need a different version.
                //.cxxStandard("c++20"), // use user default, aka Xcode version
                
                .define("OSILIB_BUILD", to: "1"),
                .define("_LIB", to: "1"),
                .define("COIN_XCODE", to: "1"),
                
                
                // Tell the compiler where to find your headers from path sources
                .headerSearchPath(".")
            ]
        ),
        
    ]
)
