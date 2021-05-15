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

    public func account() -> Future<GeniusAccount.Response, Error> {
        return apply(toJsonObjectIn: "get-account-200")
    }

    public func annotation(id: Int) -> Future<GeniusAnnotation.Response, Error> {
        return apply(toJsonObjectIn: "get-annotations-200")
    }

    public func artist(id: Int) -> Future<GeniusArtist.Response, Error> {
        return apply(toJsonObjectIn: "get-artists-200")
    }

    public func brokenRequest() -> Future<String, Error> {
        return apply(toJsonObjectIn: """
This file doesn't exist, so the promise returned by this function should be rejected.
""")
    }

    public func referents(forSongId id: Int) -> Future<GeniusReferent.Response, Error> {
        return apply(toJsonObjectIn: "get-referents-200")
    }

    public func search(terms: String) -> Future<GeniusSearch.Response, Error> {
        return apply(toJsonObjectIn: "get-search-200")
    }

    public func song(id: Int) -> Future<GeniusSong.Response, Error> {
        return apply(toJsonObjectIn: "get-songs-200")
    }

    public func songs(byArtistId artistId: Int,
                      sortOrder: GeniusSongSortOrder = .title,
                      resultsPerPage: Int = 20,
                      pageNumber: Int = 1) -> Future<GeniusArtistSongs.Response, Error> {
        return apply(toJsonObjectIn: "get-artist-songs-200")
    }

    public func webPage(id: Int) -> Future<GeniusWebPage.Response, Error> {
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
