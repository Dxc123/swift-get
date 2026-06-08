import Foundation

public enum SwiftGetError: Error, CustomStringConvertible, Equatable {
    case invalidName(String)
    case invalidBundleID(String)
    case missingArgument(String)
    case unknownCommand(String)
    case fileExists(String)
    case unknownTemplateVariable(String)

    public var description: String {
        switch self {
        case .invalidName(let name):
            return "Invalid Swift type name: \(name)"
        case .invalidBundleID(let bundleID):
            return "Invalid bundle id: \(bundleID)"
        case .missingArgument(let argument):
            return "Missing required argument: \(argument)"
        case .unknownCommand(let command):
            return "Unknown command: \(command)"
        case .fileExists(let path):
            return "File already exists: \(path)"
        case .unknownTemplateVariable(let key):
            return "Unknown template variable: \(key)"
        }
    }
}
