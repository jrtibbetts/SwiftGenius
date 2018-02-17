//  Copyright © 2018 nrith. All rights reserved.

@testable import SwiftGenius
import XCTest

class GeniusAccountTests: GeniusTestBase {

    func testDecodeAccountJson() {
        GeniusAccountTests.assert(geniusObject(inLocalJsonFileNamed: "get-account-200")!)
    }

    public static func assert(_ accountResponse: GeniusAccount.Response) {
        XCTAssertEqual(accountResponse.meta.status, 200)

        guard let account = accountResponse.response?.user else {
            XCTFail("Failed to get an account object in the JSON response.")
            return
        }

        XCTAssertEqual(account.name, "nrith")
        XCTAssertEqual(account.login, "nrith")
    }

}
