//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import XCTest

class GeniusAccountTests: GeniusTestBase {

    func testRealAccountResponse() throws {
        let url = SwiftGenius.resourceBundle.url(forResource: "get-account-200", withExtension: "json")!
        let accountResponse: GeniusAccount.Response = try GeniusAccount.Response.decode(fromURL: url, withDecoder: GeniusClient.jsonDecoder)

        XCTAssertEqual(accountResponse.meta.status, 200)
        Self.assert(accountResponse.response!.user)
    }

    public static func assert(_ account: GeniusAccount?) {
        guard let account = account else {
            XCTFail("Failed to get an account object in the JSON response.")
            return
        }

        XCTAssertEqual(account.name, "Jason R Tibbetts")
        XCTAssertEqual(account.login, "Jason R Tibbetts")
    }

}
