import Foundation

public struct CommandRouter {
    private let writer = FileWriter()

    public init() {}

    public func run(arguments: [String]) throws -> String {
        guard let command = arguments.first else {
            return helpText
        }

        switch command {
        case "create":
            return try runCreate(Array(arguments.dropFirst()))
        case "generate":
            return try runGenerate(Array(arguments.dropFirst()))
        case "help", "--help", "-h":
            return helpText
        default:
            throw SwiftGetError.unknownCommand(command)
        }
    }

    private func runCreate(_ arguments: [String]) throws -> String {
        guard let appName = arguments.first else {
            throw SwiftGetError.missingArgument("AppName")
        }

        let bundleID = try requiredOptionValue("--bundle-id", in: arguments)
        let organization = optionValue("--org", in: arguments) ?? "Generated"
        let path = optionValue("--path", in: arguments) ?? FileManager.default.currentDirectoryPath
        let force = arguments.contains("--force")
        let dryRun = arguments.contains("--dry-run")

        let context = ProjectTemplateContext(
            appName: appName,
            bundleID: bundleID,
            organizationName: organization,
            destination: URL(fileURLWithPath: path).appendingPathComponent(appName)
        )
        let plan = try ProjectScaffolder().plan(context: context)
        let urls = try writer.write(plan, force: force, dryRun: dryRun)
        return summary(action: dryRun ? "Would create" : "Created", urls: urls)
    }

    private func runGenerate(_ arguments: [String]) throws -> String {
        guard arguments.count >= 2 else {
            throw SwiftGetError.missingArgument("generate module|page <Name>")
        }

        let kind = arguments[0]
        let name = arguments[1]
        let projectPath = optionValue("--project", in: arguments) ?? FileManager.default.currentDirectoryPath
        let module = optionValue("--module", in: arguments)
        let force = arguments.contains("--force")
        let dryRun = arguments.contains("--dry-run")

        let destination: URL
        if let module {
            destination = URL(fileURLWithPath: projectPath).appendingPathComponent(module)
        } else {
            destination = URL(fileURLWithPath: projectPath)
        }

        switch kind {
        case "module":
            let plan = try ModuleScaffolder().planModule(
                context: ModuleTemplateContext(name: name, destination: destination, includeService: true)
            )
            let urls = try writer.write(plan, force: force, dryRun: dryRun)
            return summary(action: dryRun ? "Would generate" : "Generated", urls: urls)
        case "page":
            let plan = try ModuleScaffolder().planModule(
                context: ModuleTemplateContext(name: name, destination: destination, includeService: false)
            )
            let urls = try writer.write(plan, force: force, dryRun: dryRun)
            return summary(action: dryRun ? "Would generate" : "Generated", urls: urls)
        default:
            throw SwiftGetError.unknownCommand("generate \(kind)")
        }
    }

    private func optionValue(_ option: String, in arguments: [String]) -> String? {
        guard let index = arguments.firstIndex(of: option) else {
            return nil
        }

        let valueIndex = arguments.index(after: index)
        guard valueIndex < arguments.endIndex else {
            return nil
        }

        return arguments[valueIndex]
    }

    private func requiredOptionValue(_ option: String, in arguments: [String]) throws -> String {
        guard let value = optionValue(option, in: arguments) else {
            throw SwiftGetError.missingArgument(option)
        }

        return value
    }

    private func summary(action: String, urls: [URL]) -> String {
        ([action] + urls.map(\.path)).joined(separator: "\n")
    }

    public var helpText: String {
        """
        swift-get

        Commands:
          swift-get create <AppName> --bundle-id <id> [--org <name>] [--path <path>] [--force] [--dry-run]
          swift-get generate module <Name> [--project <path>] [--force] [--dry-run]
          swift-get generate page <Name> [--project <path>] [--module <module>] [--force] [--dry-run]
        """
    }
}
