//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

import JSONClient
import PromiseKit
import UIKit

public class MockGenius: MockClient, Genius {

    public init(useErrorMode errorMode: Bool = false) {
        let bundle = SwiftGenius.bundle

        if errorMode {
            super.init(errorDomain: "net.poikile.MockGenius", bundle: bundle)
        } else {
            super.init(bundle: bundle)
        }
    }

    public func account(responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusAccount.Response> {
        return apply(toJsonObjectIn: "get-account-200")
    }

    public func annotation(id: Int,
                           responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusAnnotation.Response> {
        return apply(toJsonObjectIn: "get-annotations-200")
    }

    public func artist(id: Int,
                       responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusArtist.Response> {
        return apply(toJsonObjectIn: "get-artists-200")
    }

    public func brokenRequest() -> Promise<String> {
        return apply(toJsonObjectIn: """
This file doesn't exist, so the promise returned by this function should be rejected.
""")
    }

    public func referents(forSongId id: Int,
                          responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusReferent.Response> {
        return apply(toJsonObjectIn: "get-referents-200")
    }

    public func search(terms: String,
                       responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusSearch.Response> {
        return apply(toJsonObjectIn: "get-search-200")
    }

    public func song(id: Int,
                     responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusSong.Response> {
        return apply(toJsonObjectIn: "get-songs-200")
    }

    public func songs(byArtistId artistId: Int,
                      sortOrder: GeniusSongSortOrder = .title,
                      resultsPerPage: Int = 20,
                      pageNumber: Int = 1,
                      responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusArtistSongs.Response> {
        return apply(toJsonObjectIn: "get-artist-songs-200")
    }

    public func webPage(id: Int,
                        responseFormats: [GeniusResponseFormat] = [.dom]) -> Promise<GeniusWebPage.Response> {
        return apply(toJsonObjectIn: "get-web-pages-200")
    }

}
