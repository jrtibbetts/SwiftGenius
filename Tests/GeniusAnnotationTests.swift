//  Copyright © 2017 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import XCTest

class GeniusAnnotationTests: GeniusTestBase {

    func testDecodeAnnotationJson() throws {
        GeniusAnnotationTests.assert(try geniusObject(inLocalJsonFileNamed: "get-annotations-200"))
    }

    public static func assert(_ annotationResponse: GeniusAnnotation.Response) {
        XCTAssertEqual(annotationResponse.meta.status, 200)

        let response = annotationResponse.response!
        XCTAssertTrue(response.annotation.hasVoters)
    }

}
