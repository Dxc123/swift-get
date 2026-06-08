import Testing
@testable import SwiftGetCore

@Test func rendersKnownVariables() throws {
    let renderer = TemplateRenderer()
    let output = try renderer.render(
        "final class {{moduleName}}ViewController: UIViewController {}",
        values: ["moduleName": "Login"]
    )

    #expect(output == "final class LoginViewController: UIViewController {}")
}

@Test func throwsForUnknownVariables() throws {
    let renderer = TemplateRenderer()

    #expect(throws: SwiftGetError.self) {
        _ = try renderer.render("{{missing}}", values: [:])
    }
}
