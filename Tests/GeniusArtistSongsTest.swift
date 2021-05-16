//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import XCTest

class GeniusArtistSongsTests: GeniusTestBase {

    public static func assert(_ songs: [GeniusSong]?) {
        guard let songs = songs else {
            XCTFail("Failed to get the song objects in the JSON response.")
            return
        }

        XCTAssertEqual(songs.count, 20)

        let firstSong = songs[0]
        XCTAssertEqual(firstSong.annotationCount, 8)
        XCTAssertEqual(firstSong.pyongsCount, 8)
    }

}
