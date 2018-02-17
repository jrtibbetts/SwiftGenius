//  Copyright © 2018 nrith. All rights reserved.

@testable import SwiftGenius
import PromiseKit
import XCTest

class GeniusClientTests: ClientTestBase {

    // MARK: - Properties

    let consumerKey = "1234567890"
    let consumerSecret = "abcdefghijklm"
    let userAgent = "test agent"
    let callbackUrl = URL(string: "https://www.apple.com")!
    var genius: GeniusClient {
        return GeniusClient(consumerKey: consumerKey,
                            consumerSecret: consumerSecret,
                            userAgent: userAgent,
                            callbackUrl: callbackUrl)
    }

    // MARK: - Test functions

    func testConstructorWithExplicitScopeOk() {
        let scope: [GeniusClient.Scope] = [.me, .manageAnnotation]
        let explicitScopeGenius = GeniusClient(consumerKey: consumerKey,
                                               consumerSecret: consumerSecret,
                                               userAgent: userAgent,
                                               callbackUrl: callbackUrl,
                                               scope: scope)
        XCTAssertEqual(explicitScopeGenius.scopeString, "me manage_annotation")
    }

    func testConstructorWithDefaultScopeHasJustMeScope() {
        XCTAssertEqual(genius.scopeString, "me")
    }

    func testConstructorSetsCallbackUrls() {
        XCTAssertEqual(genius.callbackUrl, callbackUrl)
    }

    func testAccountIsUnimplemented() {
        assert(invalidPromise: genius.account())
    }

    func testAnnotationIsUnimplemented() {
        assert(invalidPromise: genius.annotation(id: 99))
    }

    func testArtistIsUnimplemented() {
        assert(invalidPromise: genius.artist(id: 99))
    }

    func testReferentsIsUnimplemented() {
        assert(invalidPromise: genius.referents(forSongId: 99))
    }

    func testSearchIsUnimplemented() {
        assert(invalidPromise: genius.search(terms: "foo", responseFormats: [.dom]))
    }

    func testSongIsUnimplemented() {
        assert(invalidPromise: genius.song(id: 99))
    }

    func testSongsByArtistIsUnimplemented() {
        assert(invalidPromise: genius.songs(byArtistId: 99, sortOrder: .popularity, resultsPerPage: 100, pageNumber: 50))
    }

    // MARK: - Utility functions
    func assertPromiseWasRejected<T>(promise: Promise<T>) {
        assert(invalidPromise: promise)
    }

}
