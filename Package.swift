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
            name: "Osi",
            type: .static, // static because of sandboxing.
            targets: ["libOsi"]
        ),
    ],
    
    // MARK: - Dependencies
    // -----------------------------------------------------------------
    // 3. Depependent on others - none at the moment
    // -----------------------------------------------------------------
    dependencies: [],
    
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
            dependencies: [],         // No external modules
            path: "src", // folder that holds the C++ files
            sources: [  // The C++ files to be included in the build
                "OsiAuxInfo.cpp",
                "OsiBranchingObject.cpp",
                "OsiChooseVariable.cpp",
                "OsiColCut.cpp",
                "OsiCut.cpp",
                "OsiCuts.cpp",
                "OsiFeatures.cpp",
                "OsiNames.cpp",
                "OsiPresolve.cpp",
                "OsiRowCut.cpp",
                "OsiRowCutDebugger.cpp",
                "OsiSolverBranch.cpp",
                "OsiSolverInterface.cpp"
            ],
            
            // ---- Public headers --------------------------------------------------------------
            // Anything under `publicHeadersPath` becomes visible to *other* packages.
            // It also tells SPM where to look for the headers when it builds a Clang module.
            publicHeadersPath: ".",          // Anything inside src that ends with .h/.hpp becomes a public Clang module
            
            // ---- C++‑specific settings --------------------------------------------------------
            cxxSettings: [
                // Use the C++20 (or C++23) dialect – change if you need a different version.
                //.cxxStandard("c++20"), // use user default, aka Xcode version
                
                .define("OSILIB_BUILD", to: "1"),
                
                // Tell the compiler where to find your headers from path sources
                .headerSearchPath(".")
            ]
        )
        
        // MARK: - Tests
        // -----------------------------------------------------------------
        //  TODO: To add once we have a sucessfull build
        //  Keeping below as template
        // -----------------------------------------------------------------
        //        ,
        //        .testTarget(
        //            name: "",
        //            dependencies: ["CoinUtils"] // Tests depends/run on the lib we testing
        //        ),
        
    ]
)
