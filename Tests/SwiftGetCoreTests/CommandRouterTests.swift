import Foundation
import Testing
@testable import SwiftGetCore

@Test func createDryRunPrintsPlannedFiles() throws {
    let root = URL(fileURLWithPath: NSTemporaryDirectory())
        .appendingPathComponent(UUID().uuidString)

    let output = try CommandRouter().run(arguments: [
        "create",
        "DemoApp",
        "--bundle-id",
        "com.example.demo",
        "--path",
        root.path,
        "--dry-run"
    ])

    #expect(output.contains("Would create"))
    #expect(output.contains("DemoApp/App/AppDelegate.swift"))
    #expect(FileManager.default.fileExists(atPath: root.appendingPathComponent("DemoApp").path) == false)
}

@Test func generateModuleDryRunPrintsPlannedFiles() throws {
    let root = URL(fileURLWithPath: NSTemporaryDirectory())
        .appendingPathComponent(UUID().uuidString)

    let output = try CommandRouter().run(arguments: [
        "generate",
        "module",
        "Login",
        "--project",
        root.path,
        "--dry-run"
    ])

    #expect(output.contains("Would generate"))
    #expect(output.contains("Login/LoginViewController.swift"))
    #expect(output.contains("Login/LoginService.swift"))
}
