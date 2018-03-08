//  Copyright © 2017-2018 Poikile Creations. All rights reserved.

@testable import JSONClient
import XCTest

class JSONUtilsTests: XCTestCase {
    
    func testJsonDataEncodeAndDecode() throws {
        let foo = Foo(foo: 99, bar: "Huzzah!")
        
        let fooData = try JSONUtils.jsonData(forObject: foo)
        let otherFoo: Foo = try JSONUtils.jsonObject(data: fooData)
        XCTAssertEqual(foo, otherFoo)
    }
    
    func testUrlForUnknownFilenameThrows() {
        let fileName = "this file can't possibly exist"
        let fileType = "vogonPoetry"
        
        XCTAssertThrowsError(try JSONUtils.url(forFileNamed: fileName,
                                               ofType: fileType,
                                               inBundle: Bundle(for: type(of: self))))
    }
    
    func testJsonDataForLocalFile() throws {
        let foo: Foo = try JSONUtils.jsonObject(forFileNamed: "SampleFoo",
                                                ofType: "json",
                                                inBundle: Bundle(for: type(of: self)))
        XCTAssertEqual(foo.foo, 9)
        XCTAssertEqual(foo.bar, "ninety-nine")
    }
    
    struct Foo: Codable, Equatable {
        
        static func ==(lhs: Foo, rhs: Foo) -> Bool {
            return (lhs.foo == rhs.foo) && (lhs.bar == rhs.bar)
        }
        
        var foo: Int
        var bar: String?
        
    }
    
}
