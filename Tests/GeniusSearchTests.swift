//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import XCTest

class GeniusSearchTests: GeniusTestBase {

    public static func assert(_ hits: [GeniusSong]?) {
        guard let hits = hits else {
            XCTFail("The response is supposed to contain at least one song.")
            return
        }

        XCTAssertEqual(hits.count, 10)
    }

}



