//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import XCTest

class GeniusArtistSongsTests: GeniusTestBase {

    func testDecodeArtistJson() throws {
        GeniusArtistSongsTests.assert(try geniusObject(inLocalJsonFileNamed: "get-artist-songs-200"))
    }

    public static func assert(_ artistSongsResponse: GeniusArtistSongs.Response) {
        XCTAssertEqual(artistSongsResponse.meta.status, 200)

        guard let songs = artistSongsResponse.response?.songs else {
            XCTFail("Failed to get the song objects in the JSON response.")
            return
        }

        XCTAssertEqual(songs.count, 20)

        let firstSong = songs[0]
        XCTAssertEqual(firstSong.annotationCount, 8)
        XCTAssertEqual(firstSong.pyongsCount, 8)
    }

}
