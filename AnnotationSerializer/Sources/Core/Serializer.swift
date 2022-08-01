//
//  Serialize.swift
//
//  Created by Francisco Javier Saldivar Rubio on 2/08/21.
//  Copyright © 2021 IDS Comercial. All rights reserved.
//
import Foundation
import AnnotationSwift
/// Estructura que contendrá las llaves para deserlizar el objeto, esta estructura tiene la etiqueta que contendra el atributton json, y el id del objeto serializado.
public struct DynamicCodingKeys: CodingKey {
    public var stringValue: String
    public var intValue: Int?
    /// Crea una nueva instancia a partir de la cadena dada.
    ///
    /// - parameter key: El valor de  `key` es el valor  de la clave deciada.
    init(key: String) {
        stringValue = key
    }
    /// Crea una nueva instancia a partir de la cadena dada.
    ///
    /// Si la cadena pasada como `stringValue` no corresponse a ninguna instancia de
    /// este tipo `String`, el resultado sera `nil`.
    ///
    /// - parameter stringValue: El valor de cadena de la clave deseada.
    public init?(stringValue: String) {
        self.stringValue = stringValue
    }
    /// Crea una nueva instancia a partir del  entero especificado.
    ///
    /// Si el valor pasado como `intValue` no correscponde a ninguna instancia de
    /// este tipo, el resultado sera `nil`.
    ///
    /// - parameter intValue: The integer value of the desired key.
    public init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = String(intValue)
    }
}

/// Protocolo que expone el método para códificar los atributtos json
public protocol EncodableKey {
    /// `EncodeContainer` Es Un contenedor concreto que proporciona una vista del almacenamiento de un codificador, con
    /// las propiedades codificadas de un tipo codificable accesible por claves.
    typealias EncodeContainer = KeyedEncodingContainer<DynamicCodingKeys>

    /// El método encodeValue recibe el objeto `conainer`, el cual tiene la propiedad de `inout`
    /// el proposito de esto es que dentro de la funcion `encodeValue` es que se inserte al contenedor
    /// con una llave y un valor `try container.encodeIfPresent("value", forKey: "Key")`
    /// - Parameter container: Contenedro de claves y valores
    func encodeValue(from container: inout EncodeContainer) throws
}
/// Un tipo que puede codificarse a sí mismo en una representación externa.
public protocol SuperEncodable: Encodable { }
public extension SuperEncodable {
    /// Codifica este valor en el codificador dado.
    ///
    /// Si el valor no codifica nada, `encoder` codificará un vacío
    /// contenedor con llave en su lugar.
    ///
    /// - Parameter encoder: el codificador en el que escribir datos.
    /// - Throws: Esta función arroja un error si algún valor no es válido para el
    /// formato del codificador.
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)
        for child in Mirror(reflecting: self).children {
            guard let groupable = child.value as? AnnotationGroup else {
                guard let encodableKey = child.value as? EncodableKey else {
                    continue
                }
                try encodableKey.encodeValue(from: &container)
                continue
            }
            
            guard let encodableKey = groupable.annotations.first(where: { $0 is EncodableKey }) as? EncodableKey  else {
                continue
            }
            try encodableKey.encodeValue(from: &container)
        }
    }

    /// Método que serializa el obeto  y retorna  un `json` de tipo `Data`
    /// - Returns: retonra el objeto `Data` de la cadena serializada. `json Data`
    func toJsonData() -> Data? {
        let encode = JSONEncoder()
        guard let data = try? encode.encode(self) else {
            return  nil
        }
        return data
    }

    /// Método que serializa el obeto  y retorna  un `json` de tipo `String`
    /// - Returns: retorna la cadena de caracteres serializada. `json Stirng`
    func toJsonString() -> NSString? {
        let encode = JSONEncoder()
        encode.outputFormatting = .prettyPrinted
        
        guard let data = try? encode.encode(self) else {
            return  nil
        }
        return data.prettyPrintedJSONString
    }

}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}

/// Protocolo que expone funciones para decodificar un json
public protocol DecodableKey {
    typealias DecodeContainer = KeyedDecodingContainer<DynamicCodingKeys>
    func decodeValue(from container: DecodeContainer) throws
}

public protocol SuperDecodable: Decodable {
    init()
}
public extension SuperDecodable {
    init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        for child in Mirror(reflecting: self).children {
            guard let decodableKey = child.value as? DecodableKey else {
                continue
            }
            try decodableKey.decodeValue(from: container)
        }
    }
}
///  En ciencias de la computación, la serialización (o marshalling en inglés) consiste en un proceso de codificación de un objeto en un medio de almacenamiento (como puede ser un archivo, o un buffer de memoria) con el fin de transmitirlo a través de una conexión en red como una serie de bytes o en un formato humanamente más legible como XML o JSON
public typealias Serialize = SuperEncodable & SuperDecodable


@propertyWrapper
final public  class SerializeName<Value> {

    let key: String
    public var wrappedValue: Value?
    public init(_ key: String) {
        self.key = key
        self.wrappedValue = nil
    }
}

extension SerializeName: EncodableKey where Value: Encodable {
    public func encodeValue(from container: inout EncodeContainer) throws {
        let codingKey = DynamicCodingKeys(key: key)
        try container.encodeIfPresent(wrappedValue, forKey: codingKey)
    }
}

extension SerializeName: DecodableKey where Value: Decodable {
    public func decodeValue(from container: DecodeContainer) throws {
        let codingKey = DynamicCodingKeys(key: key)

        if let value = try container.decodeIfPresent(Value.self, forKey: codingKey) {
            wrappedValue = value
        }
    }
}

