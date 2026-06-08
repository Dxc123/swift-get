import Foundation
import Testing
@testable import SwiftGetCore

@Test func dryRunReturnsURLsWithoutWritingFiles() throws {
    let root = URL(fileURLWithPath: NSTemporaryDirectory())
        .appendingPathComponent(UUID().uuidString)
    let plan = ScaffoldPlan(
        root: root,
        files: [PlannedFile(relativePath: "Demo/File.swift", contents: "final class File {}")]
    )

    let urls = try FileWriter().write(plan, dryRun: true)

    #expect(urls == [root.appendingPathComponent("Demo/File.swift")])
    #expect(FileManager.default.fileExists(atPath: urls[0].path) == false)
}

@Test func writeCreatesParentDirectoriesAndFiles() throws {
    let root = URL(fileURLWithPath: NSTemporaryDirectory())
        .appendingPathComponent(UUID().uuidString)
    let plan = ScaffoldPlan(
        root: root,
        files: [PlannedFile(relativePath: "Demo/File.swift", contents: "final class File {}")]
    )

    let urls = try FileWriter().write(plan)

    let contents = try String(contentsOf: urls[0])
    #expect(contents == "final class File {}")
}
