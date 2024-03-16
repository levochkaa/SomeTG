// Utils.swift

import Foundation

enum Utils {
    static let modelIdentifier: String = {
        #if targetEnvironment(simulator)
        ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"
        #else
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        var identifier = machineMirror.children.reduce("") { id, element in
            guard let value = element.value as? Int8, value != 0 else { return id }
            return id + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
        #endif
    }()
    
    static let modelName: String = {
        var name = "unknown"
        switch modelIdentifier {
            case "iPhone12,8": name = "iPhone SE (2nd)"
            case "iPhone14,6": name = "iPhone SE (3rd)"
            case "iPhone11,2": name = "iPhone XS"
            case "iPhone11,4", "iPhone11,6": name = "iPhone XS Max"
            case "iPhone11,8": name = "iPhone XR"
            case "iPhone12,1": name = "iPhone 11"
            case "iPhone12,3": name = "iPhone 11 Pro"
            case "iPhone12,5": name = "iPhone 11 Pro Max"
            case "iPhone13,1": name = "iPhone 12 mini"
            case "iPhone13,2": name = "iPhone 12"
            case "iPhone13,3": name = "iPhone 12 Pro"
            case "iPhone13,4": name = "iPhone 12 Pro Max"
            case "iPhone14,4": name = "iPhone 13 mini"
            case "iPhone14,5": name = "iPhone 13"
            case "iPhone14,2": name = "iPhone 13 Pro"
            case "iPhone14,3": name = "iPhone 13 Pro Max"
            case "iPhone14,7": name = "iPhone 14"
            case "iPhone14,8": name = "iPhone 14 Plus"
            case "iPhone15,2": name = "iPhone 14 Pro"
            case "iPhone15,3": name = "iPhone 14 Pro Max"
            case "iPhone15,4": name = "iPhone 15"
            case "iPhone15,5": name = "iPhone 15 Plus"
            case "iPhone16,1": name = "iPhone 15 Pro"
            case "iPhone16,2": name = "iPhone 15 Pro Max"
            default: break
        }
        #if targetEnvironment(simulator)
        return "Simulator \(name)"
        #else
        return name
        #endif
    }()
}
