//  Copyright © 2018 nrith. All rights reserved.

@testable import SwiftGenius
import XCTest

class GeniusArtistTests: GeniusTestBase {

    func testDecodeArtistJson() {
        GeniusArtistTests.assert(geniusObject(inLocalJsonFileNamed: "get-artists-200")!)
    }

    public static func assert(_ artistResponse: GeniusArtist.Response) {
        XCTAssertEqual(artistResponse.meta.status, 200)

        guard let artist = artistResponse.response?.artist else {
            XCTFail("Failed to get an artist object in the JSON response.")
            return
        }

        XCTAssertEqual(artist.name, "Sia")
        XCTAssertNotNil(artist.alternateNames)
        XCTAssertTrue(artist.alternateNames!.contains("Sia Furler"))
    }

}
