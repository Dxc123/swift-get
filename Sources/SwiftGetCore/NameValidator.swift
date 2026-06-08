import Foundation

public enum NameValidator {
    private static let reservedWords: Set<String> = [
        "associatedtype", "class", "deinit", "enum", "extension", "fileprivate",
        "func", "import", "init", "inout", "internal", "let", "open", "operator",
        "private", "protocol", "public", "static", "struct", "subscript",
        "typealias", "var"
    ]

    public static func validateTypeName(_ name: String) throws {
        guard !name.isEmpty else {
            throw SwiftGetError.invalidName(name)
        }

        guard reservedWords.contains(name) == false else {
            throw SwiftGetError.invalidName(name)
        }

        let scalars = Array(name.unicodeScalars)
        guard let first = scalars.first else {
            throw SwiftGetError.invalidName(name)
        }

        let validFirst = CharacterSet.letters.contains(first) || first == "_"
        guard validFirst else {
            throw SwiftGetError.invalidName(name)
        }

        let validBody = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))
        guard scalars.dropFirst().allSatisfy({ validBody.contains($0) }) else {
            throw SwiftGetError.invalidName(name)
        }
    }

    public static func validateBundleID(_ bundleID: String) throws {
        let parts = bundleID.split(separator: ".")
        guard parts.count >= 2 else {
            throw SwiftGetError.invalidBundleID(bundleID)
        }

        for part in parts {
            let text = String(part)
            guard text.range(of: #"^[A-Za-z][A-Za-z0-9-]*$"#, options: .regularExpression) != nil else {
                throw SwiftGetError.invalidBundleID(bundleID)
            }
        }
    }
}
