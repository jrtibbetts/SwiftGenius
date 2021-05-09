//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import PromiseKit
import XCTest

class GeniusClientTests: ClientTestBase {

    // MARK: - Properties

    let consumerKey = ProcessInfo.processInfo.environment["genius.client-id"] ?? "1234567890"
    let consumerSecret = ProcessInfo.processInfo.environment["genius.client-secret"] ?? "abcdefghijklm`"
    let userAgent = "test agent"
    let callbackUrl = URL(string: "https://www.apple.com")!
    lazy var genius: GeniusClient = {
        return GeniusClient(consumerKey: consumerKey,
                            consumerSecret: consumerSecret,
                            callbackScheme: "genius-client-test")
    }()

    // MARK: - Test functions

    func testConstructorWithExplicitScopeOk() {
        let scope: [GeniusClient.Scope] = [.me, .manageAnnotation]
        let explicitScopeGenius = GeniusClient(consumerKey: consumerKey,
                                               consumerSecret: consumerSecret,
                                               callbackScheme: "genius-client-test",
                                               scope: scope)
        XCTAssertEqual(explicitScopeGenius.scopeString, "me manage_annotation")
        XCTAssertEqual(explicitScopeGenius.callbackScheme, "genius-client-test")
    }

    func testConstructorWithDefaultScopeHasJustMeScope() {
        XCTAssertEqual(genius.scopeString, "me")
    }

//    func testAccountIsUnimplemented() {
//        assert(invalidPromise: genius.account())
//    }

    func testAnnotationWithValidIdReturnsValidAnnotationPromise() {
        assert(invalidPromise: genius.annotation(id: 99), description: "annotation 99")
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
