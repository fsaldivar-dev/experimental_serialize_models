//
//  SerializeTransform.swift
//  AnnotationSerializer
//
//  Created by Francisco Javier Saldivar Rubio on 31/07/22.
//

import Foundation

@propertyWrapper
public final class SerializeTransform<In: Encodable, Out> {    
    let key: String
    public var wrappedValue: Out?
    var transform: TransformOf<Out, In>
    
    init(_ key: String,
         _ transform: TransformOf<Out, In>,
         file: String = #fileID,
         function: String = #function,
         line: Int = #line) {
        self.key = key
        self.wrappedValue = nil
        self.transform = transform
    }
}

extension SerializeTransform: EncodableKey where In: Encodable {
    public func encodeValue(from container: inout EncodeContainer) throws {
        transform.transformToJSON(&container, wrappedValue, key: key)
    }
}

extension SerializeTransform: DecodableKey where Out: Decodable {
    public func decodeValue(from container: DecodeContainer) throws {
        let codingKey = DynamicCodingKeys(key: key)
        if let value = try container.decodeIfPresent(Out.self, forKey: codingKey) {
            wrappedValue = value
        } else {
            debugPrint("\(Serialize.self) -> Not decode")
        }
    }
}
