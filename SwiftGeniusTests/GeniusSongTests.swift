//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import XCTest

class GeniusSongTests: GeniusTestBase {

    func testDecodeSongs() {
        GeniusSongTests.assert(geniusObject(inLocalJsonFileNamed: "get-songs-200")!)
    }

    public static func assert(_ songResponse: GeniusSong.Response) {
        XCTAssertEqual(songResponse.meta.status, 200)

        guard let _ = songResponse.response?.song else {
            XCTFail("The response is supposed to contain a song.")
            return
        }
    }

}
