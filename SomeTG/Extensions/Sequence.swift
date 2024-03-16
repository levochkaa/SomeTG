// Sequence.swift

import Foundation

extension Sequence where Element: Sendable {
    func asyncCompactMap<T>(_ transform: (Element) async throws -> T?) async rethrows -> [T] {
        var values = [T]()
        
        for element in self {
            guard let value = try await transform(element) else { continue }
            values.append(value)
        }
        
        return values
    }
}
