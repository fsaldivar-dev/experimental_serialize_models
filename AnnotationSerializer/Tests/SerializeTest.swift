//
//  File.swift
//  
//
//  Created by Francisco Javier Saldivar Rubio on 02/08/21.
//

import Foundation
import XCTest
@testable import AnnotationSerializer

extension Date {
    func toString(withFormat format: String = "dd/MM/yyyy", locale: String = "es-MS") -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: locale)
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let str = dateFormatter.string(from: self)
        return str
    }
}

extension String {
    /// Convierte al string en una feca "Date"
    /// - Parameter format: Formato de fecha actual
    func toDate(withFormat format: String = "dd/MM/yyyy", locale: String = "es") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: locale)
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format

        let date = dateFormatter.date(from: self)
        return date
    }

}

extension TransformOf where Out == Date, In == String {
    static func toSimpleDate() -> TransformOf<Date, String> {
        TransformOf<Date, String>.init { (dateString) -> Date? in
            guard let date =  dateString else { return nil }
            return date.toDate()
        } toJSON: { (dateObj) -> String? in
            guard let date = dateObj else { return nil }
            return date.toString()
        }
    }
}
struct MockModels: Serialize {
    @SerializeName("names_group")
    var namesGroup: [MockModel]?
    @SerializeName("date")
    var date: Date?
    @SerializeTransform("Simple_date", TransformOf.toSimpleDate())
    var simpleDate: Date?
}

struct MockModel: Serialize {
    @SerializeName("name")
    var name: String?
    
    @SerializeName("last_Name")
    var lastName: String?
    
    @SerializeName("Age")
    var age: Int?
}

final class SerializeTest: XCTestCase {
    func test_parse() {
        let mock = MockModels.init()
        let user = MockModel()
        user.name = "Francisco"
        user.lastName = "Saldivar Rubbio"
        user.age = 28
        let user1 = MockModel()
        user1.name = "Javier"
        user1.lastName = "Saldivar Rubbio"
        user1.age = 28
        let user2 = MockModel()
        user2.name = "Francisco Javier"
        user2.lastName = "Saldivar Rubbio"
        user2.age = 28
        mock.date = Date()
        mock.simpleDate = Date()
        mock.namesGroup = [user, user1, user2]
        
        XCTAssertNotNil(mock.toJsonData())
        XCTAssertNotNil(mock.toJsonString())
        XCTAssert((mock.toJsonString()?.count ?? 0) > 0)
        XCTAssert(mock.simpleDate != nil)
    }
}
