//  Copyright © 2017 nrith. All rights reserved.

@testable import SwiftGenius
import XCTest

class GeniusAnnotationTests: GeniusTestBase {

    func testDecodeAnnotationJson() {
        GeniusAnnotationTests.assert(geniusObject(inLocalJsonFileNamed: "get-annotations-200")!)
    }

    public static func assert(_ annotationResponse: GeniusAnnotation.Response) {
        XCTAssertEqual(annotationResponse.meta.status, 200)

        let response = annotationResponse.response!
        XCTAssertTrue(response.annotation.hasVoters)
    }

}
