//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

import Combine
import UIKit

public class MockGenius: NSObject, Genius {

    let jsonDecoder: JSONDecoder
    let errorMode: Bool
    let errorModeError = NSError(domain: "MockGenius", code: 9, userInfo: nil)

    public init(useErrorMode errorMode: Bool = false) {
        self.errorMode = errorMode

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.jsonDecoder = decoder

        super.init()
    struct MockRequestBuilder: RequestBuilder {

        let errorMode: Bool

        func buildRequest(path: String) -> URLRequest {
            if errorMode {
                return URLRequest(url: URL(string: "/broken")!)
            } else {
                let url = SwiftGenius.resourceBundle.url(forResource: path, withExtension: "json")!

                return URLRequest(url: url)
            }
        }

        func accountRequest() -> URLRequest {
            return buildRequest(path: "get-account-200")
        }

        func annotationRequest(id: Int) -> URLRequest {
            return buildRequest(path: "get-annotation-200")
        }

        func artistRequest(id: Int) -> URLRequest {
            return buildRequest(path: "get-artist-200")
        }

        func referentRequest(id: Int) -> URLRequest {
            return buildRequest(path: "get-referents-200")
        }

        func searchRequest(terms: String) -> URLRequest {
            return buildRequest(path: "get-search-200")
        }

        func songRequest(id: Int) -> URLRequest {
            return buildRequest(path: "get-song-200")
        }

    }

    public func account() -> Future<GeniusAccount, Error> {
        return Future<GeniusAccount, Error> { [unowned self] (future) in
            let responseFuture: Future<GeniusAccount.Response, Error> = self.apply(toJsonObjectIn: "get-account-200")
            _ = responseFuture.sink { (completion) in
                future(.failure(errorModeError))
            } receiveValue: { (response) in
                future(.success(response.response!.user))
            }
        }
    }

    public func annotation(id: Int) -> Future<GeniusAnnotation, Error> {
        return Future<GeniusAnnotation, Error> { [unowned self] (future) in
            let responseFuture: Future<GeniusAnnotation.Response, Error> = self.apply(toJsonObjectIn: "get-annotations-200")
            _ = responseFuture.sink { (completion) in
                future(.failure(errorModeError))
            } receiveValue: { (response) in
                future(.success(response.response!.annotation))
            }
        }
    }

    public func artist(id: Int) -> Future<GeniusArtist, Error> {
        return Future<GeniusArtist, Error> { [unowned self] (future) in
            let responseFuture: Future<GeniusArtist.Response, Error> = self.apply(toJsonObjectIn: "get-artists-200")
            _ = responseFuture.sink { (completion) in
                future(.failure(errorModeError))
            } receiveValue: { (response) in
                future(.success(response.response!.artist))
            }
        }
    }

    public func brokenRequest() -> Future<String, Error> {
        return apply(toJsonObjectIn: """
This file doesn't exist, so the promise returned by this function should be rejected.
""")
    }

    public func referents(forSongId id: Int) -> Future<[GeniusReferent], Error> {
        return Future<[GeniusReferent], Error> { [unowned self] (future) in
            let responseFuture: Future<GeniusReferent.Response, Error> = self.apply(toJsonObjectIn: "get-referents-200")
            _ = responseFuture.sink { (completion) in
                future(.failure(errorModeError))
            } receiveValue: { (response) in
                future(.success(response.response!.referents))
            }
        }
    }

    public func search(terms: String) -> Future<GeniusSearch, Error> {
        return Future<GeniusSearch, Error> { [unowned self] (future) in
            let responseFuture: Future<GeniusSearch.Response, Error> = self.apply(toJsonObjectIn: "get-search-200")
            _ = responseFuture.sink { (completion) in
                future(.failure(errorModeError))
            } receiveValue: { (response) in
                future(.success(response.response!.hits.first!))
            }
        }
    }

    public func song(id: Int) -> Future<GeniusSong, Error> {
        return Future<GeniusSong, Error> { [unowned self] (future) in
            let responseFuture: Future<GeniusSong.Response, Error> = self.apply(toJsonObjectIn: "get-songs-200")
            _ = responseFuture.sink { (completion) in
                future(.failure(errorModeError))
            } receiveValue: { (response) in
                future(.success(response.response!.song))
            }
        }
    }

    public func songs(byArtistId artistId: Int,
                      sortOrder: GeniusSongSortOrder = .title,
                      resultsPerPage: Int = 20,
                      pageNumber: Int = 1) -> Future<[GeniusSong], Error> {
        return Future<[GeniusSong], Error> { [unowned self] (future) in
            let responseFuture: Future<GeniusArtistSongs.Response, Error> = self.apply(toJsonObjectIn: "get-artist-songs-200")
            _ = responseFuture.sink { (completion) in
                future(.failure(errorModeError))
            } receiveValue: { (response) in
                future(.success(response.response!.songs!))
            }
        }
    }

    public func webPage(id: Int) -> Future<GeniusWebPage, Error> {
        return Future<GeniusWebPage, Error> { [unowned self] (future) in
            let responseFuture: Future<GeniusWebPage.Response, Error> = self.apply(toJsonObjectIn: "get-web-pages-200")
            _ = responseFuture.sink { (completion) in
                future(.failure(errorModeError))
            } receiveValue: { (response) in
                future(.success(response.response!.webPage))
            }
        }
    }

    // Copied from JSONClient
    public func apply<T: Codable>(toJsonObjectIn fileName: String,
                                  error: Error? = nil) -> Future<T, Error> {
        return Future<T, Error> { [unowned self] (future) in
            if errorMode {
                future(.failure(NSError(domain: "MockGenius", code: 0, userInfo: nil)))
            } else {
                do {
                    if let url = SwiftGenius.resourceBundle.url(forResource: fileName, withExtension: "json") {
                        let data = try Data(contentsOf: url)
                        let obj: T = try jsonDecoder.decode(T.self, from: data)
                        future(.success(obj))
                    } else {
                        future(.failure(NSError(domain: "MockGenius", code: 1, userInfo: nil)))
                    }
                } catch {
                    future(.failure(error))
                }
            }
        }
    }

}
