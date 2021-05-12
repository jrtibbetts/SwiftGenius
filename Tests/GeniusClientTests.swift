//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import Combine
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

/*
    func testAccountOk() {
        let authorizeExp = expectation(description: "Authenticating")

        genius.authorize()
        wait(for: [authorizeExp], timeout: 10.0)

        let accountExp = expectation(description: "Getting user account")

        let subscriber = genius.account().sink(receiveCompletion: { (completion) in
            switch completion {
            case .failure(let error):
                XCTFail("GeniusClient.account() finished with an error: \(error.localizedDescription)")
            default:
                return
            }
        }, receiveValue: { (responseBlock) in
            XCTAssertEqual(responseBlock.response?.user.email, "jason@tibbetts.net")
            accountExp.fulfill()
        })

        wait(for: [accountExp], timeout: 10.0)
    }
 */

    func testAnnotationWithValidIdReturnsValidAnnotationPromise() {
        assert(invalidFuture: genius.annotation(id: 99), description: "annotation 99")
    }

    func testArtistIsUnimplemented() {
        assert(invalidFuture: genius.artist(id: 99))
    }

    func testReferentsIsUnimplemented() {
        assert(invalidFuture: genius.referents(forSongId: 99))
    }

    func testSearchIsUnimplemented() {
        assert(invalidFuture: genius.search(terms: "foo", responseFormats: [.dom]))
    }

    func testSongIsUnimplemented() {
        assert(invalidFuture: genius.song(id: 99))
    }

    func testSongsByArtistIsUnimplemented() {
        assert(invalidFuture: genius.songs(byArtistId: 99, sortOrder: .popularity, resultsPerPage: 100, pageNumber: 50))
    }

    // MARK: - Utility functions

    func assertPromiseWasRejected<T>(promise: Future<T, Error>) {
        assert(invalidFuture: promise)
    }

}
