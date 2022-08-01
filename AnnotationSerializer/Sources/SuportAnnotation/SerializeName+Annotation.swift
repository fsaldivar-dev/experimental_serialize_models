//
//  SerializeName+Annotation.swift
//  AnnotationSerializer
//
//  Created by Francisco Javier Saldivar Rubio on 31/07/22.
//

import AnnotationSwift
import SwiftUI

extension SerializeName: Annotation {
    public func tranformValue<T>(wrappedValue: T?) -> T? {
        return wrappedValue
    }
    
    public func updateValue<T>(value: T) {
        guard let value = value as? Value else {
            return
        }
        self.wrappedValue = value
    }

}

extension State: Annotation {
    public func tranformValue<T>(wrappedValue: T?) -> T? {
        return wrappedValue
    }
    
    public func updateValue<T>(value: T) {
        guard let value = value as? Value else {
            return
        }
        self.wrappedValue = value
    }
}
