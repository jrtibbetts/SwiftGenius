//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import XCTest

class GeniusArtistTests: GeniusTestBase {

    public static func assert(_ artist: GeniusArtist?) {
        guard let artist = artist else {
            XCTFail("Failed to get an artist object in the JSON response.")
            return
        }

        XCTAssertEqual(artist.name, "Sia")
        XCTAssertNotNil(artist.alternateNames)
        XCTAssertTrue(artist.alternateNames!.contains("Sia Furler"))
    }

}
