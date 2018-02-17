//  Copyright © 2018 nrith. All rights reserved.

import Foundation
import PromiseKit

/// Protocol for clients of the Genius.com API (https://api.genius.com).
public protocol Genius: class {

    /// Get the currently-authenticated user's account information.
    ///
    /// - parameter responseFormat: The desired format(s) of the user's
    ///             `aboutMe` property. It defaults to `.dom`.
    func account(responseFormats: [GeniusResponseFormat]) -> Promise<GeniusAccount.Response>

    /// Get a specific song lyric annotation.
    ///
    /// - parameter id: The annotation's ID.
    /// - parameter responseFormat: The desired format(s) of the user's
    ///             `aboutMe` property. It defaults to `.dom`.
    func annotation(id: Int,
                    responseFormats: [GeniusResponseFormat]) -> Promise<GeniusAnnotation.Response>

    func artist(id: Int,
                responseFormats: [GeniusResponseFormat]) -> Promise<GeniusArtist.Response>
    
    func referents(forSongId id: Int,
                   responseFormats: [GeniusResponseFormat]) -> Promise<GeniusReferent.Response>

    func search(terms: String,
                responseFormats: [GeniusResponseFormat]) -> Promise<GeniusSearch.Response>

    func song(id: Int,
              responseFormats: [GeniusResponseFormat]) -> Promise<GeniusSong.Response>

    func songs(byArtistId artistId: Int,
               sortOrder: SongSortOrder,
               resultsPerPage: Int,
               pageNumber: Int,
               responseFormats: [GeniusResponseFormat]) -> Promise<GeniusArtistSongs.Response>

}

public enum GeniusResponseFormat: String, Codable {
    case dom
    case html
    case plain
}

public enum SongSortOrder: String, Codable {
    case popularity
    case title
}
