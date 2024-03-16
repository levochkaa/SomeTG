// UserDefault.swift

import Foundation
import Combine

@propertyWrapper
struct UserDefault<Value> {
    typealias Publisher = PassthroughSubject<Value, Never>
    
    let defaultValue: Value
    let key: String
    var store: UserDefaults
    
    private var publisher = Publisher()
    
    init(wrappedValue defaultValue: Value, _ key: String, store: UserDefaults = .standard) {
        self.defaultValue = defaultValue
        self.key = key
        self.store = store
    }
    
    var wrappedValue: Value {
        get { store.object(forKey: key) as? Value ?? defaultValue }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                store.removeObject(forKey: key)
            } else {
                store.set(newValue, forKey: key)
            }
            store.synchronize()
            publisher.send(newValue)
        }
    }
    
    var projectedValue: Publisher {
        publisher
    }
}

extension UserDefault where Value: ExpressibleByNilLiteral {
    init(_ key: String, _ store: UserDefaults = .standard) {
        self.init(wrappedValue: nil, key, store: store)
    }
}

protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}

