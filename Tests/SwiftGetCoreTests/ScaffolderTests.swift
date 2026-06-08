import Foundation
import Testing
@testable import SwiftGetCore

@Test func projectScaffolderPlansUIKitProjectFiles() throws {
    let scaffolder = ProjectScaffolder()
    let context = ProjectTemplateContext(
        appName: "DemoApp",
        bundleID: "com.example.demo",
        organizationName: "Example",
        destination: URL(fileURLWithPath: "/tmp/DemoApp")
    )

    let plan = try scaffolder.plan(context: context)

    #expect(plan.files.contains { $0.relativePath == "DemoApp/App/AppDelegate.swift" })
    #expect(plan.files.contains { $0.relativePath == "DemoApp/App/SceneDelegate.swift" })
    #expect(plan.files.contains { $0.relativePath == "DemoApp/App/AppCoordinator.swift" })
    #expect(plan.files.contains { $0.relativePath == "DemoApp/Modules/Home/HomeViewController.swift" })
    #expect(plan.files.contains { $0.contents.contains("import SnapKit") })
}

@Test func moduleScaffolderPlansCoordinatorMVVMFiles() throws {
    let scaffolder = ModuleScaffolder()
    let context = ModuleTemplateContext(
        name: "Login",
        destination: URL(fileURLWithPath: "/tmp/DemoApp/DemoApp/Modules"),
        includeService: true
    )

    let plan = try scaffolder.planModule(context: context)

    #expect(plan.files.map(\.relativePath).contains("Login/LoginViewController.swift"))
    #expect(plan.files.map(\.relativePath).contains("Login/LoginViewModel.swift"))
    #expect(plan.files.map(\.relativePath).contains("Login/LoginView.swift"))
    #expect(plan.files.map(\.relativePath).contains("Login/LoginCoordinator.swift"))
    #expect(plan.files.map(\.relativePath).contains("Login/LoginService.swift"))
}
