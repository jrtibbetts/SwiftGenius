//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import Combine
import XCTest

class MockGeniusTests: ClientTestBase {

    let client = MockGenius()
    let errorClient = MockGenius(useErrorMode: true)

    func testValidMode() {
        _ = assertValidJson("user response", publisher: client.account()).sink(receiveCompletion: { _ in },
                                                                               receiveValue: { (account) in
                                                                                GeniusAccountTests.assert(account)
                                                                               })
        _ = assertValidJson("annotation",
                            publisher: client.annotation(id: 99)).sink(receiveCompletion: { _ in },
                                                                       receiveValue: { (annotation) in
                                                                        GeniusAnnotationTests.assert(annotation)
                                                                       })
        _ = assertValidJson("artist",
                            publisher: client.artist(id: 99)).sink(receiveCompletion: { _ in },
                                                                   receiveValue: { (artist) in
                                                                    GeniusArtistTests.assert(artist)
                                                                   })
//        _ = assertValidJson("artist songs",
//                            publisher: client.songs(byArtistId : 99)).sink(receiveCompletion: { _ in },
//                                                                           receiveValue: { (songs) in
//                                                                            GeniusArtistSongsTests.assert(songs)
//                                                                           })
//        _ = assertValidJson("referents",
//                            publisher: client.referents(forSongId: 99)).sink(receiveCompletion: { _ in },
//                                                                             receiveValue: { (referents) in
//                                                                                GeniusReferentTests.assert(referents)
//                                                                             })
        assertValidJson("search results", publisher: client.search(terms: "foo")) // .sink(receiveCompletion: { _ in },
        //                                                                                         receiveValue: { (search) in
        //                                                                                            GeniusSearchTests.assert(search.highlights)
        //                                                                                         })
        _ = assertValidJson("song",
                            publisher: client.song(id: 99)).sink(receiveCompletion: { _ in },
                                                                 receiveValue: { (searchResults) in
                                                                    GeniusSongTests.assert(searchResults)
                                                                 })
//        assertValidJson("web page", publisher: client.webPage(id: 99))
    }

    func testErrorMode() {
        assertInvalidJson("user response",         publisher: errorClient.account())
        assertInvalidJson("annotation response",   publisher: errorClient.annotation(id: 99))
        assertInvalidJson("artist response",       publisher: errorClient.artist(id: 99))
//        assertInvalidJson("artist songs response", publisher: errorClient.songs(byArtistId: 99))
//        assertInvalidJson("referents response",    publisher: errorClient.referents(forSongId: 99))
        assertInvalidJson("search results",        publisher: errorClient.search(terms: "foo"))
        assertInvalidJson("song response",         publisher: errorClient.song(id: 99))
//        assertInvalidJson( "web page response",    publisher: errorClient.webPage(id: 99))
    }

    @discardableResult
    func assertValidJson<T: Codable>(_ description: String = "",
                                     file: StaticString = #file,
                                     line: UInt = #line,
                                     publisher: AnyPublisher<T, Error>) -> AnyPublisher<T, Error> {
        assert(validPublisher: publisher, description: description, file: file, line: line)

        return publisher
    }

    @discardableResult
    func assertInvalidJson<T: Codable>(_ description: String = "",
                                       file: StaticString = #file,
                                       line: UInt = #line,
                                       publisher: AnyPublisher<T, Error>) -> AnyPublisher<T, Error> {
        assert(failingPublisher: publisher, description: description, file: file, line: line)

        return publisher
    }

}
