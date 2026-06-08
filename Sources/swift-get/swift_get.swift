import Darwin
import SwiftGetCore

@main
struct SwiftGetCLI {
    static func main() {
        do {
            let output = try CommandRouter().run(arguments: Array(CommandLine.arguments.dropFirst()))
            print(output)
        } catch {
            fputs("swift-get: \(error)\n", stderr)
            Darwin.exit(1)
        }
    }
}
