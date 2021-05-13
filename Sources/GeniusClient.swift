//  Copyright © 2017 Jason R Tibbetts. All rights reserved.

import AuthenticationServices
import Combine
import Foundation

open class GeniusClient: NSObject, ObservableObject {

    public enum GeniusError: Error {
        case unimplemented(functionName: String)
    }

    public enum Scope: String {
        case me
        case createAnnotation = "create_annotation"
        case manageAnnotation = "manage_annotation"
        case vote
    }

    // MARK: - Published Properties

    @Published private var oAuthToken: String?

    // MARK: - Public Properties

    public var callbackUrl: URL

    public var scopeString: String {
        return scope.map { $0.rawValue }.joined(separator: " ")
    }

    // MARK: - Other Properties

    private var baseUrl = URL(string: "https://api.genius.com/")!

    private var clientId: String

    private var clientSecret: String

    private var dateFormatter = ISO8601DateFormatter()

    private var state: String

    private var scope: [Scope]

    // MARK: - Initializers

    public init(clientId: String,
                clientSecret: String,
                callbackUrl: URL,
                scope: [Scope] = [.me]) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.callbackUrl = callbackUrl
        self.scope = scope
        self.state = "Genius " + dateFormatter.string(from: Date())

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        super.init()
    }

    private var logInSubscription: AnyCancellable?

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
            session.prefersEphemeralWebBrowserSession = true
            session.start()
        }

        logInSubscription = logInFuture.sink(receiveCompletion: { (completion) in
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

    open func retrieveAccessToken(from url: URL) {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        let queryItems = components.query!
            .split(separator: "&")
            .reduce(into: [String: String]()) { (dictionary, queryItem) in
                let itemElements = queryItem.split(separator: "=")
                dictionary[String(itemElements[0])] = String(itemElements[1])
            }
        let tokenBody = TokenRequestBody(code: queryItems["code"]!,
                                  clientSecret: clientSecret,
                                  clientId: clientId,
                                  redirectUri: callbackUrl.absoluteString)
        let endpoint = URL(string: "/oauth/token", relativeTo: baseUrl)!
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.httpBody = try? TokenRequestBody.encoder.encode(tokenBody)
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            if let data = data {
                let tokenResponse = try? TokenResponseBody.decoder.decode(TokenResponseBody.self, from: data)
                self?.oAuthToken = tokenResponse?.accessToken
            }
        }
    }

    struct TokenRequestBody: Codable {

        static var encoder: JSONEncoder = {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase

            return encoder
        }()

        enum CodingKeys: String, CodingKey {
            case code
            case clientSecret
            case clientId
            case redirectUri
        }

        var code: String
        var clientSecret: String
        let grantType = "authorization_code"
        var clientId: String
        var redirectUri: String
        let responseType = "code"
    }

    struct TokenResponseBody: Codable {

        static var decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            return decoder
        }()

        var accessToken: String

    }

    public func account(responseFormats: [GeniusResponseFormat] = [.dom]) -> Future<GeniusAccount.Response, Error> {
        return Future<GeniusAccount.Response, Error> { [weak self] (future) in
            guard let oAuthToken = self?.oAuthToken else {
                future(.failure(NSError(domain: "GeniusClient", code: 0, userInfo: nil)))

                return
            }

            let url = URL(string: "/annotations/10225840", relativeTo: self?.baseUrl)!
            var request = URLRequest(url: url)
            request.addValue("Bearer \(oAuthToken)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    future(.failure(error))
                } else if let data = data {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let jsonResponse: GeniusAccount.Response = try GeniusAccount.Response.decode(fromJSONData: data, withDecoder: decoder)
                        future(.success(jsonResponse))
                    } catch {
                        future(.failure(error))
                    }
                }
            }.resume()
        }
    }

}

extension GeniusClient: ASWebAuthenticationPresentationContextProviding {

    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }

}

extension GeniusClient: Genius {

    public func annotation(id: Int,
                           responseFormats: [GeniusResponseFormat] = [.dom]) -> Future<GeniusAnnotation.Response, Error> {
//        return get(path: "/annotations/\(id)")
        return unimplemented(functionName: "annotation")
    }

    public func artist(id: Int,
                       responseFormats: [GeniusResponseFormat] = [.dom]) -> Future<GeniusArtist.Response, Error> {
        return unimplemented(functionName: "artist")
    }

    public func referents(forSongId id: Int,
                          responseFormats: [GeniusResponseFormat] = [.dom]) -> Future<GeniusReferent.Response, Error> {
        return unimplemented(functionName: "referents")
    }

    public func search(terms: String,
                       responseFormats: [GeniusResponseFormat] = [.dom]) -> Future<GeniusSearch.Response, Error> {
        return unimplemented(functionName: "search")
    }

    public func song(id: Int,
                     responseFormats: [GeniusResponseFormat] = [.dom]) -> Future<GeniusSong.Response, Error> {
        return unimplemented(functionName: "song")
    }

    private func unimplemented<T>(functionName: String) -> Future<T, Error> {
        return Future<T, Error> { (future) in
            future(.failure(GeniusError.unimplemented(functionName: functionName)))
        }
    }

    public func songs(byArtistId artistId: Int,
                      sortOrder: GeniusSongSortOrder,
                      resultsPerPage: Int,
                      pageNumber: Int,
                      responseFormats: [GeniusResponseFormat] = [.dom]) -> Future<GeniusArtistSongs.Response, Error> {
        return unimplemented(functionName: "account")
    }

}
