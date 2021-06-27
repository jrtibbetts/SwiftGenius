//  Copyright © 2017 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import XCTest

class GeniusAnnotationTests: GeniusTestBase {

    public static func assert(_ annotation: GeniusAnnotation) {
        XCTAssertTrue(annotation.hasVoters)
    }

}
