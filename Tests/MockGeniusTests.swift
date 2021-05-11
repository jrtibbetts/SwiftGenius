//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import Combine
import XCTest

class MockGeniusTests: ClientTestBase {

    let client = MockGenius()
    let errorClient = MockGenius(useErrorMode: true)

    func testValidMode() {
        assertValidJson("user response", promise: client.account())
        _ = assertValidJson("annotation response",
                            promise: client.annotation(id: 99)).sink(receiveCompletion: { _ in },
                                                                     receiveValue: { (response) in
                                                                        GeniusAnnotationTests.assert(response)
                                                                     })
        _ = assertValidJson("artist response",
                            promise: client.artist(id: 99)).sink(receiveCompletion: { _ in },
                                                                 receiveValue: { (response) in
                                                                    GeniusArtistTests.assert(response)
                                                                 })
        _ = assertValidJson("artist songs response",
                            promise: client.songs(byArtistId : 99)).sink(receiveCompletion: { _ in },
                                                                         receiveValue: { (response) in
                                                                            GeniusArtistSongsTests.assert(response)
                                                                         })
        _ = assertValidJson("referents response",
                            promise: client.referents(forSongId: 99)).sink(receiveCompletion: { _ in },
                                                                           receiveValue: { (response) in
                                                                            GeniusReferentTests.assert(response)
                                                                           })
        assertValidJson("search results", promise: client.search(terms: "foo"))
        _ = assertValidJson("song response",
                            promise: client.song(id: 99)).sink(receiveCompletion: { _ in },
                                                               receiveValue: { (response) in
                                                                GeniusSongTests.assert(response)
                                                               })
        assertValidJson("web page response", promise: client.webPage(id: 99))
    }

    func testErrorMode() {
        assertInvalidJson("user response",         promise: errorClient.account())
        assertInvalidJson("annotation response",   promise: errorClient.annotation(id: 99))
        assertInvalidJson("artist response",       promise: errorClient.artist(id: 99))
        assertInvalidJson("artist songs response", promise: errorClient.songs(byArtistId: 99))
        assertInvalidJson("referents response",    promise: errorClient.referents(forSongId: 99))
        assertInvalidJson("search results",        promise: errorClient.search(terms: "foo"))
        assertInvalidJson("song response",         promise: errorClient.song(id: 99))
        assertInvalidJson( "web page response",    promise: errorClient.webPage(id: 99))
    }

    func testInvalidJsonRejectsPromise() {
        assertInvalidJson("broken request",
                          promise: client.brokenRequest())
    }

    @discardableResult
    func assertValidJson<T: Codable>(_ description: String = "",
                                     file: StaticString = #file,
                                     line: UInt = #line,
                                     promise: Future<T, Error>) -> Future<T, Error> {
        assert(validFuture: promise, description: description, file: file, line: line)

        return promise
    }

    @discardableResult
    func assertInvalidJson<T: Codable>(_ description: String = "",
                                       file: StaticString = #file,
                                       line: UInt = #line,
                                       promise: Future<T, Error>) -> Future<T, Error> {
        assert(invalidFuture: promise, description: description, file: file, line: line)

        return promise
    }

}
