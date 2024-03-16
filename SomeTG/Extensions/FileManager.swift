// FileManager.swift

import Foundation

let fileManager: FileManager = .default

extension FileManager {
    var td: URL {
        try! url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appending(path: "td")
    }
}
