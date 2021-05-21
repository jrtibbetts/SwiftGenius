//  Copyright © 2017 Jason R Tibbetts. All rights reserved.

import AuthenticationServices
import Combine
import Foundation

open class GeniusClient: Genius, ObservableObject {

    public enum Scope: String {
        case me
        case createAnnotation = "create_annotation"
        case manageAnnotation = "manage_annotation"
        case vote
    }

    // MARK: - Published Properties

    @Published private var oAuthToken: String?

    @Published public var geniusAccount: GeniusAccount?

    @Published public var error: Error?

    // MARK: - Public Properties

    public var callbackUrl: URL

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
                callbackUrl: URL,
                userAgent: String = "SwiftGenius/1.0",
                scope: [Scope] = [.me]) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.callbackUrl = callbackUrl
        self.userAgent = userAgent
        self.scope = scope
        self.state = "Genius " + dateFormatter.string(from: Date())
        self.requestBuilder = GeniusReleaseBuilder(baseUrl: baseUrl, oAuthToken: nil, userAgent: userAgent)
        super.init(requestBuilder: requestBuilder)
    }

    private var requestBuilder: GeniusReleaseBuilder

    private var currentOperation: AnyCancellable? {
        didSet {
            oldValue?.cancel()
        }
    }

    open func authorize() {
        let endpoint = URL(string: "/oauth/authorize", relativeTo: baseUrl)!
        var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            "client_id": clientId,
            "redirect_uri": callbackUrl.absoluteString,
            "scope": scope.map { $0.rawValue }.joined(separator: " "),
            "state": state,
            "response_type": "code"
        ].map { URLQueryItem(name: $0, value: $1) }

        let authUrl = components.url!
        let callbackScheme = callbackUrl.scheme
        let logInFuture = Future<URL, Error> { [weak self] (completion) in
            let session = ASWebAuthenticationSession(url: authUrl,
                                                     callbackURLScheme: callbackScheme) { (callbackUrl, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let url = callbackUrl {
                    completion(.success(url))
                }
            }

            session.presentationContextProvider = self
            session.prefersEphemeralWebBrowserSession = false
            session.start()
        }

        currentOperation = logInFuture.sink(receiveCompletion: { (completion) in
            switch completion {
            case .failure(let error):
                print("Failed to receive a sign-in completion: ", error)
            default:
                break
            }
        }, receiveValue: { [weak self] (url) in
            self?.retrieveAccessToken(from: url)
        })
    }

    open func logOut() {
        oAuthToken = nil
    }

    open func retrieveAccessToken(from url: URL) {
        let request = accessTokenRequest(from: url)

        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error when requesting auth token: ", error)
                } else if let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode != 200 {
                    print("HTTP error response: ", String(data: data!, encoding: .utf8)!)
                } else if let data = data {
                    let tokenResponse: TokenResponse? = try? Self.jsonDecoder.decode(TokenResponse.self, from: data)
                    self?.oAuthToken = tokenResponse?.accessToken
                }
            }
        }.resume()
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
                                         redirectUri: callbackUrl.absoluteString)

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

//    public func fetchAccount() {
//        let request = geniusGetRequest(path: "/account/")!
//
//        currentOperation = URLSession.shared.dataTaskPublisher(for: request)
//            .map { $0.data }
//            .decode(type: GeniusAccount.Response.self, decoder: Self.jsonDecoder)
//            .map { $0.response!.user }
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//            .sink(receiveCompletion: { [weak self] (completion) in
//                switch completion {
//                case .failure(let error):
//                    self?.error = error
//                case .finished:
//                    return
//                }
//            }, receiveValue: { [weak self] (account) in
//                self?.geniusAccount = account
//            })
//    }

    private struct GeniusReleaseBuilder: RequestBuilder {

        var baseUrl: URL!

        var oAuthToken: String?

        /// Identifies the calling app in each request's `User-Agent` request
        /// header.
        var userAgent: String

        func accountRequest() -> URLRequest {
            return geniusGetRequest(path: "/account")!
        }

        func annotationRequest(id: Int) -> URLRequest {
            return geniusGetRequest(path: "/annotation/\(id)")!
        }

        func artistRequest(id: Int) -> URLRequest {
            return geniusGetRequest(path: "/artists/\(id)")!
        }

        func referentsRequest(id: Int) -> URLRequest {
            return geniusGetRequest(path: "/referents/\(id)")!
        }

        func searchRequest(terms: String) -> URLRequest {
            return geniusGetRequest(path: "/search/\(terms)")!
        }

        func songRequest(id: Int) -> URLRequest {
            return geniusGetRequest(path: "/song/\(id)")!
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
