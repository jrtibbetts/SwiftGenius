//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import PromiseKit
import XCTest

class MockGeniusTests: ClientTestBase {

    func testAccountReturnsValidJson() {
        assertValidJson(description: "user response",
                        promise: MockGenius().account())
    }

    func testAccountReturnsInErrorMode() {
        assertInvalidJson(description: "user response",
                          promise: MockGenius(useErrorMode: true).account())
    }

    func testAnnotationReturnsValidJson() {
        _ = assertValidJson(description: "annotation response",
                            promise: MockGenius().annotation(id: 99)).done { (annotationResponse) in
            GeniusAnnotationTests.assert(annotationResponse)
        }
    }

    func testAnnotationInErrorMode() {
        assertInvalidJson(description: "annotation response",
                          promise: MockGenius(useErrorMode: true).annotation(id: 99))
    }

    func testArtistReturnsValidJson() {
        _ = assertValidJson(description: "artist response",
                            promise: MockGenius().artist(id: 99)).done { (artistResponse) in
            GeniusArtistTests.assert(artistResponse)
        }
    }

    func testArtistInErrorMode() {
        assertInvalidJson(description: "artist response",
                          promise: MockGenius(useErrorMode: true).artist(id: 99))
    }

    func testSongsByArtistReturnsValidJson() {
        _ = assertValidJson(description: "artist songs response",
                            promise: MockGenius().songs(byArtistId : 99)).done { (songsResponse) in
            GeniusArtistSongsTests.assert(songsResponse)
        }
    }

    func testSongsByArtistInErrorMode() {
        assertInvalidJson(description: "artist songs response",
                          promise: MockGenius(useErrorMode: true).songs(byArtistId: 99))
    }

    func testReferentsReturnsValidJson() {
        _ = assertValidJson(description: "referents response",
                            promise: MockGenius().referents(forSongId: 99)).done { (referentsResponse) in
            GeniusReferentTests.assert(referentsResponse)
        }
    }

    func testReferentsInErrorMode() {
        assertInvalidJson(description: "referents response",
                          promise: MockGenius(useErrorMode: true).referents(forSongId: 99))
    }

    func testSearchReturnsValidJson() {
        assertValidJson(description: "search results",
                        promise: MockGenius().search(terms: "foo"))
    }

    func testSearchReturnsInErrorMode() {
        assertInvalidJson(description: "search results",
                          promise: MockGenius(useErrorMode: true).search(terms: "foo"))
    }

    func testSongReturnsValidJson() {
        _ = assertValidJson(description: "song response",
                            promise: MockGenius().song(id: 99)).done { (songResponse) in
            GeniusSongTests.assert(songResponse)
        }
    }

    func testSongReturnsInErrorMode() {
        assertInvalidJson(description: "song response",
                          promise: MockGenius(useErrorMode: true).song(id: 99))
    }

    func testWebPageReturnsValidJson() {
        assertValidJson(description: "web page response",
                        promise: MockGenius().webPage(id: 99))
    }

    func testWebPageReturnsInErrorMode() {
        assertInvalidJson(description: "web page response",
                          promise: MockGenius(useErrorMode: true).webPage(id: 99))
    }

    func testInvalidJsonRejectsPromise() {
        assertInvalidJson(description: "broken request",
                          promise: MockGenius().brokenRequest())
    }

    @discardableResult
    func assertValidJson<T: Codable>(description: String = "",
                                     file: StaticString = #file,
                                     line: UInt = #line,
                                     promise: Promise<T>) -> Promise<T> {
        assert(validPromise: promise, description: description, file: file, line: line)

        return promise
    }

    @discardableResult
    func assertInvalidJson<T: Codable>(description: String = "",
                                       file: StaticString = #file,
                                       line: UInt = #line,
                                       promise: Promise<T>) -> Promise<T> {
        assert(invalidPromise: promise, description: description, file: file, line: line)

        return promise
    }

}
