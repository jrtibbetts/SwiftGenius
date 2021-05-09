//  Copyright © 2017 Jason R Tibbetts. All rights reserved.

import Foundation
import OAuthSwift
import PromiseKit
import UIKit

open class GeniusClient: NSObject, Genius {

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

    public var scopeString: String {
        return scope.map { $0.rawValue }.joined(separator: " ")
    }

    // MARK: - Other Properties

    private let oAuth: OAuth2Swift

    private var oAuthToken: String?

    private let baseUrl = URL(string: "https://api.genius.com")!

    private var presentingViewController: UIViewController?

    private var scope: [Scope]

    // MARK: - Initializers

    public init(consumerKey: String,
                consumerSecret: String,
                scope: [Scope] = [.me]) {
        self.scope = scope
        let authUrl = URL(string: "https://api.genius.com/oauth/authorize")!
        oAuth = OAuth2Swift(consumerKey: consumerKey,
                            consumerSecret: consumerSecret,
                            authorizeUrl: authUrl.absoluteString,
                            responseType: "token")
        super.init()
    }

    open func authorize(presentingViewController: UIViewController) -> Promise<String> {
        self.presentingViewController = presentingViewController

        return authorize()
    }

    open func authorize() -> Promise<String> {
        return Promise<String> { [weak self] (seal) in
            oAuth.authorizeURLHandler = SafariURLHandler(viewController: presentingViewController!, oauthSwift: oAuth)
            _ = oAuth.authorize(
                withCallbackURL: URL(string: "swiftgenius://oauth-callback/genius")!,
                scope: scopeString, state: "code") { (result) in
                switch result {
                case .success(let (credential, _, _)):
                    self?.oAuthToken = credential.oauthToken
                    print(credential.oauthToken)
                    seal.fulfill(credential.oauthToken)
                case .failure(let error):
                    seal.reject(error)
                }
            }
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
