//  Copyright © 2018 nrith. All rights reserved.

@testable import SwiftGenius
import XCTest

class GeniusReferentTests: GeniusTestBase {

    func testDecodeReferentJson() {
        GeniusReferentTests.assert(geniusObject(inLocalJsonFileNamed: "get-referents-200")!)
    }

    public static func assert(_ referentResponse: GeniusReferent.Response) {
        XCTAssertEqual(referentResponse.meta.status, 200)

        guard let referents = referentResponse.response?.referents else {
            XCTFail("The response is supposed to contain an array of referents.")
            return
        }

        XCTAssertEqual(referents.count, 10)

        let firstReferent = referents[0]
        XCTAssertEqual(firstReferent.annotatorId, 3191803)
        XCTAssertEqual(firstReferent.annotatorLogin, "TalgatKalybay")
        XCTAssertNotNil(firstReferent.featured)
        XCTAssertFalse(firstReferent.featured!)
        XCTAssertFalse(firstReferent.isDescription)
    }

}
