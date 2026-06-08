import Foundation

public struct PlannedFile: Equatable {
    public let relativePath: String
    public let contents: String

    public init(relativePath: String, contents: String) {
        self.relativePath = relativePath
        self.contents = contents
    }
}

public struct ScaffoldPlan: Equatable {
    public let root: URL
    public let files: [PlannedFile]

    public init(root: URL, files: [PlannedFile]) {
        self.root = root
        self.files = files
    }
}

public struct ProjectTemplateContext: Equatable {
    public let appName: String
    public let bundleID: String
    public let organizationName: String
    public let destination: URL

    public init(appName: String, bundleID: String, organizationName: String, destination: URL) {
        self.appName = appName
        self.bundleID = bundleID
        self.organizationName = organizationName
        self.destination = destination
    }
}

public struct ModuleTemplateContext: Equatable {
    public let name: String
    public let destination: URL
    public let includeService: Bool

    public init(name: String, destination: URL, includeService: Bool) {
        self.name = name
        self.destination = destination
        self.includeService = includeService
    }
}
