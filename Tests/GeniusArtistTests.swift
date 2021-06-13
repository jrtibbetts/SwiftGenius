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

    func testArtistJson() throws {
        do {
            let jsonUrl = SwiftGenius.resourceBundle.url(forResource: "get-artists-200", withExtension: "json")!
            let jsonData = try Data(contentsOf: jsonUrl)
            let response = try GeniusDecoder().decode(GeniusArtist.Response.self, from: jsonData)
            Self.assert(response.response?.artist)
        } catch {
            XCTFail("Failed: \(error)")
        }
    }

}
