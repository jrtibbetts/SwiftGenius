//  Copyright © 2017 Jason R Tibbetts. All rights reserved.

import AuthenticationServices
import Foundation

public class GeniusClient: BaseGeniusClient, Genius {

    public enum Scope: String {
        case me
        case createAnnotation = "create_annotation"
        case manageAnnotation = "manage_annotation"
        case vote
    }

    // MARK: - Published Properties

    @Published var oAuthToken: String? {
        didSet {
            (requestBuilder as? GeniusRequestBuilder)?.oAuthToken = oAuthToken
        }
    }

    @Published public var error: Error?

    // MARK: - Public Properties

    public var redirectUrl: URL

    public var isAuthenticated: Bool {
        return oAuthToken != nil
    }

    public var scopeString: String {
        return scope.map { $0.rawValue }.joined(separator: " ")
    }

    /// Identifies the calling app in each request's `User-Agent` request
    /// header.
    public var userAgent: String

    // MARK: - Other Properties

    internal var baseUrl = URL(string: "https://api.genius.com/")!

    private var clientId: String

    private var clientSecret: String

    private var dateFormatter = ISO8601DateFormatter()

    private var state: String

    private var scope: [Scope]

    // MARK: - Initializers

    public init(clientId: String,
                clientSecret: String,
                redirectUrl: URL,
                userAgent: String = "SwiftGenius/1.0",
                scope: [Scope] = [.me]) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.redirectUrl = redirectUrl
        self.userAgent = userAgent
        self.scope = scope
        self.state = "Genius " + dateFormatter.string(from: Date())
        super.init(requestBuilder: GeniusRequestBuilder(baseUrl: baseUrl, userAgent: userAgent))
    }

    func callbackUrl(for authUrl: URL,
                     callbackURLScheme scheme: String) async throws -> URL {
        return try await withCheckedThrowingContinuation { (continuation) in
            let session = ASWebAuthenticationSession(url: authUrl,
                                                     callbackURLScheme: scheme) { (callbackUrl, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let url = callbackUrl {
                    continuation.resume(returning: url)
                }
            }

            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = false
            session.start()
        }
    }

    open func authorize() async throws -> String {
        let endpoint = URL(string: "/oauth/authorize", relativeTo: baseUrl)!
        var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            "client_id": clientId,
            "redirect_uri": redirectUrl.absoluteString,
            "scope": scope.map { $0.rawValue }.joined(separator: " "),
            "state": state,
            "response_type": "code"
        ].map { URLQueryItem(name: $0, value: $1) }

        let authUrl = components.url!
        let callbackScheme = redirectUrl.scheme!
        let url = try await callbackUrl(for: authUrl, callbackURLScheme: callbackScheme)
        let token = try await retrieveAccessToken(from: url)

        return token
    }

    open func logOut() {
        oAuthToken = nil
    }

    open func retrieveAccessToken(from url: URL) async throws -> String {
        let request = accessTokenRequest(from: url)

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode != 200 {
            print("HTTP error response: ", String(data: data, encoding: .utf8)!)
            throw NSError(domain: "GeniusClient", code: httpResponse.statusCode, userInfo: nil)
        } else {
            let tokenResponse: TokenResponse = try Self.jsonDecoder.decode(TokenResponse.self, from: data)

            return tokenResponse.accessToken
        }
    }

    func accessTokenRequest(from url: URL) -> URLRequest {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        let queryItems = components.query!
            .split(separator: "&")
            .reduce(into: [String: String]()) { (dictionary, queryItem) in
                let itemElements = queryItem.split(separator: "=")
                dictionary[String(itemElements[0])] = String(itemElements[1])
            }
        let tokenBody = TokenRequestBody(code: queryItems["code"]!,
                                         clientId: clientId,
                                         clientSecret: clientSecret,
                                         redirectUri: redirectUrl.absoluteString)

        let endpoint = URL(string: "/oauth/token", relativeTo: baseUrl)!
        var request = URLRequest(url: endpoint)
        request.addValue(userAgent, forHTTPHeaderField: "User-Agent")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = tokenBody.wwwFormUrlEncodedData

        return request
    }

    struct TokenRequestBody: Codable {

        static var encoder: JSONEncoder = {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase

            return encoder
        }()

        var code: String
        var clientId: String
        var clientSecret: String
        var redirectUri: String

        var wwwFormUrlEncodedData: Data? {
            return [
                "code": code,
                "client_id": clientId,
                "client_secret": clientSecret,
                "redirect_uri": redirectUri,
                "response_type": "code",
                "grant_type": "authorization_code"
            ]
            .map { "\($0)=\($1)" }
            .joined(separator: "&")
            .data(using: .utf8)
        }
    }

    struct TokenResponse: Codable {

        var accessToken: String
        var tokenType: String

    }

    private class GeniusRequestBuilder: RequestBuilder {

        var baseUrl: URL!

        var oAuthToken: String?

        /// Identifies the calling app in each request's `User-Agent` request
        /// header.
        var userAgent: String

        init(baseUrl: URL, userAgent: String) {
            self.baseUrl = baseUrl
            self.userAgent = userAgent
        }

        func accountRequest() -> URLRequest? {
            return geniusGetRequest(path: "/account")
        }

        func annotationRequest(id: Int) -> URLRequest? {
            return geniusGetRequest(path: "/annotations/\(id)")
        }

        func artistRequest(id: Int) -> URLRequest? {
            return geniusGetRequest(path: "/artists/\(id)")
        }

        func referentsRequest(songId: Int) -> URLRequest? {
            return geniusGetRequest(path: "/referents?song_id=\(songId)")
        }

        func searchRequest(terms: String) -> URLRequest? {
            guard var urlComponents = URLComponents(string: "/search") else {
                return nil
            }

            urlComponents.queryItems = [URLQueryItem(name: "q", value: terms)]

            guard let url = urlComponents.url else {
                return nil
            }

            return geniusGetRequest(path: url.absoluteString)
        }

        func songRequest(id: Int) -> URLRequest? {
            return geniusGetRequest(path: "/songs/\(id)")
        }

        func webPageRequest(urlString: String) -> URLRequest? {
            return geniusGetRequest(path: "/webpages/lookup?raw_annotatable_url=\(urlString)")
        }

        private func geniusGetRequest(path: String) -> URLRequest? {
            guard let endpoint = URL(string: path, relativeTo: baseUrl),
                  let oAuthToken = oAuthToken else {
                return nil
            }

            var request = URLRequest(url: endpoint)
            request.addValue(userAgent, forHTTPHeaderField: "User-Agent")
            request.addValue("text/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(oAuthToken)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"

            return request
        }

    }

}

extension GeniusClient: ASWebAuthenticationPresentationContextProviding {

    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }

}
