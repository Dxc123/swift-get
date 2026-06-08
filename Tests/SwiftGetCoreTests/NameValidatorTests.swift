import Testing
@testable import SwiftGetCore

@Test func acceptsValidSwiftTypeNames() throws {
    try NameValidator.validateTypeName("Login")
    try NameValidator.validateTypeName("UserProfile")
    try NameValidator.validateTypeName("_Debug")
}

@Test func rejectsInvalidSwiftTypeNames() throws {
    #expect(throws: SwiftGetError.self) {
        try NameValidator.validateTypeName("login-page")
    }
    #expect(throws: SwiftGetError.self) {
        try NameValidator.validateTypeName("1Login")
    }
    #expect(throws: SwiftGetError.self) {
        try NameValidator.validateTypeName("class")
    }
}
