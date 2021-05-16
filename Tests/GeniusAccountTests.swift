//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import XCTest

class GeniusAccountTests: GeniusTestBase {

    public static func assert(_ account: GeniusAccount?) {
        guard let account = account else {
            XCTFail("Failed to get an account object in the JSON response.")
            return
        }

        XCTAssertEqual(account.name, "Jason R Tibbetts")
        XCTAssertEqual(account.login, "Jason R Tibbetts")
    }

}
