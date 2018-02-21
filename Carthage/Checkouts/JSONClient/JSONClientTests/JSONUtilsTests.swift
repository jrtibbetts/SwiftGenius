//  Copyright © 2017 nrith. All rights reserved.

@testable import JSONClient
import XCTest

class JSONUtilsTests: XCTestCase {

    func testJsonDataEncodeAndDecode() {
        let foo = Foo(foo: 99, bar: "Huzzah!")

        do {
            let fooData = try JSONUtils.jsonData(forObject: foo)
            let otherFoo: Foo = try JSONUtils.jsonObject(data: fooData)
            XCTAssertEqual(foo, otherFoo)
        } catch {
            XCTFail("Failed to encode or decode the Foo: \(error.localizedDescription)")
        }
    }

    func testUrlForUnknownFilenameThrows() {
        let fileName = "this file can't possibly exist"
        let fileType = "vogonPoetry"

        XCTAssertThrowsError(try JSONUtils.url(forFileNamed: fileName, ofType: fileType, inBundle: Bundle(for: type(of: self))))
    }

    struct Foo: Codable, Equatable {

        static func ==(lhs: JSONUtilsTests.Foo, rhs: JSONUtilsTests.Foo) -> Bool {
            return (lhs.foo == rhs.foo) && (lhs.bar == rhs.bar)
        }

        var foo: Int
        var bar: String?

    }

}
