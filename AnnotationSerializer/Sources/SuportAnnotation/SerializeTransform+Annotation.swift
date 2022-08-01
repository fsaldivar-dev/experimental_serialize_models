//
//  SerializeTransform+Annotation.swift
//  AnnotationSerializer
//
//  Created by Francisco Javier Saldivar Rubio on 31/07/22.
//

import Foundation
import AnnotationSwift

extension SerializeTransform: Annotation {
    public func tranformValue<T>(wrappedValue: T?) -> T? {
        return wrappedValue
    }
    
    public func updateValue<T>(value: T) {
        guard let value = value as? Out else {
            return
        }
        self.wrappedValue = value
    }
}
