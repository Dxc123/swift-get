public struct TemplateRenderer {
    public init() {}

    public func render(_ template: String, values: [String: String]) throws -> String {
        var output = ""
        var index = template.startIndex

        while index < template.endIndex {
            if template[index...].hasPrefix("{{") {
                let keyStart = template.index(index, offsetBy: 2)
                guard let closeRange = template[keyStart...].range(of: "}}") else {
                    output.append(template[index])
                    index = template.index(after: index)
                    continue
                }

                let rawKey = template[keyStart..<closeRange.lowerBound]
                let key = rawKey.trimmingCharacters(in: .whitespacesAndNewlines)
                guard let value = values[key] else {
                    throw SwiftGetError.unknownTemplateVariable(key)
                }

                output.append(value)
                index = closeRange.upperBound
            } else {
                output.append(template[index])
                index = template.index(after: index)
            }
        }

        return output
    }
}
