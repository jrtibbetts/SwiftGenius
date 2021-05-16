//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import Combine
import XCTest

class MockGeniusTests: ClientTestBase {

    let client = MockGenius()
    let errorClient = MockGenius(useErrorMode: true)

    func testValidMode() {
        _ = assertValidJson("user response", promise: client.account()).sink(receiveCompletion: { _ in },
                                                                             receiveValue: { (account) in
                                                                                GeniusAccountTests.assert(account)
                                                                             })
        _ = assertValidJson("annotation",
                            promise: client.annotation(id: 99)).sink(receiveCompletion: { _ in },
                                                                     receiveValue: { (annotation) in
                                                                        GeniusAnnotationTests.assert(annotation)
                                                                     })
        _ = assertValidJson("artist",
                            promise: client.artist(id: 99)).sink(receiveCompletion: { _ in },
                                                                 receiveValue: { (artist) in
                                                                    GeniusArtistTests.assert(artist)
                                                                 })
        _ = assertValidJson("artist songs",
                            promise: client.songs(byArtistId : 99)).sink(receiveCompletion: { _ in },
                                                                         receiveValue: { (songs) in
                                                                            GeniusArtistSongsTests.assert(songs)
                                                                         })
        _ = assertValidJson("referents",
                            promise: client.referents(forSongId: 99)).sink(receiveCompletion: { _ in },
                                                                           receiveValue: { (referents) in
                                                                            GeniusReferentTests.assert(referents)
                                                                           })
        assertValidJson("search results", promise: client.search(terms: "foo")) // .sink(receiveCompletion: { _ in },
//                                                                                         receiveValue: { (search) in
//                                                                                            GeniusSearchTests.assert(search.highlights)
//                                                                                         })
        _ = assertValidJson("song",
                            promise: client.song(id: 99)).sink(receiveCompletion: { _ in },
                                                               receiveValue: { (searchResults) in
                                                                GeniusSongTests.assert(searchResults)
                                                               })
        assertValidJson("web page", promise: client.webPage(id: 99))
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
