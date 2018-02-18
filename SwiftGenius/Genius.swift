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
    /// - parameter responseFormats: The desired format(s) of the user's
    ///             `aboutMe` property. It defaults to `.dom`.
    ///
    /// - returns: A `Promise` that yields a `GeniusAccount.Response` if the
    ///            request is successful, or an error if it wasn't.
    func account(responseFormats: [GeniusResponseFormat]) -> Promise<GeniusAccount.Response>

    /// Get a specific song lyric annotation.
    ///
    /// - parameter id: The annotation's ID.
    /// - parameter responseFormats: The desired format(s) of the user's
    ///             `aboutMe` property. It defaults to `.dom`.
    ///
    /// - returns: A `Promise` that yields a `GeniusAnnotation.Response` if
    ///            the request was successful, or an error if it isn't.
    func annotation(id: Int,
                    responseFormats: [GeniusResponseFormat]) -> Promise<GeniusAnnotation.Response>

    /// Get a specific artist.
    ///
    /// - parameter id: The artist's Genius ID. This can be obtained by
    ///                 searching for the artist, or from the corresponding
    ///                 field in a `GeniusSong`
    /// - parameter responseFormats: The desired format(s) of the user's
    ///             `aboutMe` property. It defaults to `.dom`.
    ///
    /// - returns: A `Promise` that yields a `GeniusArtist.Response` if the
    ///            request was successful, or an error if it isn't.
    func artist(id: Int,
                responseFormats: [GeniusResponseFormat]) -> Promise<GeniusArtist.Response>

    /// Get the annotated lyric segments of a specified song. **Genius.com does
    /// not have an API for getting *all* of a song's lyrics due to copyright
    /// restrictions.**
    ///
    /// - parameter id: The song's Genius ID.
    /// - parameter responseFormats: The desired format(s) of the user's
    ///             `aboutMe` property. It defaults to `.dom`.
    ///
    /// - returns: A `Promise` that yields a `GeniusReferent.Response` if the
    ///            request was successful, or an error if it isn't.
    func referents(forSongId id: Int,
                   responseFormats: [GeniusResponseFormat]) -> Promise<GeniusReferent.Response>

    /// Search for content on Genius.com. Search results are generally lists of
    /// songs that match, so that an artist search returns that artist's top
    /// *n* songs, an album search returns that album's songs, etc.
    ///
    /// - parameter responseFormats: The desired format(s) of the user's
    ///             `aboutMe` property. It defaults to `.dom`.
    ///
    /// - returns: A `Promise` that yields a `GeniusSearch.Response` if the
    ///            request was successful, or an error if it isn't.
    func search(terms: String,
                responseFormats: [GeniusResponseFormat]) -> Promise<GeniusSearch.Response>

    /// Get a specific song from the Genius database.
    ///
    /// - parameter id: The song's unique ID. This can be found in search
    ///             results or in corresponding fields from other Genius data
    ///             types.
    /// - parameter responseFormats: The desired format(s) of the user's
    ///             `aboutMe` property. It defaults to `.dom`.
    ///
    /// - returns: A `Promise` that yields a `GeniusSong.Response` if the
    ///            request was successful, or an error if it isn't.
    func song(id: Int,
              responseFormats: [GeniusResponseFormat]) -> Promise<GeniusSong.Response>

    /// Get all the songs by a specific artist. Unlike other Genius API calls,
    /// these results can be paged.
    ///
    /// - parameter byArtistId: The artist's Genius ID.
    /// - parameter sortOrder: Either by [SongSortOrder.popularity] or
    ///             [SongSortOrder.title].
    /// - parameter resultsPerPage: The number of songs to include in each
    ///             page of results.
    /// - parameter pageNumber: The index of the search results pages. These
    ///             start at 0.
    /// - parameter responseFormats: The desired format(s) of the user's
    ///             `aboutMe` property. It defaults to `.dom`.
    ///
    /// - returns: A `Promise` that yields a `GeniusArtistSongs.Response` if
    ///            the request was successful, or an error if it isn't.
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
