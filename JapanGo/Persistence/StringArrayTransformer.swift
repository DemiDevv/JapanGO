//
//  StringArrayTransformer.swift
//  JapanGo
//
//  Created by Demain Petropavlov on 01.04.2026.
//

import Foundation

@objc(StringArrayTransformer)
final class StringArrayTransformer: ValueTransformer {

    static let name = NSValueTransformerName(rawValue: "StringArrayTransformer")

    override class func transformedValueClass() -> AnyClass {
        NSData.self
    }

    override class func allowsReverseTransformation() -> Bool {
        true
    }

    /// [String] → Data (запись в CoreData)
    override func transformedValue(_ value: Any?) -> Any? {
        guard let array = value as? [String] else { return nil }
        return try? JSONEncoder().encode(array)
    }

    /// Data → [String] (чтение из CoreData)
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        return (try? JSONDecoder().decode([String].self, from: data)) ?? []
    }

    static func register() {
        ValueTransformer.setValueTransformer(
            StringArrayTransformer(),
            forName: name
        )
    }
}
