//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import XCTest

class GeniusAccountTests: GeniusTestBase {

    func testDecodeAccountJson() throws {
        GeniusAccountTests.assert(try geniusObject(inLocalJsonFileNamed: "get-account-200"))
    }

    public static func assert(_ accountResponse: GeniusAccount.Response) {
        XCTAssertEqual(accountResponse.meta.status, 200)

        guard let account = accountResponse.response?.user else {
            XCTFail("Failed to get an account object in the JSON response.")
            return
        }

        XCTAssertEqual(account.name, "Jason R Tibbetts")
        XCTAssertEqual(account.login, "Jason R Tibbetts")
    }

}
