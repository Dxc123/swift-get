import Foundation

public struct FileWriter {
    public init() {}

    public func write(_ plan: ScaffoldPlan, force: Bool = false, dryRun: Bool = false) throws -> [URL] {
        let urls = plan.files.map { plan.root.appendingPathComponent($0.relativePath) }

        if dryRun {
            return urls
        }

        for (file, url) in zip(plan.files, urls) {
            if FileManager.default.fileExists(atPath: url.path), force == false {
                throw SwiftGetError.fileExists(url.path)
            }

            try FileManager.default.createDirectory(
                at: url.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            try file.contents.write(to: url, atomically: true, encoding: .utf8)
        }

        return urls
    }
}
