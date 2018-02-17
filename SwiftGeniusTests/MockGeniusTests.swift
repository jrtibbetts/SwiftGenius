//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import PromiseKit
import XCTest

class MockGeniusTests: ClientTestBase {

    func testAccountReturnsValidJson() {
        assertValidJson(description: "user response") { (genius) -> Promise<GeniusAccount.Response> in
            genius.account()
        }
    }

    func testAccountReturnsInErrorMode() {
        assertInvalidJson(description: "user response") { (genius) -> Promise<GeniusAccount.Response> in
            genius.account()
        }
    }

    func testAnnotationReturnsValidJson() {
        assertValidJson(description: "annotation response") { (genius) -> Promise<GeniusAnnotation.Response> in
            genius.annotation(id: 99)
            }.then { (annotationResponse) in
                GeniusAnnotationTests.assert(annotationResponse)
        }
    }

    func testAnnotationInErrorMode() {
        assertInvalidJson(description: "annotation response") { (genius) -> Promise<GeniusAnnotation.Response> in
            genius.annotation(id: 99)
        }
    }

    func testArtistReturnsValidJson() {
        assertValidJson(description: "artist response") { (genius) -> Promise<GeniusArtist.Response> in
            genius.artist(id: 99)
            }.then { (artistResponse) in
                GeniusArtistTests.assert(artistResponse)
        }
    }

    func testArtistInErrorMode() {
        assertInvalidJson(description: "artist response") { (genius) -> Promise<GeniusArtist.Response> in
            genius.artist(id: 99)
        }
    }

    func testSongsByArtistReturnsValidJson() {
        assertValidJson(description: "artist songs response") { (genius) -> Promise<GeniusArtistSongs.Response> in
            genius.songs(byArtistId : 99)
            }.then { (songsResponse) in
                GeniusArtistSongsTests.assert(songsResponse)
        }
    }

    func testSongsByArtistInErrorMode() {
        assertInvalidJson(description: "artist songs response") { (genius) -> Promise<GeniusArtistSongs.Response> in
            genius.songs(byArtistId: 99)
        }
    }

    func testReferentsReturnsValidJson() {
        assertValidJson(description: "referents response") { (genius) -> Promise<GeniusReferent.Response> in
            genius.referents(forSongId: 99)
            }.then { (referentsResponse) in
                GeniusReferentTests.assert(referentsResponse)
        }
    }

    func testReferentsInErrorMode() {
        assertInvalidJson(description: "referents response") { (genius) -> Promise<GeniusReferent.Response> in
            genius.referents(forSongId: 99)
        }
    }

    func testSearchReturnsValidJson() {
        assertValidJson(description: "search results") { (genius) -> Promise<GeniusSearch.Response> in
            genius.search(terms: "foo")
        }
    }

    func testSearchReturnsInErrorMode() {
        assertInvalidJson(description: "search results") { (genius) -> Promise<GeniusSearch.Response> in
            genius.search(terms: "foo")
        }
    }

    func testSongReturnsValidJson() {
        assertValidJson(description: "song response") { (genius) -> Promise<GeniusSong.Response> in
            genius.song(id: 99)
            }.then { (songResponse) in
                GeniusSongTests.assert(songResponse)
        }
    }

    func testSongReturnsInErrorMode() {
        assertInvalidJson(description: "song response") { (genius) -> Promise<GeniusSong.Response> in
            genius.song(id: 99)
        }
    }

    func testWebPageReturnsValidJson() {
        assertValidJson(description: "web page response") { (genius) -> Promise<GeniusWebPage.Response> in
            genius.webPage(id: 99)
        }
    }

    func testWebPageReturnsInErrorMode() {
        assertInvalidJson(description: "web page response") { (genius) -> Promise<GeniusWebPage.Response> in
            genius.webPage(id: 99)
        }
    }

    func testInvalidJsonRejectsPromise() {
        assertInvalidJson(description: "broken request") { (genius) -> Promise<String> in
            genius.brokenRequest()
        }
    }

    @discardableResult
    func assertValidJson<T: Codable>(description: String = "",
                                     function: (MockGenius) -> Promise<T>) -> Promise<T> {
        let promise = function(MockGenius())
        assert(validPromise: promise, description: description)

        return promise
    }

    @discardableResult
    func assertInvalidJson<T: Codable>(description: String = "",
                                       function: (MockGenius) -> Promise<T>) -> Promise<T> {
        let promise = function(MockGenius(useErrorMode: true))
        assert(invalidPromise: promise, description: description)

        return promise
    }

}
