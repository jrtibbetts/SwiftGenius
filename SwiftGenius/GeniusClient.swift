//  Copyright © 2017 Jason R Tibbetts. All rights reserved.

import JSONClient
import OAuthSwift
import PromiseKit

open class GeniusClient: AuthorizedJSONClient, Genius {

    public enum GeniusError: Error {
        case unimplemented(functionName: String)
    }

    public enum Scope: String {
        case me
        case createAnnotation = "create_annotation"
        case manageAnnotation = "manage_annotation"
        case vote
    }

    // MARK: - Public Properties

    public let callbackUrl: URL

    public var scopeString: String {
        return scope.map { $0.rawValue }.joined(separator: " ")
    }

    // MARK: - Other Properties

    private let oAuth: OAuth2Swift

    private var oAuthToken: String?

    private var presentingViewController: UIViewController?

    private var scope: [Scope]

    private var userAgent: String

    // MARK: - Initializers

    public init(consumerKey: String,
                consumerSecret: String,
                userAgent: String,
                callbackUrl: URL,
                scope: [Scope] = [.me]) {
        self.callbackUrl = callbackUrl
        self.scope = scope
        self.userAgent = "Immediate (https://github.com/jrtibbetts/SwiftGenius)"
        let geniusBaseUrl = URL(string: "https://api.genius.com/")!
        let authUrl = URL(string: "/oauth/authorize", relativeTo: geniusBaseUrl)!
        oAuth = OAuth2Swift(consumerKey: consumerKey,
                            consumerSecret: consumerSecret,
                            authorizeUrl: authUrl.absoluteString,
                            responseType: "code")
        super.init(oAuth: oAuth, authorizeUrl: authUrl.absoluteString, baseUrl: geniusBaseUrl)
    }

    open func authorize(presentingViewController: UIViewController) -> Promise<String> {
        self.presentingViewController = presentingViewController

        return authorize()
    }

    open func authorize() -> Promise<String> {
        return Promise<String> { (seal) in
            oAuth.authorizeURLHandler = SafariURLHandler(viewController: presentingViewController!, oauthSwift: oAuth)
            _ = oAuth.authorize(
                withCallbackURL: URL(string: "immediate://oauth-callback/genius")!,
                scope: scopeString, state: "code",
                success: { [weak self] (credential, _, _) in
                    self?.oAuthToken = credential.oauthToken
                    print(credential.oauthToken)
                    seal.fulfill(credential.oauthToken)
                }, failure: { error in
                    seal.reject(error)
            })
        }
    }

    public func account(responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusAccount.Response> {
        return unimplemented(functionName: "account")
    }

    public func annotation(id: Int,
                           responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusAnnotation.Response> {
//        return get(path: "/annotations/\(id)")
        return unimplemented(functionName: "annotation")
    }

    public func artist(id: Int,
                       responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusArtist.Response> {
        return unimplemented(functionName: "artist")
    }

    public func referents(forSongId id: Int,
                          responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusReferent.Response> {
        return unimplemented(functionName: "referents")
    }

    public func search(terms: String,
                       responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusSearch.Response> {
        return unimplemented(functionName: "search")
    }

    public func song(id: Int,
                     responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusSong.Response> {
        return unimplemented(functionName: "song")
    }

    private func unimplemented<T>(functionName: String) -> Promise<T> {
        return Promise<T> { (seal) in
            seal.reject(GeniusError.unimplemented(functionName: functionName))
        }
    }

    public func songs(byArtistId artistId: Int,
                      sortOrder: GeniusSongSortOrder,
                      resultsPerPage: Int,
                      pageNumber: Int,
                      responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusArtistSongs.Response> {
        return unimplemented(functionName: "account")
    }

}
