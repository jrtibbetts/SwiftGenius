//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

import Combine
import UIKit

public class MockGenius: NSObject, Genius {

    let jsonDecoder: JSONDecoder
    let errorMode: Bool

    public init(useErrorMode errorMode: Bool = false) {
        self.errorMode = errorMode

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.jsonDecoder = decoder

        super.init()
    }

    public func account(responseFormats: [GeniusResponseFormat] = [.dom]) -> Future<GeniusAccount.Response, Error> {
        return apply(toJsonObjectIn: "get-account-200")
    }

    public func annotation(id: Int,
                           responseFormats: [GeniusResponseFormat] = [.dom]) -> Future<GeniusAnnotation.Response, Error> {
        return apply(toJsonObjectIn: "get-annotations-200")
    }

    public func artist(id: Int,
                       responseFormats: [GeniusResponseFormat] = [.dom]) -> Future<GeniusArtist.Response, Error> {
        return apply(toJsonObjectIn: "get-artists-200")
    }

    public func brokenRequest() -> Future<String, Error> {
        return apply(toJsonObjectIn: """
This file doesn't exist, so the promise returned by this function should be rejected.
""")
    }

    public func referents(forSongId id: Int,
                          responseFormats: [GeniusResponseFormat] = [.dom]) -> Future<GeniusReferent.Response, Error> {
        return apply(toJsonObjectIn: "get-referents-200")
    }

    public func search(terms: String,
                       responseFormats: [GeniusResponseFormat] = [.dom]) -> Future<GeniusSearch.Response, Error> {
        return apply(toJsonObjectIn: "get-search-200")
    }

    public func song(id: Int,
                     responseFormats: [GeniusResponseFormat] = [.dom]) -> Future<GeniusSong.Response, Error> {
        return apply(toJsonObjectIn: "get-songs-200")
    }

    public func songs(byArtistId artistId: Int,
                      sortOrder: GeniusSongSortOrder = .title,
                      resultsPerPage: Int = 20,
                      pageNumber: Int = 1,
                      responseFormats: [GeniusResponseFormat] = [.dom]) -> Future<GeniusArtistSongs.Response, Error> {
        return apply(toJsonObjectIn: "get-artist-songs-200")
    }

    public func webPage(id: Int,
                        responseFormats: [GeniusResponseFormat] = [.dom]) -> Future<GeniusWebPage.Response, Error> {
        return apply(toJsonObjectIn: "get-web-pages-200")
    }

    // Copied from JSONClient
    public func apply<T: Codable>(toJsonObjectIn fileName: String,
                                  error: Error? = nil) -> Future<T, Error> {
        return Future<T, Error> { [unowned self] (future) in
            if errorMode {
                future(.failure(NSError(domain: "MockGenius", code: 0, userInfo: nil)))
            } else {
                do {
                    let url = SwiftGenius.bundle.url(forResource: fileName, withExtension: "json")!
                    let data = try Data(contentsOf: url)
                    let obj: T = try jsonDecoder.decode(T.self, from: data)
                    future(.success(obj))
                } catch {
                    future(.failure(error))
                }
            }
        }
    }

}
