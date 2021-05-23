//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

@testable import SwiftGenius
import Combine
import XCTest

class GeniusClientTests: ClientTestBase {

    // MARK: - Properties

    let consumerKey = ProcessInfo.processInfo.environment["genius.client-id"]!
    let consumerSecret = ProcessInfo.processInfo.environment["genius.client-secret"]!
    let userAgent = "test agent"
    let callbackUrl = URL(string: ProcessInfo.processInfo.environment["genius.client-callback-url"]!)!
    lazy var genius: GeniusClient = {
        return GeniusClient(clientId: consumerKey,
                            clientSecret: consumerSecret,
                            callbackUrl: callbackUrl)
    }()

    override func setUpWithError() throws {
        genius.oAuthToken = "some fake token"
    }

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

    // MARK: - Utility functions

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
        let tokenObject: GeniusClient.TokenResponse = try GeniusClient.jsonDecoder.decode(GeniusClient.TokenResponse.self, from: tokenData)
        XCTAssertEqual(tokenObject.accessToken, "foo")
        XCTAssertEqual(tokenObject.tokenType, "bearer")
    }

}
