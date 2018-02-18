//  Copyright © 2018 Jason R Tibbetts. All rights reserved.

import Foundation
import PromiseKit

/// Protocol for clients of the Genius.com API (https://api.genius.com). Note
/// that no functions relating to authenticating with the genius.com server are
/// included in this protocol; they can be found in the `GeniusClient`
/// implementation instead.
public protocol Genius: class {

    /// Get the currently-authenticated user's account information.
    ///
    /// - parameter responseFormat: The desired format(s) of the user's
    ///             `aboutMe` property. It defaults to `.dom`.
    ///
    /// - returns: A `Promise` that yields a `GeniusAccount.Response` if the
    ///            request is successful, or an error if it wasn't.
    func account(responseFormats: [GeniusResponseFormat]) -> Promise<GeniusAccount.Response>

    /// Get a specific song lyric annotation.
    ///
    /// - parameter id: The annotation's ID.
    /// - parameter responseFormat: The desired format(s) of the user's
    ///             `aboutMe` property. It defaults to `.dom`.
    func annotation(id: Int,
                    responseFormats: [GeniusResponseFormat]) -> Promise<GeniusAnnotation.Response>

    /// - parameter responseFormat: The desired format(s) of the user's
    ///             `aboutMe` property. It defaults to `.dom`.
    func artist(id: Int,
                responseFormats: [GeniusResponseFormat]) -> Promise<GeniusArtist.Response>
    
    /// - parameter responseFormat: The desired format(s) of the user's
    ///             `aboutMe` property. It defaults to `.dom`.
    func referents(forSongId id: Int,
                   responseFormats: [GeniusResponseFormat]) -> Promise<GeniusReferent.Response>

    /// - parameter responseFormat: The desired format(s) of the user's
    ///             `aboutMe` property. It defaults to `.dom`.
    func search(terms: String,
                responseFormats: [GeniusResponseFormat]) -> Promise<GeniusSearch.Response>

    /// - parameter responseFormat: The desired format(s) of the user's
    ///             `aboutMe` property. It defaults to `.dom`.
    func song(id: Int,
              responseFormats: [GeniusResponseFormat]) -> Promise<GeniusSong.Response>

    /// - parameter responseFormat: The desired format(s) of the user's
    ///             `aboutMe` property. It defaults to `.dom`.
    func songs(byArtistId artistId: Int,
               sortOrder: SongSortOrder,
               resultsPerPage: Int,
               pageNumber: Int,
               responseFormats: [GeniusResponseFormat]) -> Promise<GeniusArtistSongs.Response>

}

/// The acceptable values for the `Genius` protocol's function that take a
/// `responseFormat` parameter.
public enum GeniusResponseFormat: String, Codable {
    case dom
    case html
    case plain
}

/// The acceptable values for the `sortOrder` parameter of the
/// `Genius.songs(byArtistId:sortOrder:resultsPerPage:pageNumber:responseFormat)`
/// function.
public enum SongSortOrder: String, Codable {
    case popularity
    case title
}
