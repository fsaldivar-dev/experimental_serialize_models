//
//  TransformOf.swift
//
//  Created by Francisco Javier Saldivar Rubio on 16/03/21.
//  Copyright © 2021 IDS Comercial. All rights reserved.
//

import Foundation
protocol DataTransform { }
protocol TransformType: DataTransform {
    associatedtype Out
    associatedtype In: Encodable
    func transformFromJSON(_ value: Any?) -> Out?
    func transformToJSON(_ container: inout EncodableKey.EncodeContainer, _ value: Out?, key: String)
}

public class TransformOf<OutType, InType: Encodable>: TransformType {
    public typealias Out = OutType
    public typealias In = InType

    private let fromJSON: (InType?) -> OutType?
    private let toJSON: (OutType?) -> InType?

    public init(fromJSON: @escaping(InType?) -> OutType?, toJSON: @escaping(OutType?) -> InType?) {
        self.fromJSON = fromJSON
        self.toJSON = toJSON
    }
    public func transformFromJSON(_ value: Any?) -> OutType? {
        return fromJSON(value as? InType)
    }

    func transformToJSON(_ container: inout KeyedEncodingContainer<DynamicCodingKeys>,
                         _ value: Out?,
                         key: String) {
        if let inOubject = toJSON(value) {
            let codingKey = DynamicCodingKeys(key: key)
            try? container.encodeIfPresent(inOubject, forKey: codingKey)
        }
    }
}


enum ToThrowsParseEnum: Error {
    case PARSING(String, String)
}

extension ToThrowsParseEnum: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .PARSING(let a, let b):
            return NSLocalizedString("Parssing Error", comment: "Error tryping to convert \(a) to \(b) ")
        }
    }
}
