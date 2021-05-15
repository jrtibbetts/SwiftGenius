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
        return GeniusClient(clientId: consumerKey,
                            clientSecret: consumerSecret,
                            callbackUrl: URL(string: "genius-client-test")!)
    }()

    // MARK: - Test functions

    func testConstructorWithExplicitScopeOk() {
        let scope: [GeniusClient.Scope] = [.me, .manageAnnotation]
        let explicitScopeGenius = GeniusClient(clientId: consumerKey,
                                               clientSecret: consumerSecret,
                                               callbackUrl: URL(string: "genius-client-test")!,
                                               scope: scope)
        XCTAssertEqual(explicitScopeGenius.scopeString, "me manage_annotation")
        XCTAssertEqual(explicitScopeGenius.callbackUrl, URL(string: "genius-client-test")!)
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

    func testRetrieveAccessToken() throws {
        let clientId = "foo"
        let clientSecret = "bar"
        let callbackUrl = URL(string: "https://thankyouforhearingme.com")!
        let client = GeniusClient(clientId: clientId, clientSecret: clientSecret, callbackUrl: callbackUrl)
        let responseUrl = SwiftGeniusTests.resourceBundle.url(forResource: "TokenResponse", withExtension: "json")!
        let responseUrlWithQuery = URL(string: responseUrl.absoluteString + "?code=this_is_a_code")!
        let request = client.accessTokenRequest(from: responseUrlWithQuery)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/x-www-form-urlencoded")
        XCTAssertEqual(request.httpMethod, "POST")
        let requestBody = String(data: request.httpBody!, encoding: .utf8)!
        XCTAssertTrue(requestBody.contains("code=this_is_a_code"))
        XCTAssertTrue(requestBody.contains("client_id=foo"))
        XCTAssertTrue(requestBody.contains("client_secret=bar"))
        XCTAssertTrue(requestBody.contains("redirect_uri=https://thankyouforhearingme.com"))
        XCTAssertTrue(requestBody.contains("response_type=code"))
        XCTAssertTrue(requestBody.contains("grant_type=authorization_code"))
   }

    func testTokenResponseDecoding() throws {
        let tokenData = "{\"access_token\":\"foo\",\"token_type\":\"bearer\"}".data(using: .utf8)!
        let tokenObject: GeniusClient.TokenResponse = try GeniusClient.TokenResponse.decoder.decode(GeniusClient.TokenResponse.self, from: tokenData)
        XCTAssertEqual(tokenObject.accessToken, "foo")
        XCTAssertEqual(tokenObject.tokenType, "bearer")
    }

}
