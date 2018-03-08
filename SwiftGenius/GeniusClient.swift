//  Copyright © 2017 Jason R Tibbetts. All rights reserved.

import JSONClient
import OAuthSwift
import PromiseKit

open class GeniusClient: AuthenticatedJSONClient, Genius {

    public enum GeniusError: Error {
        case Unimplemented(functionName: String)
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

    fileprivate let oAuth: OAuth2Swift

    fileprivate var oAuthToken: String?

    fileprivate var presentingViewController: UIViewController?

    fileprivate var scope: [Scope]

    fileprivate var userAgent: String

    // MARK: - Initializers

    public init(consumerKey: String,
                consumerSecret: String,
                userAgent: String,
                callbackUrl: URL,
                scope: [Scope] = [.me]) {
        self.callbackUrl = callbackUrl
        self.scope = scope
        self.userAgent = "Immediate (https://github.com/jrtibbetts/Immediate)"
        let geniusBaseUrl = URL(string: "https://api.genius.com/")!
        let authUrl = URL(string: "/oauth/authorize", relativeTo: geniusBaseUrl)!
        oAuth = OAuth2Swift(consumerKey: consumerKey,
                            consumerSecret: consumerSecret,
                            authorizeUrl: authUrl.absoluteString,
                            responseType: "code")
        super.init(baseUrl: geniusBaseUrl)
    }

    open func authorize(presentingViewController: UIViewController) -> Promise<String> {
        self.presentingViewController = presentingViewController

        return authorize()
    }

    open func authorize() -> Promise<String> {
        return Promise<String> { (success, failure) in
            oAuth.authorizeURLHandler = SafariURLHandler(viewController: presentingViewController!, oauthSwift: oAuth)
            _ = oAuth.authorize(
                withCallbackURL: URL(string: "immediate://oauth-callback/genius")!,
                scope: scopeString, state: "code",
                success: { [weak self] credential, response, parameters in
                    self?.oAuthToken = credential.oauthToken
                    print(credential.oauthToken)
                    success(credential.oauthToken)
                }, failure: { error in
                    failure(error)
            })
        }
    }

    public func account(responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusAccount.Response> {
        return Promise<GeniusAccount.Response>() { (fulfill, reject) in
            reject(GeniusError.Unimplemented(functionName: "account"))
        }
    }

    public func annotation(id: Int,
                           responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusAnnotation.Response> {
//        return get(path: "/annotations/\(id)")
        return Promise<GeniusAnnotation.Response>() { (fulfill, reject) in
            reject(GeniusError.Unimplemented(functionName: "account"))
        }
    }

    public func artist(id: Int,
                       responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusArtist.Response> {
        return Promise<GeniusArtist.Response>() { (fulfill, reject) in
            reject(GeniusError.Unimplemented(functionName: "account"))
        }
    }

    public func referents(forSongId id: Int,
                          responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusReferent.Response> {
        return Promise<GeniusReferent.Response>() { (fulfill, reject) in
            reject(GeniusError.Unimplemented(functionName: "account"))
        }
    }

    public func search(terms: String,
                       responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusSearch.Response> {
        return Promise<GeniusSearch.Response>() { (fulfill, reject) in
            reject(GeniusError.Unimplemented(functionName: "account"))
        }
    }

    public func song(id: Int,
                     responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusSong.Response> {
        return Promise<GeniusSong.Response>() { (fulfill, reject) in
            reject(GeniusError.Unimplemented(functionName: "account"))
        }
    }

    public func songs(byArtistId artistId: Int,
                      sortOrder: GeniusSongSortOrder,
                      resultsPerPage: Int,
                      pageNumber: Int,
                      responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusArtistSongs.Response> {
        return Promise<GeniusArtistSongs.Response>() { (fulfill, reject) in
            reject(GeniusError.Unimplemented(functionName: "account"))
        }
    }

}

